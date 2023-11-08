//
//  QuakeClient.swift
//  Earthquakes-iOS
//
//  Created by Olibo moni on 08/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class QuakeClient {
    
    private lazy var decoder: JSONDecoder = {
           let aDecoder = JSONDecoder()
           aDecoder.dateDecodingStrategy = .millisecondsSince1970
           return aDecoder
       }()

    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!

    private let downloader: any HTTPDataDownloader
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    var quakes: [Quake] {
        get async throws {
            let data =  try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GeoJSON.self, from: data)
            return allQuakes.quakes
            
        }
    }
    
}


