//
//  FoodByCategoryVC.swift
//  childkit-client
//
//  Created by sang luc on 5/26/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FoodByCategoryVC: UIViewController {
    
    @IBOutlet weak var foodByCategoryTableView: UITableView!
    
    var category: Category!
    var listMA = [MonAn]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(themMonAn))
        // Do any additional setup after loading the view.
        foodByCategoryTableView.delegate = self
        foodByCategoryTableView.dataSource = self
        
        print(category.tenCategory!)
        getData()
    }
    
    func getData() {
        ref_MA.observe(.value) { (_) in
            self.listMA.removeAll()
            ref_MA_T.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maObjs = data.value as! [String: AnyObject]
                    if maObjs["maCategory"] as! String == self.category.maCategory {
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
                
                ref_MA_DT.observeSingleEvent(of:.value, with: { (snapshot) in
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        let maObjs = data.value as! [String: AnyObject]
                        if maObjs["maCategory"] as! String == self.category.maCategory {
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
                    self.foodByCategoryTableView.reloadData()
                })
                
                
            }
        }
    }
    
    @objc func themMonAn() {
        let addFoodNoCategory = storyboard?.instantiateViewController(withIdentifier: "addFoodNoCategory") as! AddFoodNoCategory
        addFoodNoCategory.category = category
        navigationController?.pushViewController(addFoodNoCategory, animated: true)
    }
}

extension FoodByCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodByCategoryTableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as? MonAnCell
        DispatchQueue.global().async {
            let url = URL(string: self.listMA[indexPath.row].imageURL)!
            let tenMA = self.listMA[indexPath.row].tenMA
            let kCal = self.listMA[indexPath.row].kCal!
            let protein = self.listMA[indexPath.row].p!
            let lipit = self.listMA[indexPath.row].l!
            let glucit = self.listMA[indexPath.row].g!
            let gia = self.listMA[indexPath.row].gia
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit, giaMA: gia)
                }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        var isFinded = false
        let delete = UIContextualAction(style: .destructive, title: "Xoá") { (action, view, completion) in
            ref_MA_T.observeSingleEvent(of: .value, with: { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maObjs = data.value as! [String: AnyObject]
                    if maObjs["maMA"] as! String == self.listMA[indexPath.row].maMA {
                        ref_MA_T.child(data.key).updateChildValues(["maCategory": ""])
                        isFinded = true
                        break;
                    }
                }
                
                if isFinded == false {
                    ref_MA_DT.observeSingleEvent(of: .value, with: { (snapshot) in
                        for data in snapshot.children.allObjects as! [DataSnapshot] {
                            let maObjs = data.value as! [String: AnyObject]
                            if maObjs["maMA"] as! String == self.listMA[indexPath.row].maMA {
                                ref_MA_DT.child(data.key).updateChildValues(["maCategory": ""])
                                isFinded = true
                                break;
                            }
                        }
                    })
                }
            })
            completion(true)
        }
        
        return delete
    }
    
}
