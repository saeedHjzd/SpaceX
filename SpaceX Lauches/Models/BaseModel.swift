//
//  BaseModel.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/5/1402 AP.
//

import Foundation

struct QueryBaseModel<T: Decodable>: Decodable{
    let docs: [T?]
    let totalDocs, limit, totalPages, page: Int
    let pagingCounter: Int
    let hasPrevPage, hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

struct QueryBaseReq: Encodable {
    let query: Query
    let options: Options
}
