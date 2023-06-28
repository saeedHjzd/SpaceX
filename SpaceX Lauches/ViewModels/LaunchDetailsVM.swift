//
//  LaunchDetailsVM.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/7/1402 AP.
//

import Foundation
import UIKit

class LaunchDetailsVM {
    private let launch: Launch
    private var bookmarkedItemIds: [Int] = []
    private let imageRequestService: NetworkingLayer
    
    var isBookmarked: Bool {
        return bookmarkedItemIds.contains(launch.flightNumber)
    }
    
    var launchName: String {
        return "Launch name : \(launch.name ?? "")"
    }
    
    var launchDate: String? {
        if let dateUnix = launch.dateUnix {
            let dateFormatter = DateFormatter.localizedDateFormatter()
            let date = Date(timeIntervalSince1970: TimeInterval(dateUnix))
            return "Date : \(dateFormatter.string(from: date))"
        }
        return nil
    }
    
    var launchDetails: String? {
        if let details = launch.details {
            return "Details : \(details)"
        }
        return nil
    }
    
    var hasWikipediaLink: Bool {
        return launch.links?.wikipedia != nil
    }
    
    var wikipediaLink: String? {
        return launch.links?.wikipedia
    }
    
    private var imageURL: URL? {
        return URL(string: launch.links?.patch?.small ?? "")
    }
    
    init(imageRequestService: NetworkingLayer, launch: Launch) {
        self.launch = launch
        self.imageRequestService = imageRequestService
        loadBookmarkedItemIds()
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        if let imageURL = imageURL {
            imageRequestService.requestImage(fromURL: imageURL) { image in
                completion(image)
            }
        } else {
            completion(nil)
        }
    }
    
    func toggleBookmark() {
        if isBookmarked {
            bookmarkedItemIds.removeAll(where: { $0 == launch.flightNumber })
        } else {
            bookmarkedItemIds.append(launch.flightNumber)
        }
        saveBookmarkedItemIds()
    }
    
    private func loadBookmarkedItemIds() {
        if let savedBookmarkedItemIds = UserDefaults.standard.array(forKey: Constants.bookmarkedIdsKey) as? [Int] {
            bookmarkedItemIds = savedBookmarkedItemIds
        }
    }
    
    private func saveBookmarkedItemIds() {
        UserDefaults.standard.set(bookmarkedItemIds, forKey: Constants.bookmarkedIdsKey)
    }
}
