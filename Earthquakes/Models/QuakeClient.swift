//
//  QuakeClient.swift
//  Earthquakes-iOS
//
//  Created by Olibo moni on 08/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

actor QuakeClient {
    private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
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
            var updatedQuakes = allQuakes.quakes
            //MARK: come back
            let _ = updatedQuakes.map({$0.time.timeIntervalSince1970 > 3600}).startIndex
            
            ///request the location for all the earthquakes in the past hour
            if let olderThanOneHour = updatedQuakes.firstIndex(where: { $0.time.timeIntervalSince1970 > 3600 }) {
                let indexRange = updatedQuakes.startIndex..<olderThanOneHour
                try await withThrowingTaskGroup(of: (Int,QuakeLocation).self) { group in
                    for index in indexRange {
                        group.addTask {
                            let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
                            return(index,location)
                        }
                    }
                    while let result = await group.nextResult() {
                        switch result {
                        case .success(let (index,location)):
                            updatedQuakes[index].location = location
                        case .failure(let error):
                            throw error
                        }
                    }
                }
            }
            
            return updatedQuakes
            
        }
    }
    
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
        if let cache = quakeCache[url] {
            ///Waiting on an in-progress task here avoids making a second network request.
            switch cache {
            case .ready(let location):
                return location
            case .inProgress(let task):
                return try await task.value
            }
            
        }
        
        let task = Task<QuakeLocation,Error>{
            let data = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: data)
            return location
        }
        //MARK: A second thread shouldn’t initiate another network fetch if a fetch is already in progress.
        ///Instead, it should wait on the fetch already in progress. When this function is called with await, execution pauses, and the actor can start executing new function calls before the network call finishes.
        ///Setting quakeCache to .inProgress ensures that a second thread finds a cached value when it begins executing and avoids additional network requests. 
        quakeCache[url] = .inProgress(task)
        do {
            let location = try await task.value
            quakeCache[url] = .ready(location)
            return location
        } catch {
            quakeCache[url] = nil
            throw error
        }
        
        
    }
    
}


