//
//  CameraView.swift
//  QRCodeScanner
//
//  Created by Apple  on 21/04/23.
//

import SwiftUI
import AVKit


//Camera View Using AVCaptureVideoPreviewLayer
struct CameraView: UIViewRepresentable {
    
    ///Camera Session
    @Binding var session:AVCaptureSession
    var frameSize:CGSize
    func makeUIView(context: Context) ->  UIView {
        //Defining Camera Frame
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin:.zero,size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

