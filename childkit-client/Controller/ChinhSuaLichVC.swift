//
//  ChinhSuaLichVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChinhSuaLichVC: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var buaSC: UISegmentedControl!
    @IBOutlet weak var danhSachMA: UITableView!
    
    var thucDon: String!
    var thu: String!
    var bua: String = "Bữa sáng"
    var buaSang = [MonAn]()
    var buaTrua = [MonAn]()
    var buaChieu = [MonAn]()
    var monAnTheoBua = [MonAn]()
    var listMA = [MonAn]()
    var maMA = [[String]]()
    var key: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Quay lại", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMonAn))
        danhSachMA.delegate = self
        danhSachMA.dataSource = self
    }
    
    func getDataMA() {
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
        }
        
        ref_TD_Vote.child(key).child("\(thu!)").observe(.value) { (snapshot) in
            self.maMA.removeAll()
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let data = data.value as! [String]
                self.maMA.append(data)
            }
            print(self.maMA)
            switch self.bua {
            case "Bữa sáng":
                self.monAnTheoBua = []
                print("Đã vào bữa sáng")
                if self.maMA.count < 3 && self.maMA.count > 0 {
                    self.monAnTheoBua = self.listMA.filter({ (monAn) -> Bool in
                        self.maMA[0].contains(monAn.maMA)
                    })
                    print(self.monAnTheoBua)
                } else if self.maMA.count == 3{
                    self.monAnTheoBua = self.listMA.filter({ (monAn) -> Bool in
                        self.maMA[1].contains(monAn.maMA)
                    })
                } else {
                    self.monAnTheoBua = []
                }
            case "Bữa trưa":
                self.monAnTheoBua = []
                print("Đã vào bữa trưa")
                if self.maMA.count < 3 && self.maMA.count > 0 {
                    self.monAnTheoBua = self.listMA.filter({ (monAn) -> Bool in
                        self.maMA[1].contains(monAn.maMA)
                    })
                } else if self.maMA.count == 3 {
                    self.monAnTheoBua = self.listMA.filter({ (monAn) -> Bool in
                        self.maMA[2].contains(monAn.maMA)
                    })
                } else {
                    self.monAnTheoBua = []
                }
            case "Bữa chiều":
                self.monAnTheoBua = []
                print("Đã vào bữa  ")
                if self.maMA.count == 3 {
                    self.monAnTheoBua = self.listMA.filter({ (monAn) -> Bool in
                        self.maMA[0].contains(monAn.maMA)
                    })
                } else {
                    self.monAnTheoBua = []
                }
            default:
                return
            }
            print(self.monAnTheoBua)
            self.danhSachMA.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainTitle.text = "\(thucDon!) - \(thu!)"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        switch thu {
        case "Thứ 2":
            title = "\(dateFormatter.string(from: Date.today().next(.monday)))"
        case "Thứ 3":
            title = "\(dateFormatter.string(from: Date.today().next(.tuesday)))"
        case "Thứ 4":
            title = "\(dateFormatter.string(from: Date.today().next(.wednesday)))"
        case "Thứ 5":
            title = "\(dateFormatter.string(from: Date.today().next(.thursday)))"
        case "Thứ 6":
            title = "\(dateFormatter.string(from: Date.today().next(.friday)))"
        default:
            return
        }
        
        getDataMA()
    }
    
    @objc func addMonAn() {
        let themMonAnVC = (storyboard?.instantiateViewController(withIdentifier: "themmonan") as? ThemMonAnVC)!
        themMonAnVC.thucDon = thucDon
        themMonAnVC.thu = thu
        themMonAnVC.bua = bua
        navigationController?.pushViewController(themMonAnVC, animated: true)
    }
    
    @IBAction func buaSCValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            monAnTheoBua = []
            bua = "Bữa sáng"
            if self.maMA.count < 3 && self.maMA.count > 0 {
                monAnTheoBua = listMA.filter({ (monAn) -> Bool in
                    maMA[0].contains(monAn.maMA)
                })
            } else if self.maMA.count == 3 {
                monAnTheoBua = listMA.filter({ (monAn) -> Bool in
                    maMA[1].contains(monAn.maMA)
                })
            } else {
                monAnTheoBua = []
            }
        case 1:
            monAnTheoBua = []
            bua = "Bữa trưa"
            if self.maMA.count < 3 && self.maMA.count > 1 {
                monAnTheoBua = listMA.filter({ (monAn) -> Bool in
                    maMA[1].contains(monAn.maMA)
                })
            } else if self.maMA.count == 3 {
                monAnTheoBua = listMA.filter({ (monAn) -> Bool in
                    maMA[2].contains(monAn.maMA)
                })
            } else {
                monAnTheoBua = []
            }
        case 2:
            monAnTheoBua = []
            bua = "Bữa chiều"
            if self.maMA.count == 3 {
                monAnTheoBua = listMA.filter({ (monAn) -> Bool in
                    maMA[0].contains(monAn.maMA)
                })
            } else {
                monAnTheoBua = []
            }
        default:
            return
        }
        danhSachMA.reloadData()
    }
}

extension ChinhSuaLichVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch buaSC.selectedSegmentIndex {
//        case 0:
//            return buaSang.count
//        case 1:
//            return buaTrua.count
//        case 2:
//            return buaChieu.count
//        default:
//            return 0
//        }
        return monAnTheoBua.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !monAnTheoBua.isEmpty {
            print("Đã vào")
            let cell = self.danhSachMA.dequeueReusableCell(withIdentifier: "modifyFoodCell", for: indexPath) as? ChinhSuaLichCell
            DispatchQueue.global().async {
                let url = URL(string: self.monAnTheoBua[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                let tenMA = self.monAnTheoBua[indexPath.row].tenMA
                let kCal = self.monAnTheoBua[indexPath.row].kCal!
                let protein = self.monAnTheoBua[indexPath.row].p!
                let lipit = self.monAnTheoBua[indexPath.row].l!
                let glucit = self.monAnTheoBua[indexPath.row].g!
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit)
                }
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
        
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.monAnTheoBua.remove(at: indexPath.row)
            ref_TD_Vote.child(self.key).child("\(self.thu!)").child("\(self.bua)").updateChildValues(["\(indexPath.row)": ""])
            print("Deleted")
            completion(true)
        }
        delete.backgroundColor = .red
        return delete
    }
    
    
}
