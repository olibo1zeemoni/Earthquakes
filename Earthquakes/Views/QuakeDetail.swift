//
//  QuakeDetail.swift
//  Earthquakes-iOS
//
//  Created by Olibo moni on 09/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct QuakeDetail: View {
    var quake: Quake
    
    @EnvironmentObject var quakesProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil
    @State private var formatDouble = false
    
    var body: some View {
        VStack {
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
            Text("\(quake.time.formatted())")
                .foregroundStyle(Color.secondary)
            if let location {
                Group {
                    Text("Latitude: \(location.latitude.customFormat(formatDouble))")
                    Text("Longitude: \(location.longitude.customFormat(formatDouble))")
                }
                
                .onTapGesture {
                    formatDouble.toggle()
                }
            }
        }
        .task {
            if self.location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    self.location = try? await quakesProvider.location(for: quake)
                }
            }
        }
    }
    
}

#Preview {
    QuakeDetail(quake: Quake.preview)
}





extension Double {
    func customFormat(_ shouldFormat: Bool) -> String {
        if shouldFormat {
            return String(format: "%.3f", self)
        } else {
            return String(self)
        }
    }
}


