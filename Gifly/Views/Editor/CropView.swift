//
//  CropView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/20.
//

import SwiftUI

struct CropView: View {
    
    @EnvironmentObject var md: ModelData
    @Environment(\.presentationMode) var presentationMode
     
    @State var calcrct: CGRect?
    @State var croprct: CGRect?// = CGRect()
    @State private var draggingAt: Alignment? = .none
    @State private var draggingDelta: CGPoint = .zero
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    if calcrct != nil  {
                        ImageAnimated(
                            calcsz: calcrct! //CGRect(x: 10, y: 10, width: 300, height: 200)
                        )
                        .frame(width: calcrct!.width, height: calcrct!.height, alignment: .center)
                        .border(Color.black)
                        .overlay(
                            Rectangle()
                                .fill(style: FillStyle.init(eoFill: true))
                                .foregroundColor(Color.black.opacity(0.5))
                        )
                        .overlay (
                            Rectangle()
                                .path(in: croprct!.intersection(calcrct!))
                                .stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 3)
                        )
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in 
                                    print("onChanged:\(value)")
                                    guard let croprct = croprct, let calcrct = calcrct else {return}
                                    
                                    if (draggingAt == .none) {
                                        if CGRect(x: croprct.minX, y: croprct.minY, width: croprct.width, height: 0).insetBy(dx: -Constants.CROP_THRESHOLD, dy: -Constants.CROP_THRESHOLD).contains(value.startLocation) {
                                            draggingAt = .top
                                        } else if CGRect(x: croprct.minX, y: croprct.maxY, width: croprct.width, height: 0).insetBy(dx: -Constants.CROP_THRESHOLD, dy: -Constants.CROP_THRESHOLD).contains(value.startLocation) {
                                            draggingAt = .bottom
                                        } else if CGRect(x: croprct.minX, y: croprct.minY, width: 0, height: croprct.height).insetBy(dx: -Constants.CROP_THRESHOLD, dy: -Constants.CROP_THRESHOLD).contains(value.startLocation) {
                                            draggingAt = .leading
                                        } else if CGRect(x: croprct.maxX, y: croprct.minY, width: 0, height: croprct.height).insetBy(dx: -Constants.CROP_THRESHOLD, dy: -Constants.CROP_THRESHOLD).contains(value.startLocation) {
                                            draggingAt = .trailing
                                        } else if croprct.contains(value.startLocation) {
                                            draggingAt = .center
                                            draggingDelta = CGPoint(x: croprct.origin.x - value.startLocation.x, y: croprct.origin.y - value.startLocation.y)
                                        }
                                    } else {
                                        switch draggingAt! {
                                        case .top:
                                            self.croprct!.origin.y = min(max(calcrct.minY, value.location.y), croprct.maxY - Constants.CROP_THRESHOLD * 2)
                                            self.croprct!.size.height = max(Constants.CROP_THRESHOLD * 2, croprct.maxY - self.croprct!.origin.y)
                                        case .bottom:
                                            self.croprct!.size.height = min(max(Constants.CROP_THRESHOLD * 2, value.location.y - croprct.origin.y), calcrct.maxY - croprct.minY)
                                        case .leading:
                                            self.croprct!.origin.x = min(max(calcrct.minX, value.location.x), croprct.maxX - Constants.CROP_THRESHOLD * 2)
                                            self.croprct!.size.width = max(Constants.CROP_THRESHOLD * 2, croprct.maxX - self.croprct!.origin.x)
                                        case .trailing:
                                            self.croprct!.size.width = min(max(Constants.CROP_THRESHOLD * 2, value.location.x - croprct.origin.x), calcrct.maxX - croprct.minX)
                                        case .center:
                                            self.croprct?.origin = CGPoint(x:  min(calcrct.maxX - croprct.width, max(calcrct.minX, value.location.x + draggingDelta.x)), y: min(calcrct.maxY - croprct.height, max(calcrct.minY,value.location.y + draggingDelta.y)))
                                        default:
                                            break
                                        }
                                        
                                    }
                                })
                                .onEnded({ (value) in
                                    draggingAt = .none
                                    draggingDelta = .zero
                                    print("onEnded:\(value)")
                                })
                        )
                        
                    } else {
                        ProgressView("loading...")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .onAppear(){
                    print("[INFO] geo onAppear: \(geo.size), \(geo.frame(in: .global))")
                    initiating(geosz: geo.size)
                }
                .onChange(of: geo.size, perform: { size in
                    print("[INFO] geo onChange: \(geo.size), \(geo.frame(in: .global))")
                    initiating(geosz: geo.size)
                })
                      
            }
            .padding(.horizontal, 20)
            
            .navigationTitle("Cropping")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: CropCancel(dismiss: dismiss), trailing: CropNext(confirm: confirm))
        }
             
    }
     
    
    func initiating(geosz: CGSize) {
        if geosz.equalTo(CGSize.zero) {
            return
        }
        if calcrct != nil {
            croprct = croprct ?? md.parameters.crop ?? calcrct
            return
        } 
        if md.parametersPrevious.crop != nil {
            calcrct = md.parametersPrevious.crop
            croprct = croprct ?? md.parameters.crop ?? calcrct
            return
        }
        
        let images = md.frames
        if images.count < 1 {
            return
        }
        print("[INFO] cropping: \(geosz))")

//        var maxsz: CGRect = CGRect(origin: CGPoint.zero, size: geosz)
//        maxsz = CGRect(x: max(0, maxsz.origin.x), y: max(0, maxsz.origin.y), width: min(geosz.width, maxsz.width), height: min(geosz.height, maxsz.height))

        let postersz = images[0].size
        let ws = geosz.width / postersz.width
        let hs = geosz.height / postersz.height
        let scale = min(ws, hs)
        let calcsz = CGSize(width: postersz.width * scale, height: postersz.height * scale)
        print("[INFO]max crop:\(calcsz)")
        
        calcrct = CGRect(origin: CGPoint.zero, size: calcsz)
        croprct = calcrct

        md.parameters.crop = croprct
        md.parametersPrevious.crop = croprct
        
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func confirm() {
        md.parameters.crop = self.croprct!.intersection(self.calcrct!)
        self.dismiss()
    }
    
}

struct CropNext: View {
    var confirm: () -> Void
    @EnvironmentObject var md: ModelData
    var body: some View {
        Button(action: {
            print("todo: checkmark pressed")
            confirm()
        }, label: {
            Image(systemName: "checkmark")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        })
    }
    
} 

struct CropCancel: View {
    var dismiss: () -> Void
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            HStack(spacing: 0) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.title3)
                Text("Cancel")
            }
        })
        
    }
}

struct CropView_Previews: PreviewProvider {
    static var previews: some View {
        CropView(calcrct: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)), croprct: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
            .environmentObject(ModelData())
            .frame(width: .infinity, height: .infinity)
    }
}
