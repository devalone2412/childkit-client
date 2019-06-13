//
//  ChildCell.swift
//  childkit-client
//
//  Created by sang luc on 5/25/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class ChildCell: UITableViewCell {
    
    @IBOutlet weak var imageKid: UIImageView!
    @IBOutlet weak var tenTre: UILabel!
    @IBOutlet weak var ngaySinh: UILabel!
    @IBOutlet weak var lop: UILabel!
    
    func configure(image: UIImage = UIImage(named: "user")!, tenTre: String, ngaySinh: String, lop: String) {
        imageKid.image = image
        self.tenTre.text = tenTre
        self.ngaySinh.text = "Ngày sinh: \(ngaySinh)"
        self.lop.text = "Lớp: \(lop)"
    }
    @IBAction func selectWasPressed(_ sender: UIButton) {
        if (sender.currentImage?.isEqual(UIImage(named: "unchecked")))! {
            sender.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
}
