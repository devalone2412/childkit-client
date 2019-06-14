//
//  YeuCauPH.swift
//  ChildKid
//
//  Created by sang luc on 6/13/19.
//  Copyright © 2019 Luc Thoi Sang. All rights reserved.
//

import Foundation

class YeuCauPH {
    var maYC: String!
    var imageUrl: [String]
    var monAn: [MonAn]!
    var tenTre: [String]!
    var giaTD: String!
    var tenPH: String!
    var soKPAn: String!
    var ngayDat: String!
    var isApprove: String!
    
    init(maYC: String, imageUrl: [String] ,monAn: [MonAn], tenTre: [String], giaTD: String, tenPH: String, soKPAn: String, ngayDat: String, isApprove: String) {
        self.maYC = maYC
        self.imageUrl = imageUrl
        self.monAn = monAn
        self.tenTre = tenTre
        self.giaTD = giaTD
        self.tenPH = tenPH
        self.soKPAn = soKPAn
        self.ngayDat = ngayDat
        self.isApprove = isApprove
    }
}
