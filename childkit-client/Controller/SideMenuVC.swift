//
//  SideMenuVC.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import FirebaseAuth

class SideMenuVC: UIViewController {
    

    @IBOutlet weak var lichNauAn: UIButton!
    @IBOutlet weak var xemLichDatTiec: UIButton!
    @IBOutlet weak var bauChon: UIButton!
    @IBOutlet weak var datTiec: UIButton!
    @IBOutlet weak var categoryMA: UIButton!
    @IBOutlet weak var nguyenLieu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        loadFunc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFunc()
    }
    
    func loadFunc() {
        switch defaults.object(forKey: "quyen") as! String {
        case "BT":
            lichNauAn.isHidden = false
            xemLichDatTiec.isHidden = false
            bauChon.isHidden = true
            datTiec.isHidden = true
            categoryMA.isHidden = false
            nguyenLieu.isHidden = true
        case "NVB":
            lichNauAn.isHidden = false
            xemLichDatTiec.isHidden = false
            bauChon.isHidden = true
            datTiec.isHidden = true
            categoryMA.isHidden = true
            nguyenLieu.isHidden = true
        case "NVK":
            lichNauAn.isHidden = true
            xemLichDatTiec.isHidden = true
            bauChon.isHidden = true
            datTiec.isHidden = true
            categoryMA.isHidden = true
            nguyenLieu.isHidden = false
        case "GV":
            lichNauAn.isHidden = false
            xemLichDatTiec.isHidden = true
            bauChon.isHidden = true
            datTiec.isHidden = true
            categoryMA.isHidden = true
            nguyenLieu.isHidden = true
        case "PH":
            lichNauAn.isHidden = false
            bauChon.isHidden = false
            datTiec.isHidden = false
            xemLichDatTiec.isHidden = true
            categoryMA.isHidden = true
            nguyenLieu.isHidden = true
            
        default:
            return
        }
    }
    
    @IBAction func dangXuatWasPressed(_ sender: CornerButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Đăng xuất thất bại")
        }
        let revealVC = self.revealViewController()
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") as? LoginVC
        revealVC?.pushFrontViewController(loginVC, animated: true)
    }
    
    @IBAction func lichNauAnBtnWasPressed(_ sender: UIButton) {
    }
    @IBAction func bauChonBtnWasPressed(_ sender: UIButton) {
    }
    @IBAction func datTiecBtnWasPressed(_ sender: UIButton) {
    }
    @IBAction func datTiecGVBtnWasPressed(_ sender: UIButton) {
    }
    @IBAction func categoryMonAn(_ sender: UIButton) {
    }
}
