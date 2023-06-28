//
//  LaunchDetailsVC.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

class LaunchDetailsVC: UIViewController {
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var launchNameLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var launchDetailsLabel: UILabel!
    @IBOutlet weak var wikipediaBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    private var viewModel: LaunchDetailsVM!
    
    init(launchDetailsVM: LaunchDetailsVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = launchDetailsVM
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        SetData()
    }
    
    private func SetData() {
        launchNameLabel.text = viewModel.launchName
        launchDateLabel.text = viewModel.launchDate
        launchDetailsLabel.text = viewModel.launchDetails
        launchDetailsLabel.isHidden = viewModel.launchDetails == nil
        wikipediaBtn.isHidden = !viewModel.hasWikipediaLink
        viewModel.loadImage { [weak self] image in
            self?.launchImageView.image = image
        }
        updateBookmarkButtonAppearance()
    }
    
    func updateBookmarkButtonAppearance() {
        let buttonImageName = viewModel.isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkBtn.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    @IBAction func onTapWikipediaBtn(_ sender: UIButton) {
        guard let linkString = viewModel.wikipediaLink else { return }
        if let url = URL(string: linkString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func onTapBookmarkBtn(_ sender: UIButton) {
        viewModel.toggleBookmark()
        updateBookmarkButtonAppearance()
    }
}
