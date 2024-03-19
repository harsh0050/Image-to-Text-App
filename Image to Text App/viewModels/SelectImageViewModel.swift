//
//  SelectImageViewModel.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 18/03/24.
//

import Foundation
import SwiftUI
import PhotosUI

class SelectImageViewModel: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet{
            self.loadImage()
        }
    }
    @Published private(set) var loadedImage : UIImage? = nil
    
    private func loadImage(){
        guard let imageSelection = imageSelection else{
            print("no image selected")
            return
        }
        Task{
            if let data = try? await imageSelection.loadTransferable(type: Data.self){
                if let uiImage = UIImage(data: data){
                    DispatchQueue.main.async{
                        self.loadedImage = uiImage
                    }
                }else{
                    print("Failed to parse to UI Image")
                }
            }else {
                print("Failed")
            }
        }
        
        
    }
}
