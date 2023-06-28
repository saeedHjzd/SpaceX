//
//  LaunchListVM.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation

protocol LaunchListVMDelegate: AnyObject {
    func launchListVMDidFetchLaunches(_ launches: [Launch])
    func launchListVMDidFailWithError(_ errorMessage: String)
}

final class LaunchListVM {
    var launchesArr: [Launch] = []
    private let launchService: LaunchServices
    weak var delegate: LaunchListVMDelegate?
        
    var totalDocs = 0

    init(launchService: LaunchServices) {
        self.launchService = launchService
    }

    func fetchLaunchesList(page: Int) {
        let query = Query(upcoming: false)
        let options = Options(limit: 20, page: page, sort: Sort(flightNumber: "desc"))
        let body = QueryBaseReq(query: query, options: options)
                
        guard let jsonData = try? JSONEncoder().encode(body) else {return}
        launchService.fetchLaunchesList(path: Constants.launchesList, method: .post, requestType: .jsonBody(jsonData)) { [weak self](result: Result<QueryBaseModel<Launch>, NetworkingError>) in
            switch result {
            case .success(let launchListResult):
                self?.totalDocs = launchListResult.totalDocs
                guard let launchesList = launchListResult.docs else { return }
                self?.launchesArr.append(contentsOf: launchesList)
                self?.delegate?.launchListVMDidFetchLaunches(launchesList)
            case .failure(let error):
                self?.delegate?.launchListVMDidFailWithError(error.localizedDescription)
            }
        }
    }
}

