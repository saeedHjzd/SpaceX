//
//  TableViewExtensions.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import Foundation
import UIKit
extension UITableView {
    func registerCell(_ name : String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
