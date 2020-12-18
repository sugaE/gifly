//
//  NavigationTrailling.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import SwiftUI
import UIKit

struct NavigationTrailling: View {
    let images: [UIImage]?
    
    var body: some View {
        HStack {
            Button(action: {
                print("todo: grid pressed")
            }, label: {
                Image(systemName: "square.grid.3x3.fill")
            })
            
            Button("Next") {
                
                print("todo: next pressed")
//                var images = [UIImage]()
//                ["1","2","3"].forEach { imageName in
//                    if let img = UIImage(named: imageName) {
//                        images.append(img)
//                    }
//                }
                if let images = images, images.count > 0 {
                    UIImage.animatedGif(from: images)
                }
                
            }
//            .buttonStyle(images?.count > 0 ? PrimitiveButtonStyle: DefaultButtonStyle)
            
            
        }
        
    }
}

struct NavigationTrailling_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTrailling(images: [])
    }
}
