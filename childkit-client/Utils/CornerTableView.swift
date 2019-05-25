//
//  CornerTableView.swift
//  childkit-client
//
//  Created by sang luc on 5/25/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class CornerTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }

}
