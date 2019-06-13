//
//  NhanVien.swift
//  childkit-client
//
//  Created by sang luc on 6/12/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class NhanVien {
    var maNV: String!
    var hoTen: String!
    var lop: String!
    var phong: String!
    var photoUrl: String!
    
    init(maNV: String, hoTen: String, lop: String, phong: String, photoUrl: String) {
        self.maNV = maNV
        self.hoTen = hoTen
        self.lop = lop
        self.phong = phong
        self.photoUrl = photoUrl
    }
}
