//
//  ModelData.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import Foundation
import Combine
import PhotosUI
import UIKit

final class ModelData: ObservableObject {
    // for onchange use
//    static func == (lhs: ModelData, rhs: ModelData) -> Bool {
//        if lhs.parameters == rhs.parameters
//        {
//            return true
//        }
//        print("[!=]")
//        return false
//    }
    
//    @Published var landmarks: [Landmark] = load("landmarkData.json")
//    @Published var profile = Profile.default
    
    @Published var parameters: Parameter
    var parametersPrevious: Parameter
//    @Published var phassets: [PHAsset]?
//    @Published var phasset: PHAsset?
    @Published var isGenerating: Bool
    @Published var frames: [UIImage]
    
    var category: Categories?
    var video: AVAsset?
    var gif: [UIImage]?
    
    init() {
        parameters = .default
        parametersPrevious = .default
        isGenerating = false //todo abort all generating
        frames = []
        category = .none
    }
    
    func reload (oftype: PHPickerFilter?) -> Void {
        parameters = .default
        parametersPrevious = .default
        video = nil
        gif = nil
        isGenerating = false //todo abort all generating
        frames = []
        category = getCategory(oftype: oftype)
    }
    
//    var hikes: [Hike] = load("hikeData.json")
    
//    var features: [Landmark] {
//        landmarks.filter { $0.isFeatured }
//    }
//
//    var categories: [String: [Landmark]] {
//        Dictionary(grouping: landmarks, by: {
//            $0.category.rawValue
//        })
//    }
    private func getCategory(oftype: PHPickerFilter?) -> Categories? {
        switch oftype {
        case PHPickerFilter.livePhotos:
            return .video
        case PHPickerFilter.videos:
            return .video
        case PHPickerFilter.images:
            return .gif
        default:
            return .none
        }
    }

    
}


//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//    else {
//        fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
