//
//  LandmarkDetail.swift
//  Gifly
//
//  Created by 女王様 on 2020/12/16.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: {
            $0.id == landmark.id
        })!

    }
    
    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            CircleImage(image: landmark.image)
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                        .foregroundColor(.primary)
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Divider()
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
                    
            }
            .padding()
            
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

  static var previews: some View {
      LandmarkDetail(landmark: modelData.landmarks[0])
          .environmentObject(modelData)
  }
}
