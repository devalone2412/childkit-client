//
//  ChinhSuaNLVC.swift
//  childkit-client
//
//  Created by sang luc on 6/22/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChinhSuaNLVC: UIViewController {

    @IBOutlet weak var imageNL: UIImageView!
    @IBOutlet weak var giaTf: UITextField!
    @IBOutlet weak var tenTf: UITextField!
    @IBOutlet weak var dvTinh1: UITextField!
    @IBOutlet weak var dvTinh2: UILabel!
    
    var nguyenLieu: NguyenLieu!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showData()
    }
    
    func showData() {
        giaTf.text = nguyenLieu.gia!
        tenTf.text = nguyenLieu.tenNL!
        dvTinh1.text = nguyenLieu.donVi1!
        dvTinh2.text = nguyenLieu.donVi2!
        
        DispatchQueue.global().async {
            let url = URL(string: self.nguyenLieu.imageURL)!
            let imageData = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)!
                self.imageNL.image = image
            }
        }
    }

    @IBAction func luuBtnWasPressed(_ sender: CornerButton) {
        if giaTf.text != nguyenLieu.gia {
            let giaMoi = Int(giaTf.text!)!
            ref_NL.child(nguyenLieu.key).updateChildValues(["gia": giaTf.text!])
            ref_MA_T.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maTObjs = data.value as! [String: AnyObject]
                    let giaCu = maTObjs["gia"] as! String
                    let listNguyenLieu = maTObjs["nguyenlieu"] as! [[String: String]]
                    for nl in listNguyenLieu {
                        if nl["maNL"] == self.nguyenLieu.maNL {
                            guard let giaNLCu = Int(self.nguyenLieu.gia) else {return}
                            guard let SL = Int(nl["SL"]!) else {return}
                            let giaMoi = Int(giaCu)! - (giaNLCu * SL) + (giaMoi * SL)
                            ref_MA_T.child(data.key).updateChildValues(["gia": "\(giaMoi)"])
                        }
                        break
                    }
                }
            }
            
            ref_MA_DT.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let maTObjs = data.value as! [String: AnyObject]
                    let giaCu = maTObjs["gia"] as! String
                    let listNguyenLieu = maTObjs["nguyenlieu"] as! [[String: String]]
                    for nl in listNguyenLieu {
                        if nl["maNL"] == self.nguyenLieu.maNL {
                            guard let giaNLCu = Int(self.nguyenLieu.gia) else {return}
                            guard let SL = Int(nl["SL"]!) else {return}
                            let giaMoi = Int(giaCu)! - (giaNLCu * SL) + (giaMoi * SL)
                            ref_MA_DT.child(data.key).updateChildValues(["gia": "\(giaMoi)"])
                        }
                        break
                    }
                }
            }
            
            let alert = UIAlertController(title: "Thông báo", message: "Cập nhật thành công", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
