//
//  CustomImageView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation
import Combine
import SwiftUI

struct CustomImageView: View {
    @ObservedObject var imageUrl: ImageDownloader
    
    init(imageUrl: String) {
        self.imageUrl = ImageDownloader(imageUrl: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: (self.imageUrl.imageData.isEmpty ? UIImage(imageLiteralResourceName: "placeholder") : UIImage(data: self.imageUrl.imageData)) ?? UIImage(imageLiteralResourceName: "placeholder"))
    }

}
