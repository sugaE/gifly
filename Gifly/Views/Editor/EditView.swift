//
//  EditView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import SwiftUI
import PhotosUI

struct EditView: View {
    var type: PHPickerFilter?
    
    @EnvironmentObject var md: ModelData
    @State private var isImagePickerDisplay = false
//    @State private var isImagePickerFinished = false
//    @State private var selectedImages: [UIImage]  = []
     
    
    var body: some View {
        let selectedImages = md.frames
        
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0){
            // use first value
            MinimapSlide(selectedImages: selectedImages)
                
            if md.frames.count > 0  {
                
//                GeometryReader { geo in
                EditorDisplay()
//                    Text("TODO uncomment")
//                }
                
            } else { 
                BtnReselect(type: type, isPresented: $isImagePickerDisplay)
            }
                 
            HStack {
                BtnCrop()
                BtnFPS()
            }
            .disabled(md.frames.count < 1)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.gray)
        }

        
        .navigationTitle("Edit")
        .navigationBarItems(trailing: NavigationTrailling())
        .navigationBarTitleDisplayMode(.inline) 
        
        .onAppear(perform: {
            print("[INFO][UI][EditView]onAppear")
//            self.isImagePickerDisplay = true //todo uncomment
            md.reload(oftype: type)
        })
        .onDisappear(perform: {
            print("[INFO][UI][EditView]onDisappear")
            self.isImagePickerDisplay = false
        })
        .onChange(of: md.parameters, perform: { value in
            print("[INFO]fps:from \(md.parameters.fps), to\(value.fps)")
            Handles.handleChangeParameters(of: md)
        })
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach([
            "iPhone 11",
//            "iPhone 6s"
        ], id: \.self)
        {
            deviceName in
            EditView()//type: .videos originalImage: UIImage(named: "Author")!
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(ModelData())
        }
    }
}
