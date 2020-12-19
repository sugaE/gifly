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
            
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 30))
                    .padding(7)

                ZStack {
                    HStack {
                        if (selectedImages.count > 0) {
                            // todo
                            ForEach (selectedImages.prefix(8), id:\.self) { n in
                                Image(uiImage: n)
                                    .resizable()
                                    .scaledToFill()
                                    .padding(.leading, -8)
                            }
                        } else {
                            
                            ForEach(0..<8) { i in
                                Image("hiddenlake")
                                    .resizable()
                                    .scaledToFill()
                                    .padding(.leading, -8)
                            }
                        }
                    }
                    .frame(height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.leading, 28)
                    .padding(.trailing, 20)
                    
                    
                    Image(systemName: "minus.square.fill")
                        .font(.system(size: 30))
                        .padding(7)
                        .rotationEffect(.degrees(90))
                        .scaleEffect(x: 0.5, y: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                            .foregroundColor(.white)
                }
                .background(Color.blue)
                     
            }
            .padding(.horizontal)
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.red)
            
            GeometryReader { geo in
                
                if selectedImages.count > 0  {
                    ImageAnimated(
                        imageSize: geo.size
//                        md: md
                    )
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                } else {
                    Button(action: {
                        self.isImagePickerDisplay = true
                    }, label: {
                        VStack {
//                            Spacer()
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 100, weight: .light))
                                .padding()
                            Text("ReSelect")
//                            Spacer()
                        }
                        .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .sheet(isPresented: $isImagePickerDisplay, content: {
                        PHPickerView(filter: type)
                    })
                    
                }
                
            }
            .background(Color.green)
            
 
            HStack {
                VStack {
                    Image(systemName: "crop.rotate")
                        .font(.system(size: 40, weight: .light))
                        .frame(width: 60, height: 60, alignment: .center)
                    Text("Crop")
                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                
                BtnFPS()
                
            }
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.gray)
  
        }

        
        .navigationTitle("Edit")
        .navigationBarItems(trailing: NavigationTrailling())
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear(perform: {
            print("[INFO][UI][EditView]onAppear")
            self.isImagePickerDisplay = true
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
            "iPhone 6s"
        ], id: \.self)
        {
            deviceName in
            EditView(type: .videos)//originalImage: UIImage(named: "Author")!
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
