//
//  HomeViewController.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

class LaunchListViewController: UIViewController {
    private var launchListVM: LaunchListVM!
    private var alertPresenter: AlertPresentable?
    
    var currentPage: Int = 1
    var totalResults: Int = 0
    
    
    init(viewModel: LaunchListVM) {
        self.launchListVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var launchesTable: UITableView!
    
    var existingRowCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        self.launchListVM.delegate = self
        self.launchListVM.fetchLaunchesList(page: currentPage)
    }
    
    func setupView() {
        self.launchesTable.registerCell(LaunchTableCell.nibName)
        self.launchesTable.delegate = self
        self.launchesTable.dataSource = self
        self.title = "SpaceX"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.alertPresenter = AlertPresenter(viewController: self)
    }
    
}


extension LaunchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launchListVM.launchesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableCell.nibName, for: indexPath) as? LaunchTableCell {
            cell.fill(LaunchCellVM(imageRequestService: URLSessionNetworkingLayer(), launch: self.launchListVM.launchesArr[indexPath.row]))
            return cell
        }
        return LaunchTableCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = LaunchDetailsVC(launchDetailsVM: LaunchDetailsVM(imageRequestService: URLSessionNetworkingLayer(), launch: self.launchListVM.launchesArr[indexPath.row]))
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = 15
        let results = self.launchListVM.launchesArr
        let isLastCell = indexPath.row == results.count - 1
        
        if isLastCell && indexPath.row >= results.count - threshold && results.count < self.launchListVM.totalDocs {
            currentPage += 1
            print(currentPage)
            self.launchListVM.fetchLaunchesList(page: currentPage)
        }
    }
    
    
    
}

extension LaunchListViewController: LaunchListVMDelegate {
    func launchListVMDidFetchLaunches(_ launches: [Launch]) {
        let newRowCount = launches.count
        let indexPaths = (self.existingRowCount..<existingRowCount+newRowCount).map { IndexPath(row: $0, section: 0) }
        self.launchesTable.beginUpdates()
        self.launchesTable.insertRows(at: indexPaths, with: .automatic)
        self.launchesTable.endUpdates()
        self.existingRowCount += newRowCount
    }
    
    
    func launchListVMDidFailWithError(_ errorMessage: String) {
        self.alertPresenter?.showAlert(title: "Sorry!", message: errorMessage, completion: nil)
    }
}

