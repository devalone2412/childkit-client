//
//  TemplateCell.swift
//  childkit-client
//
//  Created by sang luc on 7/6/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class TemplateCell: UITableViewCell {

    @IBOutlet weak var tenTemplate: UILabel!
    
    func configure(tenTemp: String!) {
        tenTemplate.text = tenTemp;
    }

}
