//
//  LaunchModel.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/5/1402 AP.
//

import Foundation

struct Launch: Decodable {
    let flightNumber: Int?
    let name, details, dateUTC: String?
    let success: Bool?
    let links: MediaLinks?
    
    enum CodingKeys: String, CodingKey {
        case name, success, details, links
        case flightNumber = "flight_number"
        case dateUTC = "date_utc"
        //        case dateUnix = "date_unix"
        //        case dateLocal = "date_local"
        //        case datePrecision = "date_precision"
    }
}
struct MediaLinks: Decodable {
    let patch: Patch?
    let webcast: String?
    let wikipedia: String?
}
struct Patch: Decodable {
    let small, large: String?
}



struct Query: Encodable {
    let upcoming: Bool
}
struct Options: Encodable {
    let limit, page: Int
    let sort: Sort
}
struct Sort: Encodable {
    let flightNumber: String
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
    }
}
