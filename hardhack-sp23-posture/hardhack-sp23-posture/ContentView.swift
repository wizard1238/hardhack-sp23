//
//  ContentView.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/15/23.
//

import SwiftUI
import AVFoundation
import Vision

struct ContentView: View, VisionControllerDelegate {
    private let session = AVCaptureSession()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // For view dimensions
    let visionController: VisionController = VisionController()
    @State var size: CGSize = CGSize(width: 0, height: 0)
    @State var points: [CGPoint] = []
    @State var median: Double = 0
    @State var thetas: [Double] = []
    @State var success: Bool = false
    
    func processPoints(imagePoints: [CGPoint]) {
        points = imagePoints
        
        points.sort(by: {
            return $0.y > $1.y // top one (0) is nose
        })
        print(points)
        if (points.count == 3 && (points[1].x - points[2].x) > 0) {
            thetas.append((points[1].x - points[2].x))
        }
        if (thetas.count > 20) {
            thetas.removeFirst()
            let newMedian: Double = thetas.sorted(by: >)[10]
            median = newMedian
        }
        if (median > 0) {
            print("straight")
            success = true
        }
    }
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
     func setUpCaptureSession() async {
        guard await isAuthorized else { return }
        session.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(visionController, queue: DispatchQueue(label: "com.hardhack.vision", attributes: .concurrent))
        visionController.delegate = self
        guard session.canAddOutput(videoOutput) else { return }
        session.sessionPreset = .hd1280x720
        session.addOutput(videoOutput)
        session.commitConfiguration()
        
        session.startRunning()
    }
    
    init() {
    }
    
    var body: some View {
        ZStack (alignment: .top){
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
            PreviewView(session: self.session)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                        HStack {}.onAppear(
                            perform: {size = proxy.size}
                        )
                    }
                )
                .task {
                    await setUpCaptureSession()
                    }
            Text("Face right side of screen\n Stand up straight!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(UIColor(named: "pastelGreen")!))
                .padding([.top], 20)
                .multilineTextAlignment(.center)
            Path { path in
                for point in points {
                    path.move(to: point)
                    path.addArc(center: point, radius: 10, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
                }
                path.closeSubpath()
            }
            .stroke(.blue, lineWidth: 10)
            .rotationEffect(Angle(degrees: 180))
            NavigationLink(destination:
                            SuccessView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
                           , isActive: $success, label: {
                Text("")
            })
        }
        .edgesIgnoringSafeArea(.all)
    }
}


