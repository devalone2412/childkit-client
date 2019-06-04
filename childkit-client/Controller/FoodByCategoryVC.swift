//
//  FoodByCategoryVC.swift
//  childkit-client
//
//  Created by sang luc on 5/26/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class FoodByCategoryVC: UIViewController {

    @IBOutlet weak var foodByCategoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(themMonAn))
        // Do any additional setup after loading the view.
        foodByCategoryTableView.delegate = self
        foodByCategoryTableView.dataSource = self
    }
    
    @objc func themMonAn() {
        let themMonAn2 = (storyboard?.instantiateViewController(withIdentifier: "themmonan2") as? ThemMonAn2VC)!
        navigationController?.pushViewController(themMonAn2, animated: true)
    }
}

extension FoodByCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodByCategoryTableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as? VoteCell
        cell?.configure(tenMon: "Trứng cút xào đậu phộng rang me", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Xoá") { (action, view, completion) in
            print("Đã xoá")
            completion(true)
        }
        
        return delete
    }
    
}
