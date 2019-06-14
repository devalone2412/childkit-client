//
//  MenuDatTiecCellTableViewCell.swift
//  ChildKid
//
//  Created by SANG on 5/13/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import UIKit

class MenuDatTiecCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var proteinLbl: UILabel!
    @IBOutlet weak var lipitLbl: UILabel!
    @IBOutlet weak var gluxitLbl: UILabel!
    @IBOutlet weak var giaMA: UILabel!
    
    func configure(image: UIImage = UIImage(named: "mon-default")!, foodName: String, kcal: String, protein: String, lipit: String, gluxit: String, giaMA: String) {
        self.foodImage.image = image ?? UIImage(named: "mon-default")
        self.foodName.text = foodName
        self.kcalLbl.text = "\(kcal) Cal"
        self.proteinLbl.text = "Protein: \(protein) g"
        self.lipitLbl.text = "Lipit: \(lipit) g"
        self.gluxitLbl.text = "Gluxit: \(gluxit) g"
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.giaMA.text = "Giá: \(numberFormatter.string(from: Int(giaMA) as! NSNumber)!) VNĐ"
    }
    
}
