//
//  LichNau.swift
//  childkit-client
//
//  Created by sang luc on 6/7/19.
//  Copyright © 2019 SANG. All rights reserved.
//

import Foundation

class LichNau {
//    let td_vote_1 = [
//        "ten": "Thực đơn 1",
//        "start_date": start_date,
//        "end_date": end_date,
//        "Thứ 2": [],
//        "Thứ 3": [],
//        "Thứ 4": [],
//        "Thứ 5": [],
//        "Thứ 6": [],
//        "vote_number": "",
//        "vote_status": "not vote",
//        "created_date": "\(today)",
//        "last_modified": ""
//        ] as [String : Any]
    
    var ten: String?
    var start_date: String
    var end_date: String
    var thu2: [String: [String]]?
    var thu3: [String: [String]]?
    var thu4: [String: [String]]?
    var thu5: [String: [String]]?
    var thu6: [String: [String]]?
    var vote_number: String
    var vote_status: String
    var created_date: String
    
    init(ten: String, start_date: String, end_date: String, thu2: [String: [String]]?, thu3: [String: [String]]?, thu4: [String: [String]]?, thu5: [String: [String]]?, thu6: [String: [String]]?, vote_number: String, vote_status: String, created_date: String) {
        self.ten = ten
        self.start_date = start_date
        self.end_date = end_date
        self.thu2 = thu2
        self.thu3 = thu3
        self.thu4 = thu4
        self.thu5 = thu5
        self.thu6 = thu6
        self.vote_number = vote_number
        self.vote_status = vote_status
        self.created_date = created_date
    }
}
