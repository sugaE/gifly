//
//  Handles.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import Foundation

struct Handles {
    
    static func handleChangeParameters(of: ModelData) -> Void {
        if of.isGenerating {
            print("[WARNING] is generating")
            return
        }
        switch of.category {
        case .video:
            Helper.generateImagesFromVideoIntoModel(modelData: of)
        case .gif:
            Helper.generateImagesFromGifIntoModel(modelData: of)
        default:
            print("nothing todo")
        }
    }
}
