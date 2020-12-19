//
//  ModelData.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import Foundation
import Combine
import Photos
import UIKit

final class ModelData: ObservableObject {
    @Published var landmarks: [Landmark] = load("landmarkData.json")
    @Published var profile = Profile.default
    
    @Published var parameters: Parameter = Parameter.default
//    @Published var phassets: [PHAsset]?
//    @Published var phasset: PHAsset?
    var video: AVAsset?
    @Published var isGenerating = false
    @Published var frames: [UIImage]?
    
    
    var hikes: [Hike] = load("hikeData.json")
    
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }
    
    var categories: [String: [Landmark]] {
        Dictionary(grouping: landmarks, by: {
            $0.category.rawValue
        })
    }
    
    func reload () -> Void {
        parameters = Parameter.default
    }
    
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
