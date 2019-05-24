//
//  GhiChuVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class GhiChuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sendWasPressed(_ sender: CornerButton) {
        let lichVC = (storyboard?.instantiateViewController(withIdentifier: "lichthucdon") as? LichThucDonVC)!
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
