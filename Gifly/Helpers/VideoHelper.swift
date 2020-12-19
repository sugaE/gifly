//
//  VideoHelper.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/18.
//

import Foundation
import Photos
import UIKit
//import SwiftUI
import Combine
import MobileCoreServices
 
    
struct Helper {
//    var modelData: ModelData
     
    static func loadVideoIntoModel(from: PHAsset, modelData: ModelData) -> Void {
        
        let manager = PHImageManager.default()
        let options = PHVideoRequestOptions()
        options.deliveryMode = PHVideoRequestOptionsDeliveryMode.fastFormat
        options.isNetworkAccessAllowed = true
        manager.requestAVAsset(forVideo: from, options: options) { avasset, audio, other  in
            print("voila")
            if let avasset = avasset {
                modelData.video = avasset
                generateImagesFromVideoIntoModel(modelData: modelData)
            } else {
                print("[ERROR] fail to load video \(other?.debugDescription ?? "")")
            }
            
        }
    }
    
    static func loadLivephotoIntoModel(from: PHAsset, modelData: ModelData) -> Void {
    
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = true
        
        PHAssetResource.assetResources(for: from).forEach { (resource) in
            if resource.type == .pairedVideo {
                
                let buffer = NSMutableData()
                let option = PHAssetResourceRequestOptions()
                option.isNetworkAccessAllowed = true
                PHAssetResourceManager.default().requestData(for: resource, options: option) { (chunk) in
                    buffer.append(chunk)
                } completionHandler: { (err) in
                    saveAssetResource(resource: resource, buffer: buffer, maybeError: err) { (url, err) in
                        if let err = err {
                            print("[ERROR] saveAssetResource \(err)")
                            return
                        }
                        
                        let avasset = AVAsset.init(url: url)
                        modelData.video = avasset
                        generateImagesFromVideoIntoModel(modelData: modelData)
                        
                    }
                }
            }
           
        }
        
    }
    
    static func fileExtension(for dataUTI: String) -> String? {
        guard let fileExtension = UTTypeCopyPreferredTagWithClass(dataUTI as CFString, kUTTagClassFilenameExtension) else {
            return nil
        }

        return String(fileExtension.takeRetainedValue())
    }
    
    
    static func saveAssetResource(
        resource: PHAssetResource,
        buffer: NSMutableData?,
        maybeError: Error?,
        completionHandler: @escaping (URL, Error?) -> Void
        ) -> Void {
        
        guard let inDirectory = generateFolderForLivePhotoResources() else { return }
        
        guard maybeError == nil else {
            print("Could not request data for resource: \(resource), error: \(String(describing: maybeError))")
            return
        }

        let maybeExt = fileExtension(for: resource.uniformTypeIdentifier)

        guard let ext = maybeExt else {
            return
        }

        guard var fileUrl = inDirectory.appendingPathComponent(NSUUID().uuidString) else {
            print("file url error")
            return
        }

        fileUrl = fileUrl.appendingPathExtension(ext as String)

        if let buffer = buffer, buffer.write(to: fileUrl, atomically: true) {
            print("Saved resource form buffer \(resource) to filepath: \(String(describing: fileUrl))")
            completionHandler(fileUrl, nil)
        } else {
            PHAssetResourceManager.default().writeData(for: resource, toFile: fileUrl, options: nil) { (error) in
                print("Saved resource directly \(resource) to filepath: \(String(describing: fileUrl))")
                completionHandler(fileUrl, error)
            }
        }
    }

    static func generateFolderForLivePhotoResources() -> NSURL? {
        let photoDir = NSURL(
            // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
            fileURLWithPath: NSTemporaryDirectory(),
            isDirectory: true
            ).appendingPathComponent(NSUUID().uuidString)

        let fileManager = FileManager()
        // we need to specify type as ()? as otherwise the compiler generates a warning
        let success : ()? = try? fileManager.createDirectory(
            at: photoDir!,
            withIntermediateDirectories: true,
            attributes: nil
        )

        return success != nil ? photoDir! as NSURL : nil
    }
   
    
    
    
    static func generateImagesFromVideoIntoModel(modelData: ModelData) -> Void {
        DispatchQueue.main.async {
            modelData.frames = []
            modelData.isGenerating = true
        }
        
        guard let avasset = modelData.video else { return }
        let imageGenerator = AVAssetImageGenerator(asset: avasset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
//                let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
//                var actualTime = CMTime.zero
        var times = [NSValue]()
        let fps = modelData.parameters.fps
        for i in 0..<Int(avasset.duration.seconds) * fps {
            let timetmp = CMTimeMake(value: Int64(i), timescale: Int32(fps))
            times.append(NSValue(time: timetmp))
        }
        var timeslen = times.count
        var images = [UIImage]()
         
        imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (cmtime1, cgImage, cmtime2, result, error) in
            
            if let error = error {
                print("[ERR] generateCGImagesAsynchronously: \(error)")
                timeslen -= 1
            }
            print("[INFO] image \(images.count): req:\(cmtime1.seconds) get: \(cmtime2.seconds)")
            guard let cgImage = cgImage, result == AVAssetImageGenerator.Result.succeeded else { return }
            images.append(UIImage(cgImage: cgImage))

            if timeslen == images.count {
                
                DispatchQueue.main.async {
                    modelData.frames = images
                    modelData.isGenerating = false
                }
                
            }
        })
    }

}
