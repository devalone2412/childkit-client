//
//  ThemMonAnVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class ThemMonAnVC: UIViewController {

    @IBOutlet weak var timMonAnSB: UISearchBar!
    @IBOutlet weak var danhSachMonAnTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Thêm", style: .plain, target: self, action: #selector(themMonAn))
        danhSachMonAnTableView.delegate = self
        danhSachMonAnTableView.dataSource = self
    }
    
    @objc func themMonAn() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension ThemMonAnVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = danhSachMonAnTableView.dequeueReusableCell(withIdentifier: "monAnCell", for: indexPath) as? MonAnCell
        cell?.configure(tenMon: "Trứng cút chiên bơ xào tỏi", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        return cell!
    }
}
