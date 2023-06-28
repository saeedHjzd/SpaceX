//
//  LaunchesTableCell.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

class LaunchTableCell: UITableViewCell {
    
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var launchStatusImageView: UIImageView!
    
    @IBOutlet weak var flightNumLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var launchDetailsLabel: UILabel!
    
    var viewModel: LaunchCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(_ launchVM: LaunchCellVM) {
        self.viewModel = launchVM
        self.viewModel.setData()
        flightNumLabel.text = viewModel.flightNumber
        launchDateLabel.text = viewModel.launchDate
        
        if !viewModel.launchDetails.isEmpty {
            launchDetailsLabel.text = viewModel.launchDetails
            launchDetailsLabel.isHidden = false
        } else {
            launchDetailsLabel.isHidden = true
        }
        
        launchStatusImageView.isHidden = !viewModel.success
        
        if viewModel.success {
            launchStatusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            launchStatusImageView.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else {
            launchStatusImageView.image = UIImage(systemName: "xmark.circle.fill")
            launchStatusImageView.tintColor = .red
        }
        
        if let image = viewModel.image {
            launchImageView.image = image
        } else {
            launchImageView.image = nil
            viewModel.loadImage { [weak self] image in
                self?.launchImageView.image = image
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
