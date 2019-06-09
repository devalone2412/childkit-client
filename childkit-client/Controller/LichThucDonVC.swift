//
//  LichThucDonVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController
import ChameleonFramework

class LichThucDonVC: UIViewController {

    @IBOutlet weak var lichTableView: UITableView!
    @IBOutlet weak var vietBinhLuanBtn: CornerButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var periodInWeek: UILabel!
    
    var dateStart: Date = Date.today().previous(.monday)
    var dateEnd: Date = Date.today().next(.sunday)
    
    lazy var dateStartText: String? = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM"
        
        return dateFormatter.string(from: dateStart)
    }()
    
    lazy var dateEndText: String? = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM"
        
        return dateFormatter.string(from: dateEnd)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        // Do any additional setup after loading the view.
        lichTableView.delegate = self
        lichTableView.dataSource = self
        configNav()
        updateView()
        periodInWeek.text = "\(dateStartText!) - \(dateEndText!)"
    }
    
    func updateView() {
        if defaults.object(forKey: "quyen") as! String != "PH" {
            vietBinhLuanBtn.isHidden = true
            commentBtn.isHidden = true
        }
    }
    
    func configNav() {
        let taoLichNauBtn = UIBarButtonItem(title: "Tạo thực đơn", style: .plain, target: self, action: #selector(taoLichNau))
        navigationItem.rightBarButtonItem = defaults.object(forKey: "quyen") as! String == "BT" ? taoLichNauBtn : nil
    }
    
    @objc func taoLichNau() {
        if defaults.object(forKey: "key_TD1") as? String != nil && defaults.object(forKey: "key_TD2") as? String != nil {
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
            dateFormatter.defaultDate = Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let start_date = dateFormatter.string(from: Date.today().next(.monday))
            let end_date = dateFormatter.string(from: Date.today().next(.friday))
            let today = dateFormatter.string(from: Date.today())
            
            let key1 = ref_TD_Vote.childByAutoId().key!
            let key2 = ref_TD_Vote.childByAutoId().key!
            
            let td_vote_1 = [
                "ten": "Thực đơn 1",
                "start_date": start_date,
                "end_date": end_date,
                "Thứ 2": [],
                "Thứ 3": [],
                "Thứ 4": [],
                "Thứ 5": [],
                "Thứ 6": [],
                "vote_number": "",
                "vote_status": "not vote",
                "created_date": "\(today)"
                ] as [String : Any]
            
            let td_vote_2 = [
                "ten": "Thực đơn 2",
                "start_date": "\(dateFormatter.string(from: Date.today().next(.monday)))",
                "end_date": "\(dateFormatter.string(from: Date.today().next(.friday)))",
                "Thứ 2": [],
                "Thứ 3": [],
                "Thứ 4": [],
                "Thứ 5": [],
                "Thứ 6": [],
                "vote_number": "",
                "vote_status": "not vote",
                "created_date": "\(today)"
                ] as [String : Any]
            
            ref_TD_Vote.child(key1).setValue(td_vote_1)
            ref_TD_Vote.child(key2).setValue(td_vote_2)
            
            defaults.set(key1, forKey: "key_TD1")
            defaults.set(key2, forKey: "key_TD2")
            defaults.set(dateFormatter.string(from: Date.today().next(.monday)), forKey: "start_date")
        }
        
        let lichTuanSauVC = storyboard?.instantiateViewController(withIdentifier: "lichtuansau") as! LichTuanSauVC
        navigationController?.pushViewController(lichTuanSauVC, animated: true)
        
    }
    
    @IBAction func vietBinhLuanPressed(_ sender: CornerButton) {
        let binhLuanVC = (storyboard?.instantiateViewController(withIdentifier: "binhluan") as? BinhLuanVC)!
        navigationController?.pushViewController(binhLuanVC, animated: true)
    }
    
    @IBAction func ghiChuWasPressed(_ sender: UIButton) {
        let ghiChuVC = (storyboard?.instantiateViewController(withIdentifier: "ghichu") as? GhiChuVC)!
        navigationController?.pushViewController(ghiChuVC, animated: true)
    }
    
    @IBAction func truocWasPressed(_ sender: CornerButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM"
        //        let today = dateFormatter.date(from: dateFormatter.string(from: Date.today()))
        dateStart = dateStart.previous(.monday)
        dateEnd = dateEnd.previous(.sunday)
        let start = dateFormatter.string(from: dateStart)
        let end = dateFormatter.string(from: dateEnd)
        periodInWeek.text = "\(start) - \(end)"
    }
    
    @IBAction func sauWasPressed(_ sender: CornerButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM"
//        let today = dateFormatter.date(from: dateFormatter.string(from: Date.today()))
        dateStart = dateStart.next(.monday)
        dateEnd = dateEnd.next(.sunday)
        let start = dateFormatter.string(from: dateStart)
        let end = dateFormatter.string(from: dateEnd)
        periodInWeek.text = "\(start) - \(end)"
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
            headerView.contentView.backgroundColor = FlatSkyBlue()
            headerView.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: FlatSkyBlue(), isFlat: true)
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 27)
            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(headerTableTap))
//            headerView.addGestureRecognizer(tap)
        }
    }
    
    @objc func headerTableTap() {
        let chinhSuaLichVC = (storyboard?.instantiateViewController(withIdentifier: "chinhsualich") as? ChinhSuaLichVC)!
        navigationController?.pushViewController(chinhSuaLichVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lichTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LichCell
//        switch indexPath.section {
//        case 0:
//            cell?.configure(tenMon: "Trứng cút chiên bơ xào tỏi", kCal: "50", protein: "24", lipit: "13", glucit: "20")
//        case 1:
//            cell?.configure(tenMon: "Hột vịt lộn rang me Tứ Xuyên", kCal: "50", protein: "24", lipit: "13", glucit: "20")
//        case 2:
//            cell?.configure(tenMon: "Trứng cút xào đậu phộng rang me", kCal: "50", protein: "24", lipit: "13", glucit: "20")
//        default:
//            return UITableViewCell()
//        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.headerView(forSection: section)?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
