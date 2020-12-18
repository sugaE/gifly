//
//  ContentView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selection: Tab = .entrance
    
    enum Tab {
        case entrance
        case settings
    }

    var body: some View {
        TabView(selection: $selection,
            content:  {
                Entrance()
                    .tag(Tab.entrance)
                    .tabItem {
                        Label("Compose", systemImage: "pencil.and.outline")
                    }
                
                LandmarkList()
                    .tag(Tab.settings)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                
            })
            .onAppear {
                PHPhotoLibrary.requestAuthorization { (status) in
                   // No crash
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
