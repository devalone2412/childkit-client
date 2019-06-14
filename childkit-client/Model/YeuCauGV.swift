//
//  YeuCauGV.swift
//  ChildKid
//
//  Created by sang luc on 6/13/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import Foundation

class YeuCauGV {
    var maYC: String!
    var imageUrl: String!
    var monAn: [MonAn]!
    var description: String!
    var giaTD: String!
    var isApprove: String!
    var ngayDat: String!
    var tenGV: String!
    var soKPAn: String!
    
    init(maYC: String, imageUrl: String, monAn: [MonAn], description: String, giaTD: String, isApprove: String, ngayDat: String, tenGV: String, soKPAn: String) {
        self.maYC = maYC
        self.imageUrl = imageUrl
        self.monAn = monAn
        self.description = description
        self.giaTD = giaTD
        self.isApprove = isApprove
        self.ngayDat = ngayDat
        self.tenGV = tenGV
        self.soKPAn = soKPAn
    }
    
}
