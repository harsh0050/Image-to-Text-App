//
//  DisplayTextView.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 18/03/24.
//

import SwiftUI
import Vision

struct DisplayTextView: View {
    @State var image: CGImage
    @StateObject private var viewModel: ImageToTextViewModel = ImageToTextViewModel()
    
    var body: some View {
        VStack(alignment: .leading){
            if(viewModel.extractedText == nil){
                ProgressView(label: {
                    Text("Extracting text")
                })
            }else{
                Text(viewModel.extractedText?.errorMessage ?? viewModel.extractedText?.text ?? "")
                Spacer()
            }
        }.task {
            viewModel.extractTextFromImage(img: image)
        }
    }
}

struct ExtractedTextState{
    let text: String
    let errorMessage: String?
}

struct DisplayTextView_Previews: PreviewProvider {
    static var previews: some View {
        let img = UIImage(named: "demoImage")
        if let cgImg = img?.cgImage{
            DisplayTextView(image: cgImg)
        }else{
            Text("error in prev img")
        }
    }
}
