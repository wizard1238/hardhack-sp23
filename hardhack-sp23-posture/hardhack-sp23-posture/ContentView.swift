//
//  ContentView.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/15/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    private let session = AVCaptureSession()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // For view dimensions
    
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
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        guard session.canAddOutput(videoOutput) else { return }
        session.sessionPreset = .hd1280x720
        session.addOutput(videoOutput)
        session.commitConfiguration()
        
        session.startRunning()
    }
    
    init() {
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action: {
                Task {
                    await setUpCaptureSession()
                }
            }) {
                Text("Get permissions")
            }
        }
        PreviewView(session: self.session)
        .padding()
    }
}
