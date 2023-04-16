//
//  VisionController.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/15/23.
//

import Foundation
import AVFoundation
import CoreImage
import UIKit
import Vision

class VisionController: NSObject {
    var delegate: VisionControllerDelegate?
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        // Process each observation to find the recognized body pose points.
        observations.forEach { processObservation($0) }
    }
    
    func processObservation(_ observation: VNHumanBodyPoseObservation) {
        
        // Retrieve all points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.all) else { return }
        
        // Torso joint names in a clockwise ordering.
        let jointNames: [VNHumanBodyPoseObservation.JointName] = [
            .nose,
            .neck,
            .root
        ]
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = jointNames.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
            
            // Translate the point from normalized-coordinates to image coordinates.
            return VNImagePointForNormalizedPoint(point.location,
                                                  Int(444),
                                                  Int(666))
            
        }
        
        delegate?.processPoints(imagePoints: imagePoints)
    }
}

extension VisionController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer).oriented(.right)
        let image = CIContext(options: nil).createCGImage(ciimage, from: ciimage.extent)!
        
        let requestHandler = VNImageRequestHandler(cgImage: image)

        // Create a new request to recognize a human body pose.
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)

        do {
            // Perform the body pose-detection request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
    }
}

protocol VisionControllerDelegate {
    func processPoints(imagePoints: [CGPoint])
}
