//
//  PreviewView.swift
//  hardhack-sp23-posture
//
//  Created by Jeremy Tow on 4/15/23.
//

import SwiftUI
import UIKit
import AVFoundation

class UIPreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
}

struct PreviewView: UIViewRepresentable {
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> some UIView {
        let previewView:UIPreviewView = UIPreviewView()
        previewView.videoPreviewLayer.session = self.session
        return previewView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let uiView as
        uiView.videoPreviewLayer.session = self.session
    }
}
