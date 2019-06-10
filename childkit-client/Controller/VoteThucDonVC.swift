//
//  VoteThucDonVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController
import ChameleonFramework
import FirebaseDatabase

class VoteThucDonVC: UIViewController {
    
    @IBOutlet weak var danhSachVoteTableView: UITableView!
    @IBOutlet weak var binhChonBtn: UIButton!
    @IBOutlet weak var thucDonSC: UISegmentedControl!
    
    var listMA = [MonAn]()
    var maMA = [[String]]()
    var buaSang = [MonAn]()
    var buaTrua = [MonAn]()
    var buaChieu = [MonAn]()
    var keyLich = [String]()
    var thucDon = "Thực đơn 1"
    var thu = "Thứ 2"
    let itemsThucDon = ["Thực đơn 1", "Thực đơn 2"]
    let itemsThu = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6"]
    var voteNumber_TD = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        danhSachVoteTableView.delegate = self
        danhSachVoteTableView.dataSource = self
        
        getDataLich()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let status_vote = defaults.object(forKey: "status_vote") {
            if status_vote as! String == "Đã vote" {
                print("Đã vào 1")
                binhChonBtn.setTitle("\(thucDon)", for: .normal)
                binhChonBtn.backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.7647058824, blue: 0.7803921569, alpha: 1)
            } else {
                print("Đã vào  ")
                binhChonBtn.setTitle("Bình chọn", for: .normal)
                binhChonBtn.backgroundColor = #colorLiteral(red: 0.9280361533, green: 0.5689504147, blue: 0.1711549461, alpha: 1)
            }
        }
    }
    
    func getDataLich() {
        ref_MA_T.observe(.value) { (snapshot) in
            self.listMA.removeAll()
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let monAnObjs = data.value as! [String: AnyObject]
                let g = monAnObjs["G"] as! String
                let kCal = monAnObjs["Cal"] as! String
                let l = monAnObjs["L"] as! String
                let p = monAnObjs["P"] as! String
                let imageURL = monAnObjs["imageURL"] as! String
                let maCategory = monAnObjs["maCategory"] as! String
                let maMA = monAnObjs["maMA"] as! String
                let nguyenLieu = monAnObjs["nguyenlieu"] as! [[String: String]]
                let tenMA = monAnObjs["tenMA"] as! String
                let isChecked = false
                
                let monAn = MonAn(g: g, kCal: kCal, l: l, p: p, imageURL: imageURL, maCategory: maCategory, maMA: maMA, nguyenLieu: nguyenLieu, tenMA: tenMA, isChecked: isChecked)
                self.listMA.append(monAn)
            }
            
            var key: String!
            
            if let keyTDVote1 = defaults.object(forKey: "keyTDVote1"), let keyTDVote2 = defaults.object(forKey: "keyTDVote2") {
                switch self.thucDon {
                case "Thực đơn 1":
                    key = keyTDVote1 as? String
                case "Thực đơn 2":
                    key = keyTDVote2 as? String
                default:
                    return
                }
                
                ref_TD_Vote.observe(.value, with: { (snapshot) in
                    self.voteNumber_TD.removeAll()
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        let lichVoteObjs = data.value as! [String: AnyObject]
                        self.voteNumber_TD.append(lichVoteObjs["vote_number"] as! String)
                    }
                })
                
                ref_TD_Vote.child(key).child("\(self.thu)").observe(.value) { (snapshot) in
                    self.maMA.removeAll()
                    self.buaSang.removeAll()
                    self.buaTrua.removeAll()
                    self.buaChieu.removeAll()
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        let data = data.value as! [String]
                        self.maMA.append(data)
                    }
                    print(self.maMA)
                    if self.maMA.count < 2 && self.maMA.count > 0 {
                        self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[0].contains(monAn.maMA)
                        })
                    } else if self.maMA.count < 3 && self.maMA.count > 0 {
                        self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[0].contains(monAn.maMA)
                        })
                        self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[1].contains(monAn.maMA)
                        })
                    } else if self.maMA.count == 3 && self.maMA.count > 0 {
                        
                        self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[1].contains(monAn.maMA)
                        })
                        
                        self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[2].contains(monAn.maMA)
                        })
                        
                        self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                            self.maMA[0].contains(monAn.maMA)
                        })
                    }
                    self.danhSachVoteTableView.reloadData()
                }
            } else {
                
                ref_TD_Vote.observeSingleEvent(of: .value, with: { (snapshot) in
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        self.keyLich.append(data.key)
                        if self.keyLich.count == 2 {
                            break
                        }
                    }
                    
                    defaults.set(self.keyLich[0], forKey: "keyTDVote1")
                    defaults.set(self.keyLich[1], forKey: "keyTDVote2")
                    
                    switch self.thucDon {
                    case "Thực đơn 1":
                        key = defaults.object(forKey: "keyTDVote1") as? String
                    case "Thực đơn 2":
                        key = defaults.object(forKey: "keyTDVote2") as? String
                    default:
                        return
                    }
                    
                    ref_TD_Vote.child(key).child("\(self.thu)").observe(.value) { (snapshot) in
                        self.maMA.removeAll()
                        self.buaSang.removeAll()
                        self.buaTrua.removeAll()
                        self.buaChieu.removeAll()
                        for data in snapshot.children.allObjects as! [DataSnapshot] {
                            let data = data.value as! [String]
                            self.maMA.append(data)
                        }
                        print(self.maMA)
                        if self.maMA.count < 2 && self.maMA.count > 0 {
                            self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[0].contains(monAn.maMA)
                            })
                        } else if self.maMA.count < 3 && self.maMA.count > 0 {
                            self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[0].contains(monAn.maMA)
                            })
                            self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[1].contains(monAn.maMA)
                            })
                        } else if self.maMA.count == 3 && self.maMA.count > 0 {
                            
                            self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[1].contains(monAn.maMA)
                            })
                            
                            self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[2].contains(monAn.maMA)
                            })
                            
                            self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                                self.maMA[0].contains(monAn.maMA)
                            })
                        }
                        self.danhSachVoteTableView.reloadData()
                    }
                    
                })
            }
            
        }
    }
    
    @IBAction func binhChonWasPressed(_ sender: UIButton) {
        if binhChonBtn.currentTitle == "Bình chọn" && !self.maMA.isEmpty {
            defaults.set("Đã vote", forKey: "status_vote")
            if thucDon == "Thực đơn 1" {
                var vote_number = Int(voteNumber_TD[0])
                print(vote_number)
                vote_number! = vote_number! + 1
                ref_TD_Vote.child(defaults.object(forKey: "keyTDVote1") as! String).updateChildValues(["vote_number": "\(vote_number!)"])
                thucDonSC.isEnabled = false
            } else {
                var vote_number = Int(voteNumber_TD[1])
                vote_number! = vote_number! + 1
                ref_TD_Vote.child(defaults.object(forKey: "keyTDVote2") as! String).updateChildValues(["vote_number": "\(vote_number!)"])
                thucDonSC.isEnabled = false
            }
            binhChonBtn.setTitle("\(thucDon)", for: .normal)
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
            if thucDon == "Thực đơn 1" {
                var vote_number = Int(voteNumber_TD[0])
                vote_number! = vote_number! - 1
                ref_TD_Vote.child(defaults.object(forKey: "keyTDVote1") as! String).updateChildValues(["vote_number": "\(vote_number!)"])
                thucDonSC.isEnabled = true
            } else {
                var vote_number = Int(voteNumber_TD[1])
                vote_number! = vote_number! - 1
                ref_TD_Vote.child(defaults.object(forKey: "keyTDVote2") as! String).updateChildValues(["vote_number": "\(vote_number!)"])
                thucDonSC.isEnabled = true
            }
            defaults.set("Chưa vote", forKey: "status_vote")
            binhChonBtn.setTitle("Bình chọn", for: .normal)
            binhChonBtn.backgroundColor = #colorLiteral(red: 0.9280361533, green: 0.5689504147, blue: 0.1711549461, alpha: 1)
        }
    }
    
    @IBAction func thucDonChange(_ sender: UISegmentedControl) {
        thucDon = itemsThucDon[sender.selectedSegmentIndex]
        getDataLich()
    }
    
    @IBAction func thuChange(_ sender: UISegmentedControl) {
        thu = itemsThu[sender.selectedSegmentIndex]
        getDataLich()
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
            headerView.contentView.backgroundColor = FlatSkyBlue()
            headerView.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: FlatSkyBlue(), isFlat: true)
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 27)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return buaSang.count
        case 1:
            return buaTrua.count
        case 2:
            return buaChieu.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = danhSachVoteTableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
        switch indexPath.section {
        case 0:
            if !buaSang.isEmpty {
                DispatchQueue.global().async {
                    let url = URL(string: self.buaSang[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
                    let tenMA = self.buaSang[indexPath.row].tenMA
                    let kCal = self.buaSang[indexPath.row].kCal!
                    let protein = self.buaSang[indexPath.row].p!
                    let lipit = self.buaSang[indexPath.row].l!
                    let glucit = self.buaSang[indexPath.row].g!
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)!
                        cell.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                    }
                }
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if !buaTrua.isEmpty {
                DispatchQueue.global().async {
                    let url = URL(string: self.buaTrua[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
                    let tenMA = self.buaTrua[indexPath.row].tenMA
                    let kCal = self.buaTrua[indexPath.row].kCal!
                    let protein = self.buaTrua[indexPath.row].p!
                    let lipit = self.buaTrua[indexPath.row].l!
                    let glucit = self.buaTrua[indexPath.row].g!
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)!
                        cell.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                    }
                }
                return cell
            } else {
                return UITableViewCell()
            }
        case 2:
            if !buaChieu.isEmpty {
                DispatchQueue.global().async {
                    let url = URL(string: self.buaChieu[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
                    let tenMA = self.buaChieu[indexPath.row].tenMA
                    let kCal = self.buaChieu[indexPath.row].kCal!
                    let protein = self.buaChieu[indexPath.row].p!
                    let lipit = self.buaChieu[indexPath.row].l!
                    let glucit = self.buaChieu[indexPath.row].g!
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)!
                        cell.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                    }
                }
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.headerView(forSection: section)?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
