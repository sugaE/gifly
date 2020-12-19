//
//  CategoryBtn.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/19.
//

import SwiftUI
import PhotosUI

struct BtnCategory: View {
    let type: PHPickerFilter?
    let icon: String
    let label: String
    
    var body: some View {
        
        NavigationLink(destination: EditView(type: type)) {
//            Group
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88)
                    .scaledToFit()
                
                Text(label)
                    .font(.title3)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 1, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 1, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .scaledToFit()
            .background(Color.yellow)
             
            
        }
        
        .scaledToFit()
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        
//
    }
     
}

struct BtnCategory_Previews: PreviewProvider {
    static var previews: some View {
        BtnCategory(type: .images, icon: "", label: "" )
    }
}
