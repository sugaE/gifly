//
//  BindingGeometry.swift
//  Gifly
//
//ref: http://danielsaidi.com/blog/2020/03/25/bind-view-geometry-data-to-bindable-properties
// usage: Text("Hello!").bindGeometry(to: $textHeight) { $0.size.height }

//  Created by 女王様 on 2020/12/21.
//

import Foundation
import SwiftUI

public extension View {
    
    /**
     Bind any `CGFloat` value within a `GeometryProxy` value
     to an external binding.
     */
    func bindGeometry(
        to binding: Binding<CGFloat>,
        reader: @escaping (GeometryProxy) -> CGFloat) -> some View {
        self.background(GeometryBinding(reader: reader))
            .onPreferenceChange(GeometryPreference.self) {
                binding.wrappedValue = $0
        }
    }
}

private struct GeometryBinding: View {
    
    let reader: (GeometryProxy) -> CGFloat
    
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(
                key: GeometryPreference.self,
                value: self.reader(geo)
            )
        }
    }
}

private struct GeometryPreference: PreferenceKey {
    
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
