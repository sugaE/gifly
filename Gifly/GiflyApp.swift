//
//  GiflyApp.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI
import Combine

@main
struct GiflyApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            Entrance()
                .environmentObject(modelData)
        } 
    }
    
    
}

//func subscribe() -> Void {
//    let lastPostLabelSubscriber = Subscribers.Assign(object: lastPostLabel, keyPath: \.text)
//    blogPostPublisher.subscribe(lastPostLabelSubscriber)
//}

