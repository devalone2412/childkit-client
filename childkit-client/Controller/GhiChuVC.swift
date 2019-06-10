//
//  GhiChuVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class GhiChuVC: UIViewController {

    var maLich: String!
    var thu: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(maLich!, thu!)
    }
    
    @IBAction func sendWasPressed(_ sender: CornerButton) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
