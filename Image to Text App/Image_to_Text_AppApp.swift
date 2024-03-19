//
//  Image_to_Text_AppApp.swift
//  Image to Text App
//
//  Created by Harsh Bhikadiya on 18/03/24.
//

import SwiftUI

@main
struct Image_to_Text_AppApp: App {
    @State var displayCaptureImage = false
    
    var body: some Scene {
        WindowGroup {
            SelectImageView()
        }
    }
}
