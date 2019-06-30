//
//  DatTiecVC.swift
//  childkit-client
//
//  Created by sang luc on 5/25/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit
import SWRevealViewController
import FirebaseDatabase
import FirebaseAuth
import DatePickerDialog
import Toast_Swift
import ChameleonFramework
import MessageUI

protocol GetListData {
    func getListMASelected(listMASelected: [MonAn])
}

class DatTiecPHVC: UIViewController, GetListData, UITextFieldDelegate {
    
    
    @IBOutlet weak var childTableView: CornerTableView!
    @IBOutlet weak var foodBirthTableView: CornerTableView!
    @IBOutlet weak var dateSelectBtn: CornerButton!
    @IBOutlet weak var giaDatTiecTxt: UILabel!
    @IBOutlet weak var soKhauPhanAn: UITextField!
    
    var listTre = [Tre]()
    var maTre = [String]()
    var selectTre = [Tre]()
    var listMASelected = [MonAn]()
    var keyPH: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        // Do any additional setup after loading the view.
        childTableView.delegate = self
        childTableView.dataSource = self
        foodBirthTableView.delegate = self
        foodBirthTableView.dataSource = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        giaDatTiecTxt.text = "0 VNĐ"
        
        soKhauPhanAn.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditting))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func endEditting() {
        self.view.endEditing(true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataTre()
        print(listMASelected)
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
    
    func getDataTre() {
        if let user = Auth.auth().currentUser {
            ref_PH.observeSingleEvent(of: .value) { (snapshot) in
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    let phObjs = data.value as! [String: AnyObject]
                    if phObjs["email"] as? String == user.email {
                        self.maTre = phObjs["Tre"] as! [String]
                        self.keyPH = data.key
                        break
                    }
                }
                ref_Tre.observe(.value, with: { (snapshot) in
                    self.listTre.removeAll()
                    for data in snapshot.children.allObjects as! [DataSnapshot] {
                        let maTre = data.key
                        let treObjs = data.value as! [String: AnyObject]
                        let imageUrl = treObjs["imageURL"] as! String
                        let lop = treObjs["lop"] as! String
                        let ngaySinh = treObjs["ngaySinh"] as! String
                        let ten = treObjs["ten"] as! String
                        
                        let tre = Tre(maTre: maTre, imageUrl: imageUrl, lop: lop, ngaySinh: ngaySinh, ten: ten)
                        self.listTre.append(tre)
                    }
                    
                    self.listTre = self.listTre.filter({ (tre) -> Bool in
                        self.maTre.contains(tre.maTre)
                    })
                    
                    print(self.listTre)
                    self.childTableView.reloadData()
                })
            }
        }
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
        
        let themMonAn2VC = storyboard?.instantiateViewController(withIdentifier: "themmonan2") as! ThemMonAn2VC
        themMonAn2VC.delegate = self
        navigationController?.pushViewController(themMonAn2VC, animated: true)
    }
    
    @IBAction func datBtnWasPressed(_ sender: CornerButton) {
        if !soKhauPhanAn.text!.isEmpty && dateSelectBtn.titleLabel?.text != "Chọn ngày" && soKhauPhanAn.text != "0" && selectTre.count > 0 && listMASelected.count > 0 {
            
            var maTreSelected = [String]()
            for i in selectTre {
                maTreSelected.append(i.maTre)
            }
            
            var maMA = [String]()
            for i in listMASelected {
                maMA.append(i.maMA)
            }
            let datTiec = [
                "Tre": maTreSelected,
                "nguoiDat": keyPH,
                "MonAn": maMA,
                "ngayDat": dateSelectBtn.titleLabel?.text!,
                "soKPAn": soKhauPhanAn.text!,
                "giaTD": giaDatTiecTxt.text!,
                "isApprove": "",
                ] as [String : Any]
            
            ref_DatTiec.childByAutoId().setValue(datTiec)
//            sendMail()
            
            let alert = UIAlertController(title: "Trạng thái đặt tiệc", message: "Bạn đã đặt tiệc thành công", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                let lichThucDonVC = self.storyboard?.instantiateViewController(withIdentifier: "lichthucdon") as? LichThucDonVC
                let revealVC = self.revealViewController()
                revealVC?.pushFrontViewController(UINavigationController(rootViewController: lichThucDonVC!), animated: true)
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
            print("Không thể gửi được")
        }
    }
    
    func configMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.setSubject("Yêu cầu đặt tiệc mới từ phụ huynh")
        mailComposerVC.setMessageBody("<b>Có yêu cầu mới từ phụ huynh của em \(selectTre[0].ten)</b>", isHTML: true)
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
    
    
}

extension DatTiecPHVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension DatTiecPHVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case childTableView:
            return listTre.count
        case foodBirthTableView:
            return listMASelected.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case childTableView:
            let cell = childTableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as? ChildCell
            DispatchQueue.global().async {
                let url = URL(string: self.listTre[indexPath.row].imageUrl)!
                let imageData = try! Data(contentsOf: url)
                let ten = self.listTre[indexPath.row].ten
                let ngaySinh = self.listTre[indexPath.row].ngaySinh
                let lop = self.listTre[indexPath.row].lop
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)!
                    cell?.configure(image: image, tenTre: ten, ngaySinh: ngaySinh!, lop: lop!)
                }
            }
            return cell!
        case foodBirthTableView:
            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "foodBirthCell")
            cell.selectionStyle = .none
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            let ten = listMASelected[indexPath.row].tenMA
            let gia = listMASelected[indexPath.row].gia
            cell.textLabel?.text = ten
            cell.detailTextLabel?.text = "Giá: \(numberFormatter.string(from: Int(gia) as! NSNumber)!)"
            return cell
        default:
            return UITableViewCell()
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case childTableView:
            if !listTre[indexPath.row].isSelect {
                selectTre.append(listTre[indexPath.row])
                childTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                listTre[indexPath.row].isSelect = true
                print(selectTre)
            } else {
                let index = selectTre.firstIndex { (tre) -> Bool in
                    tre.ten == listTre[indexPath.row].ten
                    }!
                selectTre.remove(at: index)
                childTableView.cellForRow(at: indexPath)?.accessoryType = .none
                listTre[indexPath.row].isSelect = false
                print(selectTre)
            }
        default:
            return
        }
    }
    
    
}
