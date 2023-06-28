//
//  LaunchService.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

protocol LaunchServiceProtocol {
    func fetchLaunchesList(path: String, method: HTTPMethod, requestType: RequestType, completion: @escaping (Result<QueryBaseModel<Launch>, NetworkingError>) -> Void)
}

final class LaunchServices: LaunchServiceProtocol {
    private let networkingLayer: NetworkingLayer
    
    init(networkingLayer: NetworkingLayer) {
        self.networkingLayer = networkingLayer
    }
    
    func fetchLaunchesList(path: String, method: HTTPMethod, requestType: RequestType, completion: @escaping (Result<QueryBaseModel<Launch>, NetworkingError>) -> Void) {
        self.networkingLayer.request(path: path, method: method, requestType: requestType) { (result: Result<QueryBaseModel<Launch>, NetworkingError>) in
            switch result {
            case.success(let launchListResponse):
                completion(.success(launchListResponse))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
