//
//  File.swift
//  childkit-client
//
//  Created by sang luc on 6/21/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class NguyenLieu {
    var key: String!
    var maNL: String!
    var tenNL: String!
    var imageURL: String!
    var gia: String!
    var donVi1: String!
    var donVi2: String!
    
    init(key: String, maNL: String, tenNL: String, imageURL: String, gia: String, donVi1: String, donVi2: String) {
        self.key = key
        self.maNL = maNL
        self.tenNL = tenNL
        self.imageURL = imageURL
        self.gia = gia
        self.donVi1 = donVi1
        self.donVi2 = donVi2
    }
}
