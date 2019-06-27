//
//  AddFoodNoCategory.swift
//  childkit-client
//
//  Created by sang luc on 6/17/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ChameleonFramework

class AddFoodNoCategory: UIViewController {

    @IBOutlet weak var monAnTableView: UITableView!
    var category: Category!
    var listMA = [MonAn]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Danh sách món ăn"
        monAnTableView.delegate = self
        monAnTableView.dataSource = self
        getData()
    }
    
    func getData() {
        ref_MA.observe(.value) { (_) in
            self.listMA.removeAll()
            ref_MA_T.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maObjs = data.value as! [String: AnyObject]
                    if maObjs["maCategory"] as! String == "" {
                        let cal = maObjs["Cal"] as! String
                        let g = maObjs["G"] as! String
                        let l = maObjs["L"] as! String
                        let p = maObjs["P"] as! String
                        let gia = maObjs["gia"] as! String
                        let imageURL = maObjs["imageURL"] as! String
                        let maCategory = maObjs["maCategory"] as! String
                        let maMA = maObjs["maMA"] as! String
                        let nguyenlieu = maObjs["nguyenlieu"] as! [[String: String]]
                        let tenMA = maObjs["tenMA"] as! String
                        
                        let ma = MonAn(g: g, kCal: cal, l: l, p: p, imageURL: imageURL, maCategory: maCategory, maMA: maMA, nguyenLieu: nguyenlieu, tenMA: tenMA, isChecked: false)
                        ma.gia = gia
                        
                        self.listMA.append(ma)
                    }
                }
                
                ref_MA_DT.observeSingleEvent(of:.value, with: { (snapshot) in
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        let maObjs = data.value as! [String: AnyObject]
                        if maObjs["maCategory"] as! String == "" {
                            let cal = maObjs["Cal"] as! String
                            let g = maObjs["G"] as! String
                            let l = maObjs["L"] as! String
                            let p = maObjs["P"] as! String
                            let gia = maObjs["gia"] as! String
                            let imageURL = maObjs["imageURL"] as! String
                            let maCategory = maObjs["maCategory"] as! String
                            let maMA = maObjs["maMA"] as! String
                            let nguyenlieu = maObjs["nguyenlieu"] as! [[String: String]]
                            let tenMA = maObjs["tenMA"] as! String
                            
                            let ma = MonAn(g: g, kCal: cal, l: l, p: p, imageURL: imageURL, maCategory: maCategory, maMA: maMA, nguyenLieu: nguyenlieu, tenMA: tenMA, isChecked: false)
                            ma.gia = gia
                            
                            self.listMA.append(ma)
                        }
                    }
                    print(self.listMA)
                    self.monAnTableView.reloadData()
                })
                
                
            }
        }
    }

}

extension AddFoodNoCategory: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = monAnTableView.dequeueReusableCell(withIdentifier: "foodNoCategory", for: indexPath) as? MonAnCell
        let tenMA = self.listMA[indexPath.row].tenMA
        let kCal = self.listMA[indexPath.row].kCal!
        let protein = self.listMA[indexPath.row].p!
        let lipit = self.listMA[indexPath.row].l!
        let glucit = self.listMA[indexPath.row].g!
        let gia = self.listMA[indexPath.row].gia
        DispatchQueue.global().async {
            let url = URL(string: self.listMA[indexPath.row].imageURL)!
            let imageData = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)!
                cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit, giaMA: gia)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let themVaoCategory = themVaoCategoryAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [themVaoCategory])
    }
    
    func themVaoCategoryAction(indexPath: IndexPath) -> UIContextualAction {
        var isFinded = false
        let them = UIContextualAction(style: .normal, title: "Thêm vào danh mục \(category.tenCategory!)") { (_, _, completion) in
            ref_MA_T.observeSingleEvent(of: .value, with: { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maObjs = data.value as! [String: AnyObject]
                    if maObjs["maMA"] as! String == self.listMA[indexPath.row].maMA {
                        ref_MA_T.child(data.key).updateChildValues(["maCategory": "\(self.category.maCategory!)"])
                        isFinded = true
                        break;
                    }
                }
                
                if isFinded == false {
                    ref_MA_DT.observeSingleEvent(of: .value, with: { (snapshot) in
                        for data in snapshot.children.allObjects as! [DataSnapshot] {
                            let maObjs = data.value as! [String: AnyObject]
                            if maObjs["maMA"] as! String == self.listMA[indexPath.row].maMA {
                                ref_MA_DT.child(data.key).updateChildValues(["maCategory": "\(self.category.maCategory!)"])
                                isFinded = true
                                break;
                            }
                        }
                    })
                }
            })
            completion(true)
        }
        
        them.backgroundColor = FlatGreen()
        
        return them
    }
}

