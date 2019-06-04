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

class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDismissKeyboard()
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
                    guard let user = authResult?.user else { return }
                    
                } else {
                    self.view.hideToastActivity()
                    print("Đăng nhập thất bại")
                    self.view.makeToast("Email hoặc mật khẩu không đúng", duration: 1.5, position: .bottom)
                }
            }
        }
    }
}

