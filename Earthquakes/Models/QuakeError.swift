//
//  QuakeError.swift
//  Earthquakes-iOS
//
//  Created by Olibo moni on 06/11/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation


enum QuakeError:  Error {
    case missingData
    case networkError
    case unexpectedError(error: Error)
}

extension QuakeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            NSLocalizedString("Found and will discard a quake missing a valid code, magnitude, place, or time.", comment: "")
        case .networkError:
            NSLocalizedString("Network Error try again", comment: "")
        case .unexpectedError(let error) :
            NSLocalizedString(" An unexpected error \(error) occured", comment: "")
        }
    }
}
