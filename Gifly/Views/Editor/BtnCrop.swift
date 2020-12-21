//
//  BtnCrop.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import SwiftUI

struct BtnCrop: View {
    @EnvironmentObject var md: ModelData
    @State var isPresented = false
    
    var body: some View {
         
        Button(action: {
            print("pressed")
            isPresented.toggle()
        }, label: {
            VStack {
                Image(systemName: "crop.rotate")
                    .font(.system(size: 40, weight: .light))
                    .frame(width: 60, height: 60, alignment: .center)
                Text("Crop")
            }
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        })
        .fullScreenCover(isPresented: $isPresented) {
            print("cancel")
        } content: {
            CropView()
        }
            
    }
}

struct BtnCrop_Previews: PreviewProvider {
    static var previews: some View {
        BtnCrop()
    }
}
