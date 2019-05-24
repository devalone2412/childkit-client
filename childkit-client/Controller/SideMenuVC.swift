//
//  SideMenuVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dangXuatWasPressed(_ sender: BorderButton) {
        let revealVC = self.revealViewController()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC
        revealVC?.pushFrontViewController(loginVC, animated: true)
    }
}
