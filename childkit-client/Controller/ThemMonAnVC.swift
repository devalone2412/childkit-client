//
//  ThemMonAnVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import iOSDropDown
import FirebaseDatabase

class ThemMonAnVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var timMonAnSB: UISearchBar!
    @IBOutlet weak var danhSachMonAnTableView: UITableView!
    @IBOutlet weak var categoryDropdown: DropDown!
    
    var listMA = [MonAn]()
    var listMA_Temp = [MonAn]()
    var filteredData = [MonAn]()
    var listCategory = [Category]()
    var isSearching = false
    var thucDon: String!
    var thu: String!
    var bua: String!
    var selectedMA = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Thêm", style: .plain, target: self, action: #selector(themMonAn))
        danhSachMonAnTableView.delegate = self
        danhSachMonAnTableView.dataSource = self
        
        configDropdown()
        getDataMA()
        
        timMonAnSB.delegate = self
        timMonAnSB.returnKeyType = UIReturnKeyType.done
    }
    
    func getDataMA() {
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
                let gia = monAnObjs["gia"] as! String
                
                let monAn = MonAn(g: g, kCal: kCal, l: l, p: p, imageURL: imageURL, maCategory: maCategory, maMA: maMA, nguyenLieu: nguyenLieu, tenMA: tenMA, isChecked: isChecked)
                monAn.gia = gia
                self.listMA.append(monAn)
                
            }
            self.listMA_Temp = self.listMA
            self.danhSachMonAnTableView.reloadData()
        }
    }
    
    func configDropdown() {
        ref_Category.observe(.value) { (snapshot) in
            self.listCategory.removeAll()
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let categoryObjs = data.value as! [String: AnyObject]
                let imageURL = categoryObjs["imageURL"] as! String
                let maCategory = categoryObjs["maCategory"] as! String
                let tenCategory = categoryObjs["tenCategory"] as! String
                
                let category = Category(imageURL: imageURL, maCategory: maCategory, tenCategory: tenCategory, keyCategory: data.key)
                self.listCategory.append(category)
            }
            var listCate = [String]()
            for category in self.listCategory {
                listCate.append(category.tenCategory)
            }
            self.categoryDropdown.optionArray = ["All"] + listCate
//            categoryDropdown.optionIds = [0, 1, 2, 3, 4, 5]
        }
        categoryDropdown.isSearchEnable = false
        categoryDropdown.selectedRowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        categoryDropdown.didSelect { (selectedText, index, id) in
            if selectedText != "All" {
                self.listMA.removeAll()
                self.listMA = self.listMA_Temp
                self.listMA = self.listMA.filter({ (monAn) -> Bool in
                    monAn.maCategory == self.listCategory[index - 1].maCategory
                })
                self.danhSachMonAnTableView.reloadData()
            } else {
                self.listMA = self.listMA_Temp
                self.danhSachMonAnTableView.reloadData()
            }
        }
    }
    
    @objc func themMonAn() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
        dateFormatter.defaultDate = Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        var key: String!
        switch thucDon {
        case "Thực đơn 1":
            key = defaults.object(forKey: "key_TD1") as? String
        case "Thực đơn 2":
            key = defaults.object(forKey: "key_TD2") as? String
        default:
            return
        }
        
        ref_TD_Vote.child(key).child("\(thu!)").updateChildValues(["\(bua!)" : selectedMA])
        
        for monAn in listMA {
            monAn.isChecked = false
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if timMonAnSB.text == nil || timMonAnSB.text == "" {
            isSearching = false
            view.endEditing(true)
            danhSachMonAnTableView.reloadData()
        } else {
            isSearching = true
            filteredData = listMA.filter({ (monAn) -> Bool in
                monAn.tenMA.contains(searchText)
            })
            danhSachMonAnTableView.reloadData()
        }
    }
}

extension ThemMonAnVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return listMA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = danhSachMonAnTableView.dequeueReusableCell(withIdentifier: "monAnCell", for: indexPath) as? MonAnCell
        DispatchQueue.global().async {
            if self.isSearching {
                let url = URL(string: self.filteredData[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                let tenMA = self.filteredData[indexPath.row].tenMA
                let kCal = self.filteredData[indexPath.row].kCal!
                let protein = self.filteredData[indexPath.row].p!
                let lipit = self.filteredData[indexPath.row].l!
                let glucit = self.filteredData[indexPath.row].g!
                let giaMA = self.filteredData[indexPath.row].gia
                
                DispatchQueue.main.async {
                    if self.listMA[indexPath.row].isChecked {
                        cell?.accessoryType = .checkmark
                    } else {
                        cell?.accessoryType = .none
                    }
                    let image = UIImage(data: imageData)!
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit, giaMA: giaMA)
                }
            } else {
                let url = URL(string: self.listMA[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                let tenMA = self.listMA[indexPath.row].tenMA
                let kCal = self.listMA[indexPath.row].kCal!
                let protein = self.listMA[indexPath.row].p!
                let lipit = self.listMA[indexPath.row].l!
                let glucit = self.listMA[indexPath.row].g!
                let giaMA = self.listMA[indexPath.row].gia
                DispatchQueue.main.async {
                    if self.listMA[indexPath.row].isChecked {
                        cell?.accessoryType = .checkmark
                    } else {
                        cell?.accessoryType = .none
                    }
                    let image = UIImage(data: imageData)!
                    cell?.configure(image: image, tenMon: tenMA, kCal: kCal, protein: protein, lipit: lipit, glucit: glucit, giaMA: giaMA)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listMA[indexPath.row].isChecked {
            selectedMA.append(listMA[indexPath.row].maMA)
            danhSachMonAnTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            listMA[indexPath.row].isChecked = true
        } else {
            if let index = selectedMA.firstIndex(of: listMA[indexPath.row].maMA) {
                selectedMA.remove(at: index)
            }
            danhSachMonAnTableView.cellForRow(at: indexPath)?.accessoryType = .none
            listMA[indexPath.row].isChecked = false
        }
    }
}
