//
//  Entrance.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI
import PhotosUI

struct Entrance: View {
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                let width_half = geo.size.width / 2 - 20
                ScrollView(showsIndicators: false){
                    VStack {
                        Image("default")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                         
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: width_half)),
//                            GridItem(.flexible()),
                        ], spacing: 10) { //HStack
                            BtnCategory(type: .livePhotos, icon: "livephoto", label: "Livephoto to Gif")
                            BtnCategory(type: .videos, icon: "video", label: "Video to Gif")
                            BtnCategory(type: .images, icon: "infinity.circle", label: "Gif to Gif")
                        }
                        .padding(10)
                    }
                    
                }
            }
            .navigationTitle("Hi, again")
        }
    }
}

struct Entrance_Previews: PreviewProvider {
    static var previews: some View {
        Entrance()
            .environmentObject(ModelData())
    }
}
