//
//  ImageToTextViewModel.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 18/03/24.
//

import Foundation
import Vision
import PhotosUI
import SwiftUI

class ImageToTextViewModel : ObservableObject{
    @Published var extractedText: ExtractedTextState? = nil
    
    func extractTextFromImage(img: CGImage){
        let requestHandler = VNImageRequestHandler(cgImage: img)
        let request = VNRecognizeTextRequest(completionHandler: recognizedTextHandler)
//        DispatchQueue.global(qos: .userInitiated).async {
            do{
                try requestHandler.perform([request])
            }catch(let error as NSError){
                self.extractedText = ExtractedTextState(text: "", errorMessage: error.debugDescription)
            }
//        }
    }
    
    private func recognizedTextHandler(request: VNRequest, error: Error?) -> Void{
        if(error != nil){
            extractedText = ExtractedTextState(text: "", errorMessage: error.debugDescription)
        }
        guard let observations =
                request.results as? [VNRecognizedTextObservation]
        else{
            extractedText = ExtractedTextState(
                text: "",
                errorMessage: "Error parsing result to VNRecognizedTextObservation"
            )
            return
        }
        
        let result = observations.compactMap { obs in
            obs.topCandidates(1).first?.string ?? ""
        }
        extractedText = ExtractedTextState(text: result.joined(separator: "\n"), errorMessage: nil)
    }
    
}
