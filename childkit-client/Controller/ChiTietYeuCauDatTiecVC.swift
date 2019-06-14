//
//  ChiTietYeuCauDatTiecVC.swift
//  ChildKid
//
//  Created by SANG on 5/13/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import UIKit

class ChiTietYeuCauDatTiecVC: UIViewController {
    
    @IBOutlet weak var menuDatTiecTableView: UITableView!
    @IBOutlet weak var titleTiec: UILabel!
    @IBOutlet weak var avatarImg: BorderImageView!
    @IBOutlet weak var tenNguoiDat: UILabel!
    @IBOutlet weak var moTa: UILabel!
    @IBOutlet weak var ngayDat: UILabel!
    @IBOutlet weak var giaTD: UILabel!
    @IBOutlet weak var soKPAn: UILabel!
    
    var index: Int!
    var ycDTPH: YeuCauPH!
    var ycDTGV: YeuCauGV!
    var listMA = [MonAn]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuDatTiecTableView.delegate = self
        menuDatTiecTableView.dataSource = self
        menuDatTiecTableView.showsVerticalScrollIndicator = false
        
        title = "Chi tiết đặc tiệc"
        
        showDetailDataDT()
    }
    
    func showDetailDataDT() {
        listMA.removeAll()
        
        switch index {
        case 0:
            DispatchQueue.global().async {
                let url = URL(string: self.ycDTPH!.imageUrl[0])!
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.titleTiec.text = "Tiệc sinh nhật"
                    self.tenNguoiDat.text = "Tên phụ huynh: \(self.ycDTPH.tenPH!)"
                    self.moTa.text = "Tên trẻ: \(self.ycDTPH.tenTre.joined(separator: ","))"
                    self.ngayDat.text = "Ngày đặt: \(self.ycDTPH.ngayDat!)"
                    self.giaTD.text = "Tổng cộng: \(self.ycDTPH.giaTD!)"
                    self.soKPAn.text = "SL: \(self.ycDTPH.soKPAn!) người"
                    self.avatarImg.image = UIImage(data: imageData)
                }
            }
            
            listMA = ycDTPH.monAn
            menuDatTiecTableView.reloadData()
        case 1:
            DispatchQueue.global().async {
                let url = URL(string: self.ycDTGV.imageUrl)!
                let imageData = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.titleTiec.text = "Tiệc liên hoan"
                    self.tenNguoiDat.text = "Tên giáo viên: \(self.ycDTGV.tenGV!)"
                    self.moTa.text = "Mô tả: \(self.ycDTGV.description!)"
                    self.ngayDat.text = "Ngày đặt: \(self.ycDTGV.ngayDat!)"
                    self.giaTD.text = "Tổng cộng: \(self.ycDTGV.giaTD!)"
                    self.soKPAn.text = "SL: \(self.ycDTGV.soKPAn!) người"
                    self.avatarImg.image = UIImage(data: imageData)
                }
            }
            
            listMA = ycDTGV.monAn
            menuDatTiecTableView.reloadData()
        default:
            menuDatTiecTableView.reloadData()
        }
    }
    
}

extension ChiTietYeuCauDatTiecVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuDatTiecTableView.dequeueReusableCell(withIdentifier: "menuDatTiecCell", for: indexPath) as! MenuDatTiecCell
        
        if index == 0 {
            DispatchQueue.global().async {
                let url = URL(string: self.listMA[indexPath.row].imageURL)!
                let imageData = try! Data(contentsOf: url)
                let tenMA = self.listMA[indexPath.row].tenMA
                let kCal = self.listMA[indexPath.row].kCal
                let p = self.listMA[indexPath.row].p
                let l = self.listMA[indexPath.row].l
                let g = self.listMA[indexPath.row].g
                let giaMA = self.listMA[indexPath.row].gia
                
                DispatchQueue.main.async {
                    let imageMA = UIImage(data: imageData)
                    cell.configure(image: imageMA!, foodName: tenMA, kcal: kCal!, protein: p!, lipit: l!, gluxit: g!, giaMA: giaMA)
                }
            }
        } else {
            let url = URL(string: self.listMA[indexPath.row].imageURL)!
            let imageData = try! Data(contentsOf: url)
            let tenMA = self.listMA[indexPath.row].tenMA
            let kCal = self.listMA[indexPath.row].kCal
            let p = self.listMA[indexPath.row].p
            let l = self.listMA[indexPath.row].l
            let g = self.listMA[indexPath.row].g
            let giaMA = self.listMA[indexPath.row].gia
            
            DispatchQueue.main.async {
                let imageMA = UIImage(data: imageData)
                cell.configure(image: imageMA!, foodName: tenMA, kcal: kCal!, protein: p!, lipit: l!, gluxit: g!, giaMA: giaMA)
            }
        }
        
        return cell 
    }
    
    
}
