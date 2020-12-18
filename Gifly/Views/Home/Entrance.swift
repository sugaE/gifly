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
        GeometryReader { geo in
            let width_half = geo.size.width / 2 - 40
            
            NavigationView {
                
                VStack {
                    Image("Author")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        NavigationLink(destination: EditView()) {
                            VStack {
                                Image(systemName: "livephoto")
                                    .font(.system(size: width_half / 2))
                                Text("Livephoto to Gif")
                                    .font(.title3)
                            }
                            .frame(width: width_half, height: width_half, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.yellow)
                        }
//
                    }
                     
                    
                } 
                .navigationTitle("Hi, again")
                
            }
        }
        
    }
}

struct Entrance_Previews: PreviewProvider {
    static var previews: some View {
        Entrance()
    }
}
