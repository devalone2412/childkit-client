//
//  Category.swift
//  childkit-client
//
//  Created by sang luc on 6/7/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class Category {
    var imageURL: String!
    var maCategory: String!
    var tenCategory: String!
    var keyCategory: String!
    
    init(imageURL: String, maCategory: String, tenCategory: String, keyCategory: String) {
        self.imageURL = imageURL
        self.maCategory = maCategory
        self.tenCategory = tenCategory
        self.keyCategory = keyCategory
    }
}
