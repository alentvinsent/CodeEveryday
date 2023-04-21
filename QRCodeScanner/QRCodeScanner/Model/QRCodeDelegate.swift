//
//  QRCodeDelegate.swift
//  QRCodeScanner
//
//  Created by Apple  on 21/04/23.
//

import SwiftUI
import AVKit


class QRScannerDelegate:NSObject,ObservableObject,AVCaptureMetadataOutputObjectsDelegate{
    @Published var scannedCode:String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first{
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            print(code)
            scannedCode = code
            
        }
    }
}
