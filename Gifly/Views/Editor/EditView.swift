//
//  EditView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/17.
//

import SwiftUI

struct EditView: View {
    var type: String = "Livephoto"
    @State private var isImagePickerDisplay = false
    @State private var isImagePickerFinished = false
    @State private var selectedImages: [UIImage]  = []
     
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0){
            
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 30))
                    .padding(7)

                ZStack {
                    HStack {
                        if (selectedImages.count > 0) {
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
                
                if selectedImages.count > 0 && isImagePickerFinished {
    //                guard let selectedImage = selectedImage else { return }
    //                Image(uiImage: selectedImages[0])
    //                    .resizable()
    //                    .scaledToFill()
                    ImageAnimated(
                        imageSize: geo.size,
                        images: selectedImages,
                        duration: Double(selectedImages.count) / FRAME_COUNT)
//                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
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
                              
    //                        ImageAnimated(
    //                            imageSize: CGSize(width: 200, height: 200), imageNames: ["1","2","3"]
    //                            )
    //                            .frame(width: 200, height: 200, alignment: .center)

                            Text("ReSelect \(type)")
//                            Spacer()
                        }
                    })
                    .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
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
                
//                VStack {
//                    Image(systemName: "textbox")
//                        .font(.system(size: 40, weight: .light))
//                        .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    Text("Text")
//                }
                
            }
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.gray)
  
        }

        .sheet(isPresented: $isImagePickerDisplay, content: {
            PHPickerView(image: $selectedImages, isFinished: $isImagePickerFinished)
        })
        
        .navigationTitle("Edit")
        .navigationBarItems(trailing: NavigationTrailling(images: selectedImages))
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear(perform: {
//            self.isImagePickerDisplay = true
        })
        .onDisappear(perform: {
            self.isImagePickerDisplay = false
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
            EditView()//originalImage: UIImage(named: "Author")!
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
