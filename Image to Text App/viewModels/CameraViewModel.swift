//
//  CameraViewModel.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 19/03/24.
//

import Foundation
import PhotosUI

class CameraViewModel : NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var session: AVCaptureSession = AVCaptureSession()
    @Published var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    @Published var isCameraAvailable: Bool = false
    @Published var capturedImg: UIImage?
    
    var output: AVCapturePhotoOutput?
    
    func setUp() async{
        guard await isCameraAuthorized else{
            print("Permission to access camera is not granted.")
            return
        }
        
        guard await setUpCaptureSession() else{
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        
    }
    
    func takePic(){
        DispatchQueue.global(qos: .background).async{
            self.output!.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
        }
    }
    
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if error != nil {
            print("error: \n\(String(describing: error))")
        }
        guard let imageData = photo.fileDataRepresentation() else{
            print("Image is nil")
            return
        }
        self.capturedImg = UIImage(data: imageData)
    }
    
    func setUpCaptureSession() async -> Bool  {
        session.beginConfiguration()
        
        print("permission granted")
        guard let videoDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .unspecified
        ) else{
            print("No camera found.")
            isCameraAvailable = false
            return false
        }
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(videoDeviceInput)
        else{
            print("Can't add camera to capture session.")
            return false
        }
        session.addInput(videoDeviceInput)
        
        let photoOutput = AVCapturePhotoOutput()
        guard session.canAddOutput(photoOutput) else{
            print("Can't add photo output to capture session")
            return false
        }
        
        output = photoOutput
        session.addOutput(photoOutput)
        session.sessionPreset = .photo
        session.commitConfiguration()
        
        //Set up successful
        print("setup successful")
        isCameraAvailable = true
        return true
    }
    
    var isCameraAuthorized : Bool {
        get async{
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if (status == .notDetermined){
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            if (status == .denied){
                if let url = await URL(string: UIApplication.openSettingsURLString) {
                    await UIApplication.shared.open(url)
                }
            }
            return isAuthorized
        }
    }
}
