//
//  LaunchService.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

protocol LaunchServiceProtocol {
    func fetchLaunchesList(_ launchRequestObj: LaunchListRequest, completion: @escaping (Result<QueryBaseModel<Launch>, NetworkingError>) -> Void)
}

class LaunchServices: LaunchServiceProtocol {
    
    private let networkingLayer: NetworkingLayer
    
    init(networkingLayer: NetworkingLayer) {
        self.networkingLayer = networkingLayer
    }
    
    func fetchLaunchesList(_ launchRequestObj: LaunchListRequest, completion: @escaping (Result<QueryBaseModel<Launch>, NetworkingError>) -> Void) {
        networkingLayer.request(launchRequestObj) { result in
            switch result {
            case.success(let launchListResponse):
                print(launchListResponse)
            case.failure(let error):
                print(error)
            }
        }
    }
}
