//
//  MonAn.swift
//  childkit-client
//
//  Created by sang luc on 6/7/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class MonAn {
    var g: String!
    var kCal: String!
    var l: String!
    var p: String!
    var imageURL: String!
    var maCategory: String!
    var maMA: String!
    var nguyenLieu: [[String: String]]!
    var tenMA: String
    var isChecked: Bool
    var gia = ""
    
    init(g: String, kCal: String, l: String, p: String, imageURL: String, maCategory: String, maMA: String, nguyenLieu: [[String: String]], tenMA: String, isChecked: Bool) {
        self.g = g;
        self.kCal = kCal
        self.l = l
        self.p = p
        self.imageURL = imageURL
        self.maCategory = maCategory
        self.maMA = maMA
        self.nguyenLieu = nguyenLieu
        self.tenMA = tenMA
        self.isChecked = isChecked
    }
}
