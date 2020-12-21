//
//  GifHelper.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/19.
//

import Foundation
import Photos
import MobileCoreServices
import UIKit

extension Helper {
    static func saveGif(from: ModelData) -> Void {
        let images = from.frames,
            parameters: Parameter = from.parameters,
            cropOriginal: CGRect = from.parametersPrevious.crop!
        let fileProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0],
        ]  as CFDictionary
        let frameProperties: CFDictionary = [
            kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFUnclampedDelayTime as String): 1.0 / Double(parameters.fps)],
//            kCGImagePropertyOrientation as String: 6
//            Double(selectedImages.count) / FRAME_COUNT)
        ] as CFDictionary

//        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let documentsDirectoryURL = Helper.generateFolderForLivePhotoResources()
        guard let fileURL = documentsDirectoryURL?.appendingPathComponent("\(NSUUID().uuidString).gif") else {
            print("[ERROR] file url error")
            return
        }

        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                
                for image in images {
                    if let resized = image.image(byDrawingImage: image, inRect: cropOriginal),
                       var cgImage = resized.cgImage {
                        // Perform cropping in Core Graphics
                        if let crop = parameters.crop { 
                            guard let cutImageRef: CGImage = cgImage.cropping(to: crop)
                            else {
                                print("Failed to finalize the image destination")
                                continue
                            }
                            cgImage = cutImageRef
                        }
                        
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, fileURL: fileURL, options: nil)
                }) { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("GIF has saved")
                    }
                }
                
                print("Url = \(fileURL)")
            } else {
                print("Failed to create the image destination")
            }
        }
        
    }
    
    
    static func loadGifIntoModel(from: PHAsset, modelData: ModelData) -> Void {

        DispatchQueue.main.async {
            modelData.isGenerating = true
            modelData.frames = []
        }
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true
        
        manager.requestImageDataAndOrientation(for: from, options: options) { (data, string, orientation, others) in
//            print("\(String(describing: data)),\(String(describing: string)),\(orientation),\(String(describing: others))")

            let imageSource = CGImageSourceCreateWithData(data! as CFData, nil)
            // Early return on failure!
            guard let imgsrc = imageSource else {
                print("Failed to `CGImageSourceCreateWithData` for animated GIF data \(String(describing: data))");
                Helper.cancelGeneratingStatus(of: modelData)
                return;
            }
            // Early return if not GIF!
            let imageSourceContainerType = CGImageSourceGetType(imgsrc);
            let isGIFData = UTTypeConformsTo(imageSourceContainerType!, kUTTypeGIF);
            if (!isGIFData) {
                print("Supplied data is of type \(String(describing: imageSourceContainerType)) and doesn't seem to be GIF data \(String(describing: data))");
                
                Helper.cancelGeneratingStatus(of: modelData)
                return;
            }
            
//            modelData.gif = imgsrc
             
//            // Iterate through frame images
            let imageCount = CGImageSourceGetCount(imgsrc);
//            var skippedFrameCount = 0;
//            NSMutableDictionary *delayTimesForIndexesMutable = [NSMutableDictionary dictionaryWithCapacity:imageCount];
            var frames = [UIImage]()
            var delayTime = 0.0
            for i in (0..<imageCount) {
                let frameImageRef = CGImageSourceCreateImageAtIndex(imgsrc, i, nil);
                if let frameImageRef = frameImageRef {
                    let frameImage = UIImage.init(cgImage: frameImageRef)
                    let frameProperties = CGImageSourceCopyPropertiesAtIndex(imgsrc, i, nil)! as NSDictionary
                    let framePropertiesGIF = frameProperties[kCGImagePropertyGIFDictionary] as! NSDictionary
                    delayTime = framePropertiesGIF[kCGImagePropertyGIFUnclampedDelayTime] as! Double
                    if (delayTime == 0) {
                        delayTime = framePropertiesGIF[kCGImagePropertyGIFDelayTime] as! Double;
                    }
                    frames.append(frameImage)
//                } else {
//                    skippedFrameCount += 1
                }
            }
            if frames.count > 0 {
                DispatchQueue.main.async {
                    modelData.gif = frames
                    modelData.parameters.fps = Int(1 / delayTime)
                    modelData.parametersPrevious = modelData.parameters
                    modelData.frames = frames
                    modelData.isGenerating = false
                }
            } else {
                print("[Warning] no frames for gif")
                Helper.cancelGeneratingStatus(of: modelData)
            }
            
        }
        
    }
    
    
    static func generateImagesFromGifIntoModel(modelData: ModelData) -> Void {
        guard let gif = modelData.gif else {
            return
        }
         
//        let framesOriginal = modelData.gif
        let prefps = modelData.parametersPrevious.fps
        let curfps = modelData.parameters.fps
        
        if prefps < curfps {
            print("[WARNING] cannot perform change")
//            todo show toast
            return
        }
        
        DispatchQueue.main.async {
            modelData.isGenerating = true
        }
         
        var frames = [UIImage]()
        let count = Int(ceilf(Float(gif.count) / Float(prefps) * Float(curfps)))
        //fps
        for i in 0..<count {
            frames.append(gif[Int(Float(i * gif.count) / Float(count))])
        }
        
        DispatchQueue.main.async {
            modelData.isGenerating = false
            modelData.frames = frames
        }
        
        
    }
    
}
