//
//  LivephotoHelper.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/19.
//

import Foundation
import Photos 


extension Helper {
    
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
}
