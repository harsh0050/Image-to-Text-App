//
//  ContentView.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 18/03/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct SelectImageView: View {
    
    @StateObject var viewModel: SelectImageViewModel = SelectImageViewModel()
    
    @State private var path = [UIImage]()
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                HStack{
                    Image("batman-bg").resizable().scaledToFill()
                        .overlay{
                            Color(uiColor: .black).opacity(0.8)
                        }
                }.ignoresSafeArea()
                
                VStack {
                    Text("Image to Text").font(.largeTitle).bold()
                        .foregroundStyle(.white)
                    
                    Spacer()
                    IconButton(iconSystemName: "photo.on.rectangle") {
                        PhotosPicker(selection: $viewModel.imageSelection, matching: .images){
                            Text("Select image from storage")
                        }
                    }
                    
                    IconButton(iconSystemName: "camera.fill") {
                        Text("Capture image from Camera")
                    }.onTapGesture {
                        //Camera function
                    }
                    Spacer().frame(height: 20)
                }
                .navigationDestination(for: UIImage.self, destination: {uiImage in
                    if let cgImg = uiImage.cgImage{
                        DisplayTextView(image: cgImg)
                    }
                })
                .onChange(of: viewModel.loadedImage) {
                    if let loadedImage: UIImage = viewModel.loadedImage{
                        self.path = [loadedImage]
                    }
                }
            }
        }
    }
    
}

struct IconButton<Content>: View where Content: View{
    init(iconSystemName: String, @ViewBuilder content: @escaping () -> Content) {
        self.iconSystemName = iconSystemName
        self.content = content
    }
    
    var iconSystemName: String
    var content: () -> Content
    
    
    var body: some View{
        HStack {
            Image(systemName: self.iconSystemName).font(.title)
            content()
        }
        .foregroundStyle(.blue)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 1)
        )
    }
}

#Preview {
    SelectImageView()
}
