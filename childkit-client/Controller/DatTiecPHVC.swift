//
//  DatTiecVC.swift
//  childkit-client
//
//  Created by sang luc on 5/25/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController

class DatTiecPHVC: UIViewController {

    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var foodBirthTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        // Do any additional setup after loading the view.
        childTableView.delegate = self
        childTableView.dataSource = self
        foodBirthTableView.delegate = self
        foodBirthTableView.dataSource = self
    }

}

extension DatTiecPHVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case childTableView:
            return 2
        case foodBirthTableView:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case childTableView:
            let cell = childTableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as? ChildCell
            cell?.configure(tenTre: "Nguyễn Huy Hoàng", ngaySinh: "29/4/1997", lop: "Chồi 5")
            return cell!
        case foodBirthTableView:
            let cell = foodBirthTableView.dequeueReusableCell(withIdentifier: "foodBirthCell", for: indexPath)
            cell.textLabel?.text = "Món 1"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}
