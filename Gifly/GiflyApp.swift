//
//  GiflyApp.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI

@main
struct GiflyApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
