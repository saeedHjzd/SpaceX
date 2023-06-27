//
//  LaunchListRequest.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

struct LaunchListRequest: Requestable {
    private let limit: Int
    private let page: Int
    
    static var path: String { return "/v5/launches/query" }
    typealias ResponseType = QueryBaseModel<Launch>
    
    init(limit: Int, page: Int) {
        self.limit = limit
        self.page = page
    }
    
    var requestType: RequestType {
        let query = Query(upcoming: false)
        let options = Options(limit: limit, page: page, sort: Sort(flightNumber: "desc"))
        let body = QueryBaseReq(query: query, options: options)
        
        guard let bodyData = try? JSONEncoder().encode(body) else { return .jsonBody(Data()) }
        return .jsonBody(bodyData)
    }
}

