//
//  Parameter.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/18.
//

import Foundation
import SwiftUI
import CoreLocation

struct Parameter: Codable, Equatable {
    
    var fps: Int = Constants.FPS_DEFAULT
    var crop: CGRect?
     
//    var username: String
//    var prefersNotifications = true
//    var seasonalPhoto = Season.winter
//    var goalDate = Date()

    static let `default` = Parameter()

//    enum Season: String, CaseIterable, Identifiable {
//        case spring = "🌷"
//        case summer = "🌞"
//        case autumn = "🍂"
//        case winter = "☃️"
//
//        var id: String { self.rawValue }
//    }
}


