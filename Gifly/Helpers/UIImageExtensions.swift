//
//  LivePhotoReader.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import Foundation
import UIKit
import ImageIO
import MobileCoreServices
import PhotosUI


extension UIImage {
    static func animatedGif(from images: [UIImage], parameters: Parameter) -> URL? {
        let fileProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0],
        ]  as CFDictionary
        let frameProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFUnclampedDelayTime as String): 1.0 / Double(parameters.fps)],
//            kCGImagePropertyOrientation as String: 6
//            Double(selectedImages.count) / FRAME_COUNT)
        ] as CFDictionary

        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")

        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, fileURL: fileURL!, options: nil)
                }) { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("GIF has saved")
                    }
                }
                
                print("Url = \(fileURL)")
                return fileURL!
            }
        }
        return nil
    }
    
    
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
