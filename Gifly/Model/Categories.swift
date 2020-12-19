//
//  Categories.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/19.
//

import Foundation

enum Categories: UInt, CaseIterable, Identifiable {
    case video
//    case livephoto
    case gif
//    case none

    var id: UInt { self.rawValue }
}
