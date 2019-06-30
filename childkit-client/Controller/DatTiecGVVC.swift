//
//  DatTiecGVVC.swift
//  childkit-client
//
//  Created by sang luc on 5/25/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController
import FirebaseDatabase
import DatePickerDialog
import FirebaseAuth
import ChameleonFramework
import MessageUI

class DatTiecGVVC: UIViewController, GetListData, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var imageGV: UIImageView!
    @IBOutlet weak var tenGV: UILabel!
    @IBOutlet weak var phongLop: UILabel!
    @IBOutlet weak var dateSelectBtn: CornerButton!
    @IBOutlet weak var soKhauPhanAn: UITextField!
    @IBOutlet weak var foodBirthTableView: CornerTableView!
    @IBOutlet weak var giaDatTiecTxt: UILabel!
    @IBOutlet weak var descriptionDT: UITextView!
    
    var gv: NhanVien!
    var listMASelected = [MonAn]()
    var isReset:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDataGV()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        giaDatTiecTxt.text = "0 VNĐ"
        
        soKhauPhanAn.delegate = self
        descriptionDT.delegate = self
        foodBirthTableView.delegate = self
        foodBirthTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Đăng xuất", style: .plain, target: self, action: #selector(dangXuat))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditting))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
    }
    
    @objc func endEditting() {
        self.view.endEditing(true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDataGV()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let soKPAn = Int(textField.text!)
        var tongGiaThucDon = 0
        for i in self.listMASelected {
            tongGiaThucDon += Int(i.gia)!
        }
        let giaKPAn = tongGiaThucDon * soKPAn!
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        self.giaDatTiecTxt.text = "\(numberFormatter.string(from: NSNumber(value: giaKPAn))!) VNĐ"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionDT.text = ""
        descriptionDT.textColor = .black
    }
    
    func getDataGV() {
        print("Đã vào")
        ref_NV.observe(.value) { (snapshot) in
            for data in snapshot.children.allObjects as! [ DataSnapshot] {
                let nvObjs = data.value as! [String: AnyObject]
                if nvObjs["email"] as! String == defaults.object(forKey: "email") as! String {
                    let maNV = data.key
                    let hoTen = nvObjs["hoTen"] as! String
                    let lop = nvObjs["lop"] as! String
                    let phong = nvObjs["phong"] as! String
                    let photoUrl = nvObjs["photoUrl"] as! String
                    
                    self.gv = NhanVien(maNV: maNV, hoTen: hoTen, lop: lop, phong: phong, photoUrl: photoUrl)
                    break
                }
            }
            self.tenGV.text = self.gv.hoTen
            self.phongLop.text = self.gv.lop != "None" ? "Lớp: \(self.gv.lop!)" : "Phòng: \(self.gv.phong!)"
            DispatchQueue.global().async {
                let url = URL(string: self.gv.photoUrl)!
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    self.imageGV.image = image
                }
            }
            
        }
    }
    
    func getListMASelected(listMASelected: [MonAn]) {
        self.listMASelected += listMASelected
        
        if !soKhauPhanAn.text!.isEmpty {
            let soKPAn = Int(soKhauPhanAn.text!)
            var tongGiaThucDon = 0
            for i in self.listMASelected {
                tongGiaThucDon += Int(i.gia)!
            }
            
            let giaKPAn = tongGiaThucDon * soKPAn!
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            self.giaDatTiecTxt.text = "\(numberFormatter.string(from: NSNumber(value: giaKPAn))!) VNĐ"
        } else {
            
        }
        self.foodBirthTableView.reloadData()
    }
    
    @IBAction func pickDateWasPressed(_ sender: CornerButton) {
        datePickerTapped()
    }
    
    func datePickerTapped() {
        DatePickerDialog().show("Chọn ngày tổ chức", doneButtonTitle: "Chọn", cancelButtonTitle: "Huỷ", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 25200)
                dateFormatter.dateFormat = "ccc"
                
                let datePicked = dateFormatter.string(from: dt)
                
                
                let today = formatter.date(from: formatter.string(from: Date()))
                
                let calendar = Calendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: today!)
                let date2 = calendar.startOfDay(for: formatter.date(from: formatter.string(from: dt))!)
                
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                
                if today?.compare(formatter.date(from: formatter.string(from: dt))!) == ComparisonResult.orderedDescending {
                    self.view.makeToast("Ngày tổ chức không thể nhỏ hơn ngày hiện tại", duration: 1.5, position: .bottom)
                } else if datePicked == "Sat" || datePicked == "Sun" {
                    self.view.makeToast("Ngày tổ chức không thể là ngày cuối tuần", duration: 1.5, position: .bottom)
                } else {
                    if components.day! < 7 {
                        self.view.makeToast("Ngày tổ chức phải cách ngày đặt 7 ngày", duration: 2.5, position: .bottom)
                    } else {
                        self.dateSelectBtn.setTitle(formatter.string(from: dt), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func themBtnWasPressed(_ sender: CornerButton) {
        print("Hàm them mon  ")
        let themMonAn2VC = storyboard?.instantiateViewController(withIdentifier: "themmonan2") as! ThemMonAn2VC
        themMonAn2VC.delegate = self
        navigationController?.pushViewController(themMonAn2VC, animated: true)
    }
    
    @IBAction func datBtnWasPressed(_ sender: CornerButton) {
        if !soKhauPhanAn.text!.isEmpty && dateSelectBtn.titleLabel?.text != "Chọn ngày" && soKhauPhanAn.text != "0" && listMASelected.count > 0 {
            
            var maMA = [String]()
            for i in listMASelected {
                maMA.append(i.maMA)
            }
            let datTiec = [
                "nguoiDat": gv.maNV as Any,
                "MonAn": maMA,
                "description": descriptionDT.text as Any,
                "ngayDat": dateSelectBtn.titleLabel?.text! as Any,
                "soKPAn": soKhauPhanAn.text!,
                "giaTD": giaDatTiecTxt.text!,
                "isApprove": ""
                ] as [String : Any]
            ref_DatTiec_GV.childByAutoId().setValue(datTiec)
            
//            sendMail()
            
            let alert = UIAlertController(title: "Trạng thái đặt tiệc", message: "Bạn đã đặt tiệc thành công", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.resetView()
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func sendMail() {
    let mailComposeVC = self.configMailController()
    if MFMailComposeViewController.canSendMail() {
    self.present(mailComposeVC, animated: true, completion: nil)
    } else {
    print("Không gửi được email")
    }
    }
    
    func configMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setSubject("Yêu cầu đặt tiệc mới từ giáo viên")
        mailComposerVC.setMessageBody("<b>Có yêu cầu đặt tiệc từ giáo viên \(gv.hoTen!)</b>", isHTML: true)
        mailComposerVC.setToRecipients(["devbrownbear@gmail.com"])
        mailComposerVC.mailComposeDelegate = self
        return mailComposerVC
    }
    
//    func showMailError() {
//        let sendMailErrorAlert = UIAlertController(title: "Không thể gửi email", message: "Thiết bị của bạn không thể gửi email", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        sendMailErrorAlert.addAction(dismiss)
//        self.present(sendMailErrorAlert, animated: true, completion: nil)
//    }
    
    func resetView() {
        descriptionDT.text = "Mô tả"
        descriptionDT.textColor = .gray
        soKhauPhanAn.text = ""
        dateSelectBtn.setTitle("Chọn ngày", for: .normal)
        listMASelected.removeAll()
        foodBirthTableView.reloadData()
        giaDatTiecTxt.text = "0 VNĐ"
    }
}

extension DatTiecGVVC: MFMailComposeViewControllerDelegate {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
}

extension DatTiecGVVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMASelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "foodBirthCell")
        cell.selectionStyle = .none
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let ten = listMASelected[indexPath.row].tenMA
        let gia = listMASelected[indexPath.row].gia
        cell.textLabel?.text = ten
        cell.detailTextLabel?.text = "Giá: \(numberFormatter.string(from: Int(gia) as! NSNumber)!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            self.listMASelected.remove(at: indexPath.row)
            self.foodBirthTableView.reloadData()
            print(self.listMASelected.count)
            completion(true)
        }
        delete.backgroundColor = FlatRed()
        return delete
    }
    
    
}
