//
//  QuakeDetailMap.swift
//  Earthquakes-iOS
//
//  Created by Olibo moni on 09/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import MapKit

struct QuakeDetailMap: View {
    let location: QuakeLocation
    let tintColor: Color
    @State private var region = MKCoordinateRegion()
    @State private var position = CLLocationCoordinate2D(latitude: -30.0, longitude: 130.0)
    
    var body: some View {
        if #available(iOS 17, *) {
            Map(initialPosition: initialPosition)
        } else {
            Map(coordinateRegion: $region)
                .onAppear {
                    withAnimation {
                        region.center = CLLocationCoordinate2D(latitude: -30.0, longitude: 130.0)
                        region.span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 70)
                    }
                }
        }
        
    }
    
    @available(iOS 17.0, *)
    var initialPosition: MapCameraPosition {
           let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 70)
        let region = MKCoordinateRegion(center: position, span: span)
           return .region(region)
       }
}

#Preview {
    QuakeDetailMap(location: QuakeLocation(latitude: -30.0, longitude: 130.0), tintColor: .pink)
}
