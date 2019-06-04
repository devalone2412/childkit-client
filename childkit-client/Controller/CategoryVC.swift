//
//  CategoryVC.swift
//  childkit-client
//
//  Created by sang luc on 5/26/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController

class CategoryVC: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell
        cell?.configure(name: "Món thịt")
        return cell!
    }
    
    
}
