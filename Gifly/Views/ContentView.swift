//
//  ContentView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
