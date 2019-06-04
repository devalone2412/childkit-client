//
//  CategoryCell.swift
//  childkit-client
//
//  Created by sang luc on 5/26/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    func configure(image: UIImage = UIImage(named: "food")!, name: String) {
        categoryImage.image = image
        categoryName.text = name
    }

}
