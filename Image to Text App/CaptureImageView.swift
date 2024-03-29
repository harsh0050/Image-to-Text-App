//
//  CaptureImageView.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 19/03/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct CaptureImageView: View {
    @StateObject var viewModel: CameraViewModel = CameraViewModel()
    @Binding var navPath: NavigationPath
    var body: some View {
        ZStack{
            if(self.viewModel.isCameraAvailable){
                PreviewView(cameraViewModel: self.viewModel)
            }else{
                
                ZStack(alignment: .center){
                    Color(.black)
                    Text("No Camera Found.").foregroundStyle(.white)
                }.ignoresSafeArea()
            }
            
            VStack{
                Spacer()
                Button(action: {
                    if(self.viewModel.isCameraAvailable){
                        viewModel.takePic()
                    }
                }, label: {
                    Image(systemName: "camera.circle").tint(.white).font(.system(size: 50))
                }).padding(.bottom, 30)
            }
            
            
        }.task {
            await self.viewModel.setUp()
            
        }.onChange(of: self.viewModel.capturedImg){
            guard viewModel.capturedImg != nil else {
                return
            }
            navPath.append(viewModel.capturedImg!)
            
        }
    }
}

struct PreviewView : UIViewRepresentable{
    @ObservedObject var cameraViewModel : CameraViewModel
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        cameraViewModel.previewLayer.frame = view.frame
        cameraViewModel.previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.global(qos: .background).async {
            cameraViewModel.session.startRunning()
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


#Preview {
    CaptureImageView(navPath: .constant(.init()))
}
