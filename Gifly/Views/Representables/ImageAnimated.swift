//
//  ImageAnimated.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import Foundation
import UIKit
import SwiftUI
 
struct ImageAnimated: UIViewRepresentable {
    var imageSize: CGSize
//    let imageNames: [String]?
    @State var images: [UIImage]?
    let duration: Double//? = 0.5
    
//    private var previousSize: CGSize
//    private var previousImages: CGSize

    func makeUIView(context: Self.Context) -> UIView {

//        var images = [UIImage]()

//        guard let images = images else {
//            if let imageNames = imageNames {
//                images = [UIImage]()
//                imageNames.forEach { imageName in
//                    if let img = UIImage(named: imageName) {
//                        imgs.append(img)
//                    }
//                }
//                return imgs
//            }
//            return nil
//        }
         
        
        // view is necessary for the purpose of resize image
        let containerView = UIView(frame: CGRect(x: 0, y: 0 , width: imageSize.width, height: imageSize.height))
        let animationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
//        let width = UIScreen.main.bounds.width
//        let containerView = UIView(frame: CGRect(x: 0, y: 0 , width: width, height: width))
//        let animationImageView = UIImageView(frame: CGRect(x: 0, y: 0 , width: imageSize.width, height: imageSize.height))

        animationImageView.clipsToBounds = true
//        animationImageView.layer.cornerRadius = 5
        animationImageView.autoresizesSubviews = true
        animationImageView.contentMode = .scaleAspectFit

        animationImageView.image = UIImage.animatedImage(with: images!, duration: duration)
//            ?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        
        containerView.addSubview(animationImageView)
        
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ImageAnimated>) {
//        guard let image = images?[0] else { return }
//        imageSize = image.size
        print("[INFO] [View Update] updateImageAnimated, images:\(images?.count ?? 0)")
        
        
    }
}
