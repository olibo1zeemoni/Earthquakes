//
//  GeoJSON.swift
//  EarthquakesTests
//
//  Created by Olibo moni on 07/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct GeoJSON: Decodable {
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var featuredContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features)
        
        while !featuredContainer.isAtEnd {
            let propertyContainer = try featuredContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)
            if let property = try? propertyContainer.decode(Quake.self, forKey: .properties){
                quakes.append(property)
            }
            
        }
    }
    
    private enum RootCodingKeys: String, CodingKey {
        case features
    }
    
    
    private enum FeatureCodingKeys: String, CodingKey {
        case properties
    }
    
    private(set) var quakes: [Quake] = []
}
