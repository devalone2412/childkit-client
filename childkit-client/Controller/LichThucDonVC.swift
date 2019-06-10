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
import FirebaseDatabase

class LichThucDonVC: UIViewController {

    @IBOutlet weak var lichTableView: UITableView!
    @IBOutlet weak var vietBinhLuanBtn: CornerButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var periodInWeek: UILabel!
    @IBOutlet weak var thuSC: UISegmentedControl!
    
    var dateStart: Date = Date.today().previous(.monday)
    var dateEnd: Date = Date.today().next(.sunday)
    var listLichNau_Sorted = [LichNau]()
    var thu: String = "Thứ 2"
    var listMA = [MonAn]()
    var buaSang = [MonAn]()
    var buaTrua = [MonAn]()
    var buaChieu = [MonAn]()
    var maLich: String!
    lazy var index = self.listLichNau_Sorted.count - 1
    
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
        getDataLichNau()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
        getDataLichNau()
    }
    
    @IBAction func thuSCChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            thu = "Thứ 2"
        case 1:
            thu = "Thứ 3"
        case 2:
            thu = "Thứ 4"
        case 3:
            thu = "Thứ 5"
        case 4:
            thu = "Thứ 6"
        default:
            thu = "Thứ 2"
        }
        getDataLichNau()
    }
    func getDataLichNau() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var listLichNau = [LichNau]()
        
        ref_TD.observe(.value) { (snapshot) in
            self.listLichNau_Sorted.removeAll()
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                self.maLich = data.key
                let lichNauObjs = data.value as! [String: AnyObject]
                let ten = lichNauObjs["ten"] as! String
                let created_date = lichNauObjs["created_date"] as! String
                let end_date = lichNauObjs["end_date"] as! String
                let start_date = lichNauObjs["start_date"] as! String
                let vote_number = lichNauObjs["vote_number"] as! String
                let vote_status = lichNauObjs["vote_status"] as! String
                let thu2 = lichNauObjs["Thứ 2"] as! [String: [String]]
                let thu3 = lichNauObjs["Thứ 3"] as! [String: [String]]
                let thu4 = lichNauObjs["Thứ 4"] as! [String: [String]]
                let thu5 = lichNauObjs["Thứ 5"] as! [String: [String]]
                let thu6 = lichNauObjs["Thứ 6"] as! [String: [String]]
                
                let lichNau = LichNau(ten: ten, start_date: start_date, end_date: end_date, thu2: thu2, thu3: thu3, thu4: thu4, thu5: thu5, thu6: thu6, vote_number: vote_number, vote_status: vote_status, created_date: created_date)
                listLichNau.append(lichNau)
            }
            
            self.listLichNau_Sorted = listLichNau.sorted(by: { (lichNau1, lichNau2) -> Bool in
                return dateFormatter.date(from: lichNau1.start_date)?.compare(dateFormatter.date(from: lichNau2.start_date)!) == ComparisonResult.orderedAscending
            })
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeZone = TimeZone(secondsFromGMT: 25200)
            dateFormatter2.defaultDate = Date()
            dateFormatter2.dateFormat = "dd/MM"
            
            let lichNau = self.listLichNau_Sorted[self.index]
            let start_date = dateFormatter2.string(from: dateFormatter.date(from: lichNau.start_date)!)
            let end_date = dateFormatter2.string(from: dateFormatter.date(from: lichNau.end_date)!)
            self.periodInWeek.text = "\(start_date) - \(end_date)"
            
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
                
                self.buaSang.removeAll()
                self.buaTrua.removeAll()
                self.buaChieu.removeAll()
                switch self.thu {
                case "Thứ 2":
                    let maMABS = lichNau.thu2!["Bữa sáng"]
                    let maMABT = lichNau.thu2!["Bữa trưa"]
                    let maMABC = lichNau.thu2!["Bữa chiều"]
                    
                    self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABS?.contains(monAn.maMA))!
                    })
                    
                    self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABT?.contains(monAn.maMA))!
                    })
                    
                    self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABC?.contains(monAn.maMA))!
                    })
                case "Thứ 3":
                    let maMABS = lichNau.thu3!["Bữa sáng"]
                    let maMABT = lichNau.thu3!["Bữa trưa"]
                    let maMABC = lichNau.thu3!["Bữa chiều"]
                    
                    self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABS?.contains(monAn.maMA))!
                    })
                    
                    self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABT?.contains(monAn.maMA))!
                    })
                    
                    self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABC?.contains(monAn.maMA))!
                    })
                case "Thứ 4":
                    let maMABS = lichNau.thu4!["Bữa sáng"]
                    let maMABT = lichNau.thu4!["Bữa trưa"]
                    let maMABC = lichNau.thu4!["Bữa chiều"]
                    
                    self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABS?.contains(monAn.maMA))!
                    })
                    
                    self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABT?.contains(monAn.maMA))!
                    })
                    
                    self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABC?.contains(monAn.maMA))!
                    })
                case "Thứ 5":
                    let maMABS = lichNau.thu5!["Bữa sáng"]
                    let maMABT = lichNau.thu5!["Bữa trưa"]
                    let maMABC = lichNau.thu5!["Bữa chiều"]
                    
                    self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABS?.contains(monAn.maMA))!
                    })
                    
                    self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABT?.contains(monAn.maMA))!
                    })
                    
                    self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABC?.contains(monAn.maMA))!
                    })
                case "Thứ 6":
                    let maMABS = lichNau.thu6!["Bữa sáng"]
                    let maMABT = lichNau.thu6!["Bữa trưa"]
                    let maMABC = lichNau.thu6!["Bữa chiều"]
                    
                    self.buaSang = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABS?.contains(monAn.maMA))!
                    })
                    
                    self.buaTrua = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABT?.contains(monAn.maMA))!
                    })
                    
                    self.buaChieu = self.listMA.filter({ (monAn) -> Bool in
                        return (maMABC?.contains(monAn.maMA))!
                    })
                default:
                    return
                }
                
                print(self.buaSang, self.buaTrua, self.buaChieu)
                self.lichTableView.reloadData()
            }
        }
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
        binhLuanVC.maLich = maLich
        binhLuanVC.thu = thu
        navigationController?.pushViewController(binhLuanVC, animated: true)
    }
    
    @IBAction func ghiChuWasPressed(_ sender: UIButton) {
        let ghiChuVC = (storyboard?.instantiateViewController(withIdentifier: "ghichu") as? GhiChuVC)!
        navigationController?.pushViewController(ghiChuVC, animated: true)
    }
    
    @IBAction func truocWasPressed(_ sender: CornerButton) {
        if index >= 0 {
            index -= 1
            getDataLichNau()
        }
    }
    
    @IBAction func sauWasPressed(_ sender: CornerButton) {
        if index <= listLichNau_Sorted.count - 1 {
            index += 1
            getDataLichNau()
        }
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
        let cell = lichTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LichCell
        switch indexPath.section {
        case 0:
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
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                }
            }
            return cell!
        case 1:
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
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                }
            }
            return cell!
        case 2:
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
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                }
            }
            return cell!
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.headerView(forSection: section)?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
