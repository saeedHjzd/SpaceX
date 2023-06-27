//
//  LaunchDetailsVC.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

class LaunchDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Launch"
        navigationItem.largeTitleDisplayMode = .never
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
