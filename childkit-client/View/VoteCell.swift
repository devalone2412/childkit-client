//
//  VoteCell.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var tenMonLbl: UILabel!
    @IBOutlet weak var kcalLbl: UILabel!
    @IBOutlet weak var proteinLbl: UILabel!
    @IBOutlet weak var lipitLbl: UILabel!
    @IBOutlet weak var glucitLbl: UILabel!
    
    func configure(image: UIImage = UIImage(named: "food")!, tenMon: String, kCal: String, protein: String, lipit: String, glucit: String) {
        self.foodImage.image = image
        self.tenMonLbl.text = tenMon
        self.kcalLbl.text = "\(kCal)Cal"
        self.proteinLbl.text = "Protein: \(protein)g"
        self.lipitLbl.text = "Lipit: \(lipit)g"
        self.glucitLbl.text = "Glucit: \(glucit)g"
    }
}
