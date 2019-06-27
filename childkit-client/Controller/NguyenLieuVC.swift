//
//  NguyenLieuVC.swift
//  childkit-client
//
//  Created by sang luc on 6/21/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class NguyenLieuVC: UIViewController {
    
    @IBOutlet weak var nguyenLieuSC: UISearchBar!
    @IBOutlet weak var listNLTableView: UITableView!
    
    var listNL = [NguyenLieu]()
    var isSearching = false
    var filterDataNL = [NguyenLieu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Quản lý nguyên liệu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Đăng xuất", style: .plain, target: self, action: #selector(dangXuat))
        
        listNLTableView.delegate = self
        listNLTableView.dataSource = self
        
        nguyenLieuSC.delegate = self
        
        getData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func getData() {
        ref_NL.observe(.value) { (snapshot) in
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let nlObjs = data.value as! [String: AnyObject]
                
                let tenNL = nlObjs["tenNL"] as! String
                let maNL = nlObjs["maNL"] as! String
                let imageURL = nlObjs["imageURL"] as! String
                let gia = nlObjs["gia"] as! String
                let donVi1 = nlObjs["donvi1"] as! String
                let donVi2 = nlObjs["donvi2"] as! String
                
                let nl = NguyenLieu(key: data.key, maNL: maNL, tenNL: tenNL, imageURL: imageURL, gia: gia, donVi1: donVi1, donVi2: donVi2)
                
                self.listNL.append(nl)
            }
            
            self.listNLTableView.reloadData()
        }
    }
    
    @objc func dangXuat() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Đăng xuất thất bại")
        }
        let revealVC = self.revealViewController()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC
        revealVC?.pushFrontViewController(loginVC, animated: true)
    }

}

extension NguyenLieuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterDataNL.count
        } else {
            return listNL.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listNLTableView.dequeueReusableCell(withIdentifier: "nguyenLieuCell") as! NguyenLieuCell
        
        if isSearching {
            let tenNL = filterDataNL[indexPath.row].tenNL!
            let gia = filterDataNL[indexPath.row].gia
            let donVi1 = filterDataNL[indexPath.row].donVi1
            let donVi2 = filterDataNL[indexPath.row].donVi2
            
            DispatchQueue.global().async {
                let url = URL(string: self.filterDataNL[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    cell.configure(image: image, tenNL: tenNL, gia: gia!, donVi1: donVi1!, donVi2: donVi2!)
                }
            }
        } else {
            let tenNL = listNL[indexPath.row].tenNL!
            let gia = listNL[indexPath.row].gia
            let donVi1 = listNL[indexPath.row].donVi1
            let donVi2 = listNL[indexPath.row].donVi2
            
            DispatchQueue.global().async {
                let url = URL(string: self.listNL[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    cell.configure(image: image, tenNL: tenNL, gia: gia!, donVi1: donVi1!, donVi2: donVi2!)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editNL = editNguyenLieu(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [editNL])
    }
    
    func editNguyenLieu(indexPath: IndexPath) -> UIContextualAction {
        let edit = UIContextualAction(style: .normal, title: "Sửa") { (_, _, completion) in
            let chinhSuaNLVC = self.storyboard?.instantiateViewController(withIdentifier: "chinhSuaNL") as! ChinhSuaNLVC
            if self.isSearching {
                chinhSuaNLVC.nguyenLieu = self.filterDataNL[indexPath.row]
            } else {
                chinhSuaNLVC.nguyenLieu = self.listNL[indexPath.row]
            }
            self.navigationController?.pushViewController(chinhSuaNLVC, animated: true)
            completion(true)
        }
        
        edit.backgroundColor = FlatBlue()
        return edit
    }
}

extension NguyenLieuVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if nguyenLieuSC.text == nil || nguyenLieuSC.text == "" {
            isSearching = false
            view.endEditing(true)
            listNLTableView.reloadData()
        } else {
            isSearching = true
            filterDataNL = listNL.filter({ (nl) -> Bool in
                nl.tenNL.contains(searchText)
            })
            listNLTableView.reloadData()
        }
    }
}
