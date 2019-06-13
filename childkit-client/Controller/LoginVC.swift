//
//  ViewController.swift
//  childkit-client
//
//  Created by SANG on 5/23/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseAuth
import Toast_Swift
import FirebaseDatabase

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            if defaults.object(forKey: "quyen") != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let lichThucDonVC = storyboard.instantiateViewController(withIdentifier: "lichthucdon") as! LichThucDonVC
                let nav = UINavigationController(rootViewController: lichThucDonVC)
                let revealController = self.revealViewController()
                revealController?.pushFrontViewController(nav, animated: true)
            } else {
                print("Chưa có quyền")
            }
        } else {
            if let emailData = defaults.object(forKey: "email") as? String, let passwordData = defaults.object(forKey: "password") as? String {
                emailTF.text = emailData
                passwordTF.text = passwordData
            }
        }
    }
    
    func configDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dangNhapWasPressed(_ sender: CornerButton) {
        dismissKeyboard()
        self.view.makeToastActivity(.center)
        if let email = emailTF.text, let password = passwordTF.text, email != "", password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if error == nil {
                    var quyen = ""
                    guard let user = authResult?.user else { return }
                    ref_PH.observe(.value, with: { (snapshot) in
                        for data in snapshot.children.allObjects as! [DataSnapshot] {
                            let phObjs = data.value as! [String: AnyObject]
                            if user.uid == phObjs["uid"] as! String {
                                quyen = (phObjs["quyen"] as? String)!
                                defaults.set(quyen, forKey: "quyen")
                                defaults.set(email, forKey: "email")
                                defaults.set(password, forKey: "password")
                                
                                if quyen != "" {
                                    if defaults.object(forKey: "quyen") as! String != "GV" {
                                        let lichThucDonVC = self.storyboard?.instantiateViewController(withIdentifier: "lichthucdon") as! LichThucDonVC
                                        let nav = UINavigationController(rootViewController: lichThucDonVC)
                                        let revealController = self.revealViewController()
                                        revealController!.pushFrontViewController(nav, animated: true)
                                    } else {
                                        let datTiecGV = self.storyboard?.instantiateViewController(withIdentifier: "datTiecGV") as! DatTiecGVVC
                                        let nav = UINavigationController(rootViewController: datTiecGV)
                                        let revealController = self.revealViewController()
                                        revealController!.pushFrontViewController(nav, animated: true)
                                    }
                                } else {
                                    print("Chưa có quyền")
                                }
                                break
                            }
                        }
                    })
                    
                    if quyen == "" {
                        ref_NV.observe(.value, with: { (snapshot) in
                            for data in snapshot.children.allObjects as! [DataSnapshot] {
                                let nvObjs = data.value as! [String: AnyObject]
                                if user.uid == nvObjs["uid"] as! String {
                                    quyen = (nvObjs["quyen"] as? String)!
                                    defaults.set(quyen, forKey: "quyen")
                                    defaults.set(email, forKey: "email")
                                    defaults.set(password, forKey: "password")
                                    
                                    if quyen != "" {
                                        let lichThucDonVC = self.storyboard?.instantiateViewController(withIdentifier: "lichthucdon") as! LichThucDonVC
                                        let nav = UINavigationController(rootViewController: lichThucDonVC)
                                        let revealController = self.revealViewController()
                                        revealController!.pushFrontViewController(nav, animated: true)
                                    } else {
                                        print("Chưa có quyền")
                                    }
                                    break
                                }
                            }
                        })
                    }
                    
                    
                } else {
                    self.view.hideToastActivity()
                    print("Đăng nhập thất bại")
                    self.view.makeToast("Email hoặc mật khẩu không đúng", duration: 1.5, position: .bottom)
                }
            }
        } else {
            self.view.hideToastActivity()
            self.view.makeToast("Không được bỏ trống email / password", duration: 1.5, position: .bottom)
        }
    }
}

