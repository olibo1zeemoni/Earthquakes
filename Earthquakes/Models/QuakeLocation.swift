//
//  QuakeLocation.swift
//  EarthquakesTests
//
//  Created by Olibo moni on 07/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct QuakeLocation: Decodable {
    var latitude: Double { properties.products.origin.first!.properties.latitude }
    var longitude: Double { properties.products.origin.first!.properties.longitude }
    private var properties: RootProperties

    
    struct RootProperties: Decodable {
        var products: Products
    }
    
    struct Products: Decodable {
        var origin: [Origin]
    }
    
    struct Origin: Decodable {
        var properties: OriginProperties
    }
    
    struct OriginProperties {
        var latitude: Double
        var longitude: Double
    }
    
}


extension QuakeLocation.OriginProperties: Decodable {
    ///CodingKeys necessary because model properties are of type Double but are strings in the JSON
    private enum OriginPropertiesCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OriginPropertiesCodingKeys.self)
        let longitude = try container.decode(String.self, forKey: .longitude)
        let latitude = try container.decode(String.self, forKey: .latitude)
        
        guard let longitude = Double(longitude), let latitude = Double(latitude) else { throw QuakeError.missingData }
        
        self.longitude = longitude
        self.latitude = latitude
    }
}


extension QuakeLocation {
    init(latitude: Double, longitude: Double) {
        self.properties = RootProperties(products: Products(origin: [Origin(properties: OriginProperties(latitude: latitude, longitude: longitude))]))
    }
}
