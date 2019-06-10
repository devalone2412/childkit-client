//
//  BinhLuanVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BinhLuanVC: UIViewController {

    @IBOutlet weak var danhSachBinhLuanTableView: UITableView!
    @IBOutlet weak var noiDungTV: UITextView!
    
    var listBinhLuan = [BinhLuan]()
    var thu: String!
    var maLich: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        danhSachBinhLuanTableView.delegate = self
        danhSachBinhLuanTableView.dataSource = self
        danhSachBinhLuanTableView.showsVerticalScrollIndicator = true
        
//        noiDungTV.isScrollEnabled = false
//        resize(textView: noiDungTV)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataBinhLuan()
    }
    
    func getDataBinhLuan() {
        ref_comment.child(maLich).child(thu).observe(.value) { (snapshot) in
            self.listBinhLuan.removeAll()
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let commentObjs = data.value as! [String: AnyObject]
                let imagePHUrl = commentObjs["imagePHURL"] as! String
                let tenPH = commentObjs["tenPH"] as! String
                let noidung = commentObjs["noidung"] as! String
                let like_number = commentObjs["like_number"] as! String
                
                let comment = BinhLuan(imagePHURL: imagePHUrl, tenPH: tenPH, noiDung: noidung, like_number: like_number, maComment: data.key)
                self.listBinhLuan.append(comment)
            }
//            self.listBinhLuan = self.listBinhLuan.reversed()
            self.danhSachBinhLuanTableView.reloadData()
        }
    }
    
    fileprivate func resize(textView: UITextView) {
        var newFrame = textView.frame
        let width = newFrame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        textView.frame = newFrame
    }

    @IBAction func sendBtn(_ sender: BorderButton) {
        
        if let user = Auth.auth().currentUser {
            ref_PH.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let phObjs = data.value as! [String: AnyObject]
                    if phObjs["email"] as? String == user.email && self.noiDungTV.text != "" {
                        let comment = [
                            "imagePHURL": phObjs["imageUrl"] as! String,
                            "tenPH": phObjs["ten"] as! String,
                            "like_number": "0",
                            "noidung": self.noiDungTV.text!
                            ] as [String : Any]
                        ref_comment.child(self.maLich).child(self.thu).childByAutoId().setValue(comment)
                        self.view.endEditing(true)
                        self.noiDungTV.text = ""
                    }
                }
            }
        }
    }
}

extension BinhLuanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBinhLuan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = danhSachBinhLuanTableView.dequeueReusableCell(withIdentifier: "binhLuanCell", for: indexPath) as? BinhLuanCell
        DispatchQueue.global().async {
            let url = URL(string: self.listBinhLuan[indexPath.row].imagePHURL)!
            let imageData = try! Data(contentsOf: url)
            let tenPH = self.listBinhLuan[indexPath.row].tenPH
            let noidung = self.listBinhLuan[indexPath.row].noiDung
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)!
                cell?.configure(image: image, tenPH: tenPH!, binhLuan: noidung!)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = likeAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [like])
    }
    
    func likeAction(indexPath: IndexPath) -> UIContextualAction {
        var numLike = Int(listBinhLuan[indexPath.row].like_number)
        let like = UIContextualAction(style: .normal, title: "(\(numLike!))") { (action, view, completion) in
            print("Tăng like")
            numLike! += 1
            ref_comment.child(self.maLich).child(self.thu).child(self.listBinhLuan[indexPath.row].maComment).updateChildValues(["like_number": String(numLike!)])
            self.danhSachBinhLuanTableView.reloadData()
        }
        
        like.backgroundColor = .blue
        like.image = UIImage(named: "like")
        print("Đã gọi")
        return like
    }
    
}
