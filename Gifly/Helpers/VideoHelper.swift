//
//  VideoHelper.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/18.
//

import Foundation
import Photos
import UIKit

    
extension Helper {
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
     
    
    static func generateImagesFromVideoIntoModel(modelData: ModelData) -> Void {
        DispatchQueue.main.async {
            modelData.isGenerating = true
            modelData.frames = []
        }
        
        guard let avasset = modelData.video else {
            Helper.cancelGeneratingStatus(of: modelData)
            return
        }
        let imageGenerator = AVAssetImageGenerator(asset: avasset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
//                let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
//                var actualTime = CMTime.zero
        var times = [NSValue]()
        let fps = modelData.parameters.fps
        for i in 0...Int(avasset.duration.seconds  * Double(fps)) {
            let timetmp = CMTimeMake(value: Int64(i), timescale: Int32(fps))
            times.append(NSValue(time: timetmp))
        }
        var timeslen = times.count
        var images = [UIImage]()
        
        imageGenerator.cancelAllCGImageGeneration()
        imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (cmtime1, cgImage, cmtime2, result, error) in
            
            print("[INFO] image \(images.count): req:\(cmtime1.seconds) get: \(cmtime2.seconds)")
            guard let cgImage = cgImage, result == AVAssetImageGenerator.Result.succeeded else {
                if let error = error {
                    print("[ERR] generateCGImagesAsynchronously: \(error)")
                    timeslen -= 1
                }
                
                Helper.cancelGeneratingStatus(of: modelData)
                return
            }
            images.append(UIImage(cgImage: cgImage))

            if timeslen == images.count {
                
                DispatchQueue.main.async {
                    modelData.frames = images
                    modelData.isGenerating = false
                }
                
            } else {
                
                print("[Warning] no frames for video")
                Helper.cancelGeneratingStatus(of: modelData)
            }
        })
    }

}
