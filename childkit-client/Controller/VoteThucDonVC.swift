//
//  VoteThucDonVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController

class VoteThucDonVC: UIViewController {

    @IBOutlet weak var danhSachVoteTableView: UITableView!
    @IBOutlet weak var binhChonBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        danhSachVoteTableView.delegate = self
        danhSachVoteTableView.dataSource = self
    }
    
    @IBAction func binhChonWasPressed(_ sender: UIButton) {
        if binhChonBtn.currentTitle == "Bình chọn" {
            binhChonBtn.setTitle("Chọn lại", for: .normal)
            binhChonBtn.backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.7647058824, blue: 0.7803921569, alpha: 1)
            let alert = UIAlertController(title: "Thông báo", message: "Bạn đã bình chọn thực đơn cho tuần này", preferredStyle: .alert)
            let returnLichNau = UIAlertAction(title: "Quay lại MH chính", style: .default) { (action) in
                let lichThucDonVC = self.storyboard?.instantiateViewController(withIdentifier: "lichthucdon") as? LichThucDonVC
                let revealVC = self.revealViewController()
                revealVC?.pushFrontViewController(UINavigationController(rootViewController: lichThucDonVC!), animated: true)
            }
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(returnLichNau)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            binhChonBtn.setTitle("Bình chọn", for: .normal)
            binhChonBtn.backgroundColor = #colorLiteral(red: 0.9280361533, green: 0.5689504147, blue: 0.1711549461, alpha: 1)
        }
    }
}

extension VoteThucDonVC: UITableViewDelegate, UITableViewDataSource {
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(headerTableTap))
            headerView.addGestureRecognizer(tap)
        }
    }
    
    @objc func headerTableTap() {
        let chinhSuaLichVC = (storyboard?.instantiateViewController(withIdentifier: "chinhsualich") as? ChinhSuaLichVC)!
        navigationController?.pushViewController(chinhSuaLichVC, animated: true)
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
        let cell = danhSachVoteTableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as? VoteCell
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
