//
//  ChinhSuaLichVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class ChinhSuaLichVC: UIViewController {

    @IBOutlet weak var chinhSuaLichTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Quay lại", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMonAn))
        chinhSuaLichTableView.delegate = self
        chinhSuaLichTableView.dataSource = self
    }
    
    @objc func addMonAn() {
        let themMonAnVC = (storyboard?.instantiateViewController(withIdentifier: "themmonan") as? ThemMonAnVC)!
        navigationController?.pushViewController(themMonAnVC, animated: true)
    }
}

extension ChinhSuaLichVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chinhSuaLichTableView.dequeueReusableCell(withIdentifier: "modifyFoodCell", for: indexPath) as? ChinhSuaLichCell
        cell?.configure(tenMon: "Trứng cút chiên bơ xào tỏi", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            print("Deleted")
            completion(true)
        }
        delete.backgroundColor = .red
        return delete
    }
    
    
}
