//
//  BinhLuan.swift
//  childkit-client
//
//  Created by sang luc on 6/10/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation
class BinhLuan {
    var imagePHURL: String!
    var tenPH: String!
    var noiDung: String!
    var like_number: String!
    var maComment: String!
    
    init(imagePHURL: String, tenPH: String, noiDung: String, like_number: String, maComment: String) {
        self.imagePHURL = imagePHURL
        self.tenPH = tenPH
        self.noiDung = noiDung
        self.like_number = like_number
        self.maComment = maComment
    }
}
