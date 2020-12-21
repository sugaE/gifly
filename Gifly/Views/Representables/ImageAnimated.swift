//
//  ImageAnimated.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import Foundation
import UIKit
import SwiftUI

class RandomClass { }

struct ImageAnimated: UIViewRepresentable {
//    var geo: CGSize
    var calcsz: CGRect
    
//    let imageNames: [String]?
//    @State var images: [UIImage]?
//    @State var duration: Double//? = 0.5
    @EnvironmentObject var md: ModelData
      
//    private var previousSize: CGSize
//    private var previousImages: CGSize

    func makeUIView(context: Self.Context) -> UIView {
        
        print("[INFO]calcsz:\(calcsz),uiscreen:\(UIScreen.main)")

        let images = md.frames
        // view is necessary for the purpose of resize image
//        let containerView = UIView(frame: CGRect(x: 0, y: 0 , width: calcsz.width, height: calcsz.height))
        let  containerView = UIView()
        containerView.backgroundColor = .purple
        
//        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
//        let width = UIScreen.main.bounds.width
       
        let imgView = UIImageView(frame: calcsz)

        imgView.clipsToBounds = true
//        imgView.layer.cornerRadius = 5
        imgView.autoresizesSubviews = true
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = .black
         
        let duration = Double(images.count) / Double(md.parameters.fps)
//        imgView.image = UIImage.animatedImage(with: images, duration: duration)
        
        imgView.animationImages = images
        imgView.animationDuration = duration
        imgView.startAnimating()
         
//            ?.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        
        containerView.addSubview(imgView)
//
        return containerView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ImageAnimated>) {
//        guard let image = images?[0] else { return }
//        imageSize = image.size
        
        if md.isGenerating {
            return
        }
        print("[INFO] [View Update] updateImageAnimated, images:\(md.frames.count)")
        
        let imgView = uiView.subviews.first as! UIImageView
//        imgView.image = UIImage.animatedImage(with: md.frames, duration: duration)
        if md.frames.count != imgView.animationImages?.count {
            imgView.animationImages = md.frames
        }
        
        let duration = Double(md.frames.count) / Double(md.parameters.fps)
        if duration != imgView.animationDuration {
            imgView.animationDuration = duration
        }
         
        if !self.calcsz.equalTo(imgView.frame)  {
            imgView.frame = self.calcsz
//            imgView.frame(forAlignmentRect: <#T##CGRect#>)
        }
         
    }
}
