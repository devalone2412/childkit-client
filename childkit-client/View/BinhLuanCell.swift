//
//  BinhLuanCell.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class BinhLuanCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tenPH: UILabel!
    @IBOutlet weak var binhLuan: UILabel!
    
    func configure(image: UIImage = UIImage(named: "user")!, tenPH: String, binhLuan: String) {
        self.userImage.image = image
        self.tenPH.text = tenPH
        self.binhLuan.text = binhLuan
    }
    

}
