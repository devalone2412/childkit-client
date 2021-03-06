//
//  LichTuanSauVC.swift
//  childkit-client
//
//  Created by sang luc on 6/7/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseDatabase

class LichTuanSauVC: UIViewController {

    @IBOutlet weak var thucDonSC: UISegmentedControl!
    @IBOutlet weak var thuSC: UISegmentedControl!
    @IBOutlet weak var danhSachMA: UITableView!
    @IBOutlet weak var totalKcal: UILabel!
    @IBOutlet weak var totalProtein: UILabel!
    @IBOutlet weak var totalLipit: UILabel!
    @IBOutlet weak var totalGlucit: UILabel!
    
    let itemsThucDon = ["Thực đơn 1", "Thực đơn 2"]
    let itemsThu = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6"]
    var thucDon: String = "Thực đơn 1"
    var thu: String = "Thứ 2"
    var buaSang = [MonAn]()
    var listMA = [MonAn]()
    var buaTrua = [MonAn]()
    var buaChieu = [MonAn]()
    var maMA = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNav()
        danhSachMA.delegate = self
        danhSachMA.dataSource = self
        getDataLich()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let today = dateFormatter.string(from: Date.today())
        
        if today == defaults.object(forKey: "start_date") as! String {
            
            let key_TD_1 = defaults.object(forKey: "key_TD1") as! String
            let key_TD_2 = defaults.object(forKey: "key_TD2") as! String
            
            ref_TD_Vote.child(key_TD_1).updateChildValues(["vote_status": "voting"])
            ref_TD_Vote.child(key_TD_2).updateChildValues(["vote_status": "voting"])
            
            defaults.removeObject(forKey: "key_TD1")
            defaults.removeObject(forKey: "key_TD2")
            defaults.removeObject(forKey: "start_date")
        }
    }
    
    func getDataLich() {
        var key: String!
        switch thucDon {
        case "Thực đơn 1":
            key = defaults.object(forKey: "key_TD1") as? String
        case "Thực đơn 2":
            key = defaults.object(forKey: "key_TD2") as? String
        default:
            return
        }
        
        
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
                print(self.buaSang, self.buaTrua, self.buaChieu)
                self.sumTPDD(buaSang: self.buaSang, buaTrua: self.buaTrua, buaChieu: self.buaChieu)
                self.danhSachMA.reloadData()
            }
        }
    }
    
    func sumTPDD(buaSang: [MonAn], buaTrua: [MonAn], buaChieu: [MonAn]) {
        var sumKcal = 0
        var sumProtein = 0
        var sumLipit = 0
        var sumGlucit = 0
        
        for ma in buaSang {
            sumKcal += Int(ma.kCal)!
            sumProtein += Int(ma.p)!
            sumLipit += Int(ma.l)!
            sumGlucit += Int(ma.g)!
        }
        
        for ma in buaTrua {
            sumKcal += Int(ma.kCal)!
            sumProtein += Int(ma.p)!
            sumLipit += Int(ma.l)!
            sumGlucit += Int(ma.g)!
        }
        
        for ma in buaChieu {
            sumKcal += Int(ma.kCal)!
            sumProtein += Int(ma.p)!
            sumLipit += Int(ma.l)!
            sumGlucit += Int(ma.g)!
        }
        
        totalKcal.text = "Cal: \(sumKcal)"
        totalProtein.text = "Protein: \(sumProtein) g"
        totalLipit.text = "Lipit: \(sumLipit) g"
        totalGlucit.text = "Glucit: \(sumGlucit) g"
    }
    
    func configNav() {
        let themMonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(themMonAn))
        let saveTempItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTemplate))
        let loadTempItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(loadTemplate))
        navigationItem.rightBarButtonItems = [themMonItem, saveTempItem, loadTempItem]
    }
    
    @objc func loadTemplate() {
        
    }
    
    @objc func saveTemplate() {
        print("Đã click!")
        var key: String!
        switch thucDon {
        case "Thực đơn 1":
            key = defaults.object(forKey: "key_TD1") as? String
        case "Thực đơn 2":
            key = defaults.object(forKey: "key_TD2") as? String
        default:
            return
        }
        
        ref_TD_Vote.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            ref_TDTemplate.child(key).setValue(snapshot.value)
        })
        
        let nameAlert = UIAlertController(title: "Lưu template", message: "Nhập tên template", preferredStyle: .alert)
        nameAlert.addTextField { (textField) in
            textField.placeholder = "Thực đơn hè 1"
        }
        
        let saveAction = UIAlertAction(title: "Lưu", style: .default) { (_) in
            let textField = nameAlert.textFields![0] as UITextField
            ref_TDTemplate.child(key).updateChildValues(["name": textField.text!])
            
            let alert = UIAlertController(title: "Thông báo", message: "Lưu template thực đơn thành công", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            })
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        nameAlert.addAction(saveAction)
        present(nameAlert, animated: true, completion: nil)
    }
    
    @objc func themMonAn() {
        let chinhSuaLichVC = storyboard?.instantiateViewController(withIdentifier: "chinhsualich") as! ChinhSuaLichVC
        chinhSuaLichVC.thucDon = thucDon
        chinhSuaLichVC.thu = thu
        navigationController?.pushViewController(chinhSuaLichVC, animated: true)
    }

    @IBAction func thucDonChanged(_ sender: UISegmentedControl) {
        thucDon = itemsThucDon[sender.selectedSegmentIndex]
        thu = "Thứ 2"
        thuSC.selectedSegmentIndex = 0
        getDataLich()
        print(thucDon)
    }
    
    @IBAction func thuChanged(_ sender: UISegmentedControl) {
        thu = itemsThu[sender.selectedSegmentIndex]
        getDataLich()
        print(thu)
    }
}

extension LichTuanSauVC: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = danhSachMA.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
        switch indexPath.section {
        case 0:
            print(buaSang.count)
            if buaSang.count != 0 {
                let tenMA = self.buaSang[indexPath.row].tenMA
                let kCal = self.buaSang[indexPath.row].kCal!
                let protein = self.buaSang[indexPath.row].p!
                let lipit = self.buaSang[indexPath.row].l!
                let glucit = self.buaSang[indexPath.row].g!
                DispatchQueue.global().async {
                    let url = URL(string: self.buaSang[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
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
            print(buaTrua.count)
            if buaTrua.count != 0 {
                let tenMA = self.buaTrua[indexPath.row].tenMA
                let kCal = self.buaTrua[indexPath.row].kCal!
                let protein = self.buaTrua[indexPath.row].p!
                let lipit = self.buaTrua[indexPath.row].l!
                let glucit = self.buaTrua[indexPath.row].g!
                DispatchQueue.global().async {
                    let url = URL(string: self.buaTrua[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
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
            print(buaChieu.count)
            if buaChieu.count != 0 {
                let tenMA = self.buaChieu[indexPath.row].tenMA
                let kCal = self.buaChieu[indexPath.row].kCal!
                let protein = self.buaChieu[indexPath.row].p!
                let lipit = self.buaChieu[indexPath.row].l!
                let glucit = self.buaChieu[indexPath.row].g!
                DispatchQueue.global().async {
                    let url = URL(string: self.buaChieu[indexPath.row].imageURL)!
                    let imageData = try! Data(contentsOf: url)
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
