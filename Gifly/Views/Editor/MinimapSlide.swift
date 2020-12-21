//
//  MinimapSlide.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import SwiftUI

struct MinimapSlide: View {
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        
        HStack {
            Image(systemName: "play.fill")
                .font(.system(size: 30))
                .padding(7)
            
            GeometryReader { geo in
                ZStack {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                        if (selectedImages.count > 0) {
                            // todo
                            ForEach (selectedImages.prefix(8), id:\.self) { n in
                                Image(uiImage: n)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (geo.size.width - 40) / 8)
                                    .clipped()
                            }
                        } else {
                            ForEach(0..<8) { i in
                                Image("default")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (geo.size.width - 40) / 8)
                                    .clipped()
                            }
                        }
                    }
    //                    .frame( alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal, 20)
                     
                }
                .background(Color.yellow)
            }
                 
        }
        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
        .background(Color.red)
        .padding(.horizontal, 10)
    }
}

struct MinimapSlide_Previews: PreviewProvider {
    static var previews: some View {
        MinimapSlide(selectedImages: Binding.constant(ModelData().frames))
    }
}
