//
//  Tre.swift
//  childkit-client
//
//  Created by sang luc on 6/11/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class Tre {
    var maTre: String!
    var imageUrl: String!
    var lop: String!
    var ngaySinh: String!
    var ten: String
    var isSelect = false
    
    init(maTre: String, imageUrl: String, lop: String, ngaySinh: String, ten: String) {
        self.maTre = maTre
        self.imageUrl = imageUrl
        self.lop = lop
        self.ngaySinh = ngaySinh
        self.ten = ten
    }
}
