//
//  ScannerView.swift
//  QRCodeScanner
//
//  Created by Apple  on 21/04/23.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    
    ///QR Code Scanner Properties
    @State var isScanning:Bool = false
    @State var session:AVCaptureSession = .init()
    @State var cameraPermission:Permission = .idle
    ///QR Scanner AV output
    @State var qrOutput:AVCaptureMetadataOutput = .init()
    ///Error Properties
    @State var errorMessage:String = ""
    @State var showError:Bool = false
    @Environment(\.openURL) var openURL
    ///Camera QR Output Delegate
    @StateObject var qrDelegate = QRScannerDelegate()
    ///Scanned code
    @State var scannedCode:String = ""
    var body: some View {
        VStack{
            Button {
                print("x mark")
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(Color.blue)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            Text("Place QR Code inside the area")
                .font(.title3)
                .foregroundColor(Color.black.opacity(0.8))
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(Color.gray)
            
            Spacer(minLength: 0)
            
            ///Scanner
            GeometryReader{
                let size = $0.size
                
                ZStack{
                    CameraView(session: $session, frameSize: CGSize(width: size.width, height: size.width))
                    ///Making it little more smaller
                        .scaleEffect(0.97)
                    
                    ForEach(1...4,id: \.self){ index in
                        let rotation = Double(index)*90
                        RoundedRectangle(cornerRadius: 2,style: .circular)
                        ///Trimming to get scanner like edges
                            .trim(from: 0.61,to:0.64)
                            .stroke(Color.blue,style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                        
                    }
                }
                //Squareshape
                .frame(width: size.width,height: size.width)
                //Scanner Animation
                .overlay(alignment:.top){
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 2.5)
                        .shadow(color:Color.black.opacity(0.8), radius: 8,x:0,y: isScanning ? 15 : -15)
                        .offset(y:isScanning ? size.width : 0 )
                }
                
                ///To make it center
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
            .padding(.horizontal,45 )
            
            Spacer(minLength: 15)
            
            Button {
                print("scan button")
                if !session.isRunning && cameraPermission == .approved{
                    reActiateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
            }
            
            Spacer(minLength: 45)
            
            
            
        }//:Vstack
        .padding(15)
        /// Checking camera permission , when the view is Visible
        .onAppear{
            checkCameraPermission()
        }
        .alert(errorMessage,isPresented: $showError){
            /// Showing Settings button , if permission is denied
            if cameraPermission == .denied{
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL(string: settingsString){
                        ///Opening App's  Setting , Open URL Swift Ui  API
                        
                        openURL(settingsURL)
                    }
                }
                ///Along with cancel button
                Button("Cancel",role: .cancel){
                    
                }
            }
        }
        .onChange(of: qrDelegate.scannedCode) { newValue in
            if let code = newValue{
                scannedCode = code
                ///When the first code scan is available immediatiely stop the camera
                session.stopRunning()
                ///Stop scannr animation
                deActivateScannerAnimation()
                ///Clearing data on delegate
                qrDelegate.scannedCode = nil
            }
        }
        
    }
    
    //MARK: Functions
    
    ///Setting Up Camera
    func setUpCamera(){
        do{
            ///Finding back camera
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else{
                presentError("UNKNOWN DEVICE ERROR")
                return
            }
            
            ///Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            ///For Extra safety
            ///Checking whether input & output can added to session
            guard session.canAddInput(input),session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN INPUT/OUTPUT ERROR")
                return
            }
            
            ///Adding input & output to camera session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            ///Setting Out put config to read QR Codes
            qrOutput.metadataObjectTypes = [.qr]
            ///Adding delegate to retrive the Fetched QR Code from Camera
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            ///Note session must be started on background thread
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        }catch{
            presentError(error.localizedDescription)
        }
    }
    
    
    //Reactivate camera
    func reActiateCamera(){
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    
    ///Present Error Message
    func presentError(_ message:String){
        errorMessage = message
        showError.toggle()
    }
    
    ///Activating Scanner Animation Methods
    func activateScannerAnimation(){
        ///Adding delay for each reversal
        withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses:true)){
            isScanning = true
        }
        print(isScanning)
    }
    
    ///De-Activating Scanner Animation Methods
    func deActivateScannerAnimation(){
        ///Adding delay for each reversal
        withAnimation(.easeInOut(duration: 0.85) ){
            isScanning = false
        }
        print(isScanning)
    }
    
    /// Checking Camera Permissions
    func checkCameraPermission(){
        Task{
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty{
                    //New SetUp
                    setUpCamera()
                }else{
                    ///Already exsisting one
                    session.startRunning()
                }
            case .notDetermined:
                /// Requesting Camera Access
                if await AVCaptureDevice.requestAccess(for: .video){
                    ///Permission granded
                    cameraPermission = .approved
                }else{
                    ///Permission Denied
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera for scanning codes")
                }
            case .denied,.restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera for scanning codes")
            default :break
                
            }
        }
    }
    
    
}
