//
//  BorderView.swift
//  childkit-client
//
//  Created by SANG on 5/24/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import UIKit

class BorderView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
    }
}
