//
//  BtnReselect.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import SwiftUI
import PhotosUI

struct BtnReselect: View {
    var type: PHPickerFilter? = .any(of: [.images, .videos])
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }, label: {
            VStack {
                Image(systemName: "plus.viewfinder")
                    .font(.system(size: 100, weight: .light))
                    .padding()
                Text("ReSelect")
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        })
        .sheet(isPresented: $isPresented, content: {
            PHPickerView(filter: type)
        })
    }
}

struct BtnReselect_Previews: PreviewProvider {
    static var previews: some View {
        BtnReselect(isPresented: Binding.constant(false))
            
    }
}
