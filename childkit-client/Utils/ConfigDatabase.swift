//
//  ConfigDatabase.swift
//  childkit-client
//
//  Created by sang luc on 6/4/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation
import FirebaseDatabase

let defaults = UserDefaults.standard
let defaultCategoryImage = "https://firebasestorage.googleapis.com/v0/b/childkit-1c357.appspot.com/o/64232477_2481698381881243_8248197723728117760_n.png?alt=media&token=e46929f9-1673-4474-9d37-c0d7d62e86dd"

let ref = Database.database().reference()
let ref_NV = ref.child("Nhân viên")
let ref_PH = ref.child("Phụ huynh")
let ref_MA_T = ref.child("Món ăn").child("Món thường")
let ref_MA_DT = ref.child("Món ăn").child("Món đặt tiệc")
let ref_Category = ref.child("Cateogry")
let ref_TD_Vote = ref.child("Thực đơn vote")
let ref_TD = ref.child("Bảng thực đơn")
let ref_comment = ref.child("Bình luận")
let ref_Tre = ref.child("Trẻ")
let ref_DatTiec = ref.child("Đặt tiệc").child("Phụ huynh")
let ref_DatTiec_GV = ref.child("Đặt tiệc").child("Giáo viên")
let ref_MA = ref.child("Món ăn")
let ref_NL = ref.child("Nguyên liệu")
