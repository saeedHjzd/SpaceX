//
//  HomeViewController.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var launchesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupView()

    }
    
    func setupView() {
        self.launchesTable.registerCell(LaunchTableCell.nibName)
        self.launchesTable.delegate = self
        self.launchesTable.dataSource = self
        self.title = "SpaceX"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableCell.nibName, for: indexPath) as? LaunchTableCell {
            //        cell.fill(self.viewModel.tweets.value[indexPath.row])
            return cell
        }
        return LaunchTableCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("1111")
    }
    
}
