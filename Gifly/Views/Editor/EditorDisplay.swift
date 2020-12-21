//
//  EditorDisplay.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import SwiftUI

struct EditorDisplay: View {
    @EnvironmentObject var md: ModelData
    @Environment(\.presentationMode) var presentationMode
     
    @State private var draggingAt: Alignment? = .none
    @State private var draggingDelta: CGPoint = .zero
    @State private var geosz: CGSize = .zero
    
    @State private var savedCrop: CGRect?
      
    private var calcrct: Binding<CGRect?> { Binding (
        get: { getCalcsz() },
        set: { _ in }
    )}
     
    private var transformComputed: Binding<CGAffineTransform> { Binding (
      get: {
        guard let crop = md.parameters.crop, let calcrct = calcrct.wrappedValue else { return .identity }
          let scaler :CGFloat = min(calcrct.width / crop.width, calcrct.height / crop.height)
          return CGAffineTransform(a: scaler, b: 0, c: 0, d: scaler, tx: (calcrct.minX - crop.minX) * scaler + (calcrct.width - crop.width * scaler) / 2, ty: (calcrct.minY - crop.minY ) * scaler  + (calcrct.height - crop.height * scaler) / 2)
      },
      set: { _ in }
    )}
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let calcrct = calcrct.wrappedValue, let crop = md.parametersPrevious.crop  {
                    ZStack {
                        ImageAnimated(
                            calcsz: crop //CGRect(x: 10, y: 10, width: 300, height: 200)
                        )
                        .frame(width: crop.width, height: crop.height, alignment: .center)
                        .clipShape(
                            Rectangle()
                                .path(in: md.parameters.crop ?? calcrct)
                        )
                        .overlay(Circle().fill(Color.yellow).frame(width: 10, height: 10))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        .transformEffect(transformComputed.wrappedValue)
                    } 
                    .transformEffect(CGAffineTransform(translationX: crop.midX - calcrct.midX, y: crop.midY - calcrct.midY))
                    .border(Color.blue)
                
                } else {
                    ProgressView("loading...")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
//            .onAppear(){
//                print("[INFO] geo onAppear: \(geo.size), \(geo.frame(in: .global))")
//                self.geosz = geo.size
//            }
//            .onChange(of: geo.size, perform: { size in
//                print("[INFO] geo onChange: \(geo.size), \(geo.frame(in: .global))")
//                self.geosz = geo.size
//            })
            .bindGeometry(to: $geosz.width) { $0.size.width }
            .bindGeometry(to: $geosz.height) { $0.size.height }
                  
        }
        .padding(20)
        .background(Color.green)
    }
       
    func getCalcsz() -> CGRect? {
        if geosz.equalTo(CGSize.zero) {
            return nil
        }
        
        let images = md.frames
        if images.count < 1 {
            return nil
        } 
        print("[INFO] cropping: \(geosz))")
  
        let postersz = md.parameters.crop?.size ?? images[0].size
        let ws = geosz.width / postersz.width
        let hs = geosz.height / postersz.height
        let scale = min(ws, hs)
        let calcsz = CGSize(width: postersz.width * scale, height: postersz.height * scale)
        
        print("[INFO]max crop:\(calcsz)")
        let rct = CGRect(origin: CGPoint.zero, size: calcsz)//.intersection(maxsz)
        
        if (md.parametersPrevious.crop == nil) {
            md.parametersPrevious.crop = rct
        }
        
        return rct
   }
   
}

struct EditorDisplay_Previews: PreviewProvider {
    static var previews: some View {
        EditorDisplay()
            .environmentObject(ModelData())
            .frame(width: .infinity, height: .infinity)
    }
}
