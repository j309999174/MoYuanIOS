//
//  BuyvipData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/17.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation

class BuyvipData{
    var vipid:String
    var vipname:String
    var viptime:String
    var vipprice: String

    
    init(vipid:String,vipname:String,viptime:String,vipprice: String) {
        self.vipid = vipid
        self.vipname = vipname
        self.viptime = viptime
        self.vipprice = vipprice
    }
}
