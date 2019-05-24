//
//  BorderButton.swift
//  childkit-client
//
//  Created by SANG on 5/23/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class CornerButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }

}
