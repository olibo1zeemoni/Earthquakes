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
    private var place: QuakePlace
    @State private var region = MKCoordinateRegion()
    @State private var selectedItem: MKMapItem?

    
    init(location: QuakeLocation, tintColor: Color) {
           self.location = location
           self.tintColor = tintColor
           self.place = QuakePlace(location: location)
       }
    
    var body: some View {
        if #available(iOS 17, *) {
            Map(initialPosition: initialPosition, selection: $selectedItem){
                Marker(item: MKMapItem(placemark: MKPlacemark(coordinate: place.location)))
            }
        } else {
            Map(coordinateRegion: $region, annotationItems: [place]){ place in
                MapMarker(coordinate: place.location, tint: tintColor)
            }
                .onAppear {
                    withAnimation {
                        region.center = place.location
                        region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                    }
                }
        }
        
    }
    
    @available(iOS 17.0, *)
    var initialPosition: MapCameraPosition {
           let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: place.location, span: span)
           return .region(region)
       }
}

#Preview {
    QuakeDetailMap(location: QuakeLocation(latitude: -30.0, longitude: 130.0), tintColor: .pink)
}




struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}
