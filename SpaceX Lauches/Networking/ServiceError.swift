//
//  ServiceError.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case invalidData
    case decodingFailed(Error)
    case validationFailed(String)
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid."
        case .invalidResponse:
            return "Response in invalid."
        case .requestFailed(let error):
            return "Request failed with error : \(error)."
        case .invalidData:
            return "Data in invalid."
        case .decodingFailed(let error):
            return "Decoding failed with error : \(error)"
        case .validationFailed(let error):
            return "Request failed with status code : \(error)"
        }
    }
}
