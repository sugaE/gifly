//
//  LivePhotoReader.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import Foundation
import MobileCoreServices
import PhotosUI


extension UIImage {
   
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(rect.size)
//        draw(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
