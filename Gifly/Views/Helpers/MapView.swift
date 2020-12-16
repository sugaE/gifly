//
//  MapView.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region) // $: a reference
            .onAppear(perform: {
                setRegion(coordinate)
            })
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34, longitude: -116))
    }
}
