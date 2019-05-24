//
//  LichThucDonVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class LichThucDonVC: UIViewController {

    @IBOutlet weak var lichTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lichTableView.delegate = self
        lichTableView.dataSource = self
    }
}

extension LichThucDonVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bữa sáng"
        case 1:
            return "Bữa trưa"
        case 2:
            return "Bữa chiều"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.textColor = .orange
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 27)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 10
        case 2:
            return 15
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lichTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LichCell
        switch indexPath.section {
        case 0:
            cell?.configure(tenMon: "Trứng cút chiên bơ xào tỏi", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        case 1:
            cell?.configure(tenMon: "Hột vịt lộn rang me Tứ Xuyên", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        case 2:
            cell?.configure(tenMon: "Trứng cút xào đậu phộng rang me", kCal: "50", protein: "24", lipit: "13", glucit: "20")
        default:
            return UITableViewCell()
        }
        return cell!
    }
    
    
}
