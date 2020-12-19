//
//  BtnFPS.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/18.
//

import SwiftUI

struct BtnFPS: View {
    @EnvironmentObject var md: ModelData
    @State var isPresent = false
    
    var body: some View {
        Button(action: {
            print("pressed")
            isPresent.toggle()
        }, label: {
            VStack {
                Text("\(md.parameters.fps)")
                    .font(.system(size: 40, weight: .light))
                    .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("FPS")
            }
        })
        .actionSheet(isPresented: $isPresent) {
            var btns = [5, 10, 15, 20, 24, 30].filter({ (i) -> Bool in
                !(md.category == Categories.gif && i > md.parametersPrevious.fps)
            }).map { (i) in
                getBtn(data: md, withFps: i)
            }
            btns.append(.cancel())
            return ActionSheet(
                title: Text("Change FPS"),
                message: Text("This will discard any edits on current video"),
                buttons: btns)
        }
        
    }
}

func getBtn(data: ModelData, withFps: Int) -> ActionSheet.Button {
    return ActionSheet.Button.default(Text("\(withFps) FPS"), action: {
//        data.parametersPrevious.fps = data.parameters.fps
        data.parameters.fps = withFps
//        Helper.generateImagesFromVideoIntoModel(modelData: data)
    })
}
 
struct BtnFPS_Previews: PreviewProvider {
    static var previews: some View {
        BtnFPS()
    }
}
