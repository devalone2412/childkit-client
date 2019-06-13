//
//  MonAnCell.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class MonAnCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var tenMonLbl: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var proteinLbl: UILabel!
    @IBOutlet weak var lipitLbl: UILabel!
    @IBOutlet weak var glucitLbl: UILabel!
    @IBOutlet weak var giaMA: UILabel!
    
    func configure(image: UIImage = UIImage(named: "food")!, tenMon: String, kCal: String, protein: String, lipit: String, glucit: String, giaMA: String) {
        self.foodImage.image = image
        self.tenMonLbl.text = tenMon
        self.kcalLbl.text = "\(kCal)Cal"
        self.proteinLbl.text = "Protein: \(protein)g"
        self.lipitLbl.text = "Lipit: \(lipit)g"
        self.glucitLbl.text = "Glucit: \(glucit)g"
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        self.giaMA.text = "Giá: \(numberFormatter.string(from: Int(giaMA) as! NSNumber)!) VNĐ"
    }
    
}
