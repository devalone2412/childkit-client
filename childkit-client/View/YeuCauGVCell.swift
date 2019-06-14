//
//  YeuCauGVCell.swift
//  ChildKid
//
//  Created by sang luc on 6/13/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import UIKit

class YeuCauGVCell: UITableViewCell {

    @IBOutlet weak var anhGV: BorderImageView!
    @IBOutlet weak var tenGV: UILabel!
    @IBOutlet weak var moTa: UILabel!
    @IBOutlet weak var ngayDat: UILabel!
    @IBOutlet weak var soKPAn: UILabel!
    
    func configure(image: UIImage, tenGV: String, moTa: String, ngayDat: String, soKPAn: String) {
        self.anhGV.image = image ?? UIImage(named: "user-default")
        self.tenGV.text = "Tên giáo viên: \(tenGV)"
        self.moTa.text = "Mô tả: \(moTa)"
        self.ngayDat.text = "Ngày đặt: \(ngayDat)"
        self.soKPAn.text = "SL: \(soKPAn) người"
    }

}
