
//
//  YeuCauCell.swift
//  ChildKid
//
//  Created by SANG on 5/12/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import UIKit

class YeuCauPHCell: UITableViewCell {
    
    @IBOutlet weak var anhTre: BorderImageView!
    @IBOutlet weak var tenPH: UILabel!
    @IBOutlet weak var tenTre: UILabel!
    @IBOutlet weak var ngayDat: UILabel!
    @IBOutlet weak var soKPAn: UILabel!
    
    func configure(anhTre: UIImage = UIImage(named: "user-default")!, tenPH: String, tenTre: [String], ngayDat: String, soKPAn: String) {
        self.anhTre.image = anhTre ?? UIImage(named: "user-default")
        self.tenPH.text = "Tên PH: \(tenPH)"
        var arrayTen = [String]()
        for name in tenTre {
            arrayTen.append(name)
        }
        self.tenTre.text = "Tên trẻ: \(arrayTen.joined(separator: ", "))"
        self.ngayDat.text = "Ngày đặt: \(ngayDat)"
        self.soKPAn.text = "SL: \(soKPAn) người"
    }
    
}
