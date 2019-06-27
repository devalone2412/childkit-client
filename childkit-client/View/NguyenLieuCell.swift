//
//  NguyenLieuCell.swift
//  childkit-client
//
//  Created by sang luc on 6/21/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class NguyenLieuCell: UITableViewCell {
    
    
    @IBOutlet weak var anhNL: UIImageView!
    @IBOutlet weak var tenNL: UILabel!
    @IBOutlet weak var gia: UILabel!
    
    func configure(image: UIImage, tenNL: String, gia: String, donVi1: String, donVi2: String) {
        self.anhNL.image = image
        self.tenNL.text = "Tên nguyên liệu: \(tenNL)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.gia.text = "Giá: \(numberFormatter.string(from: Int(gia) as! NSNumber)!) VNĐ / \(donVi1) \(donVi2)"
    }
    
}
