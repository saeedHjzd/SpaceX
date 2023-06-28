//
//  LaunchCellVM.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/7/1402 AP.
//

import Foundation
import UIKit

class LaunchCellVM {
    var launch: Launch
    private let imageRequestService: NetworkingLayer
    
    var flightNumber: String = ""
    var launchDate: String = ""
    var launchDetails: String = ""
    var success: Bool = false
    var imageURL: URL?
    var image: UIImage?
    
    init(imageRequestService: NetworkingLayer, launch: Launch) {
        self.imageRequestService = imageRequestService
        self.launch = launch
    }
    
    func setData() {
        self.flightNumber = "Flight number: \(launch.flightNumber)"
        
        if let dateUnix = launch.dateUnix {
            let dateFormatter = DateFormatter.localizedDateFormatter()
            let date = Date(timeIntervalSince1970: TimeInterval(dateUnix))
            self.launchDate = "Date : \(dateFormatter.string(from: date))"
        }
        
        if let details = launch.details {
            self.launchDetails = "Launch details : \(details)"
        }
        
        if let success = launch.success {
            self.success = success
        }
        
        imageURL = URL(string: launch.links?.patch?.small ?? "")
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL else {
            completion(nil)
            return
        }
        
        imageRequestService.requestImage(fromURL: imageURL) { image in
            self.image = image
            completion(image)
        }
    }
    
    
}
