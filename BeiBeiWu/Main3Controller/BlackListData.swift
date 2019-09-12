//
//  BlackListData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
class BlackListData {
    var id: String?
    var nickname:String?
    var portrait: String?
    var age: String?
    var gender: String?
    var region: String?
    var property: String?
    
    
    init(id: String,nickname:String,portrait:String,age:String,gender:String,region:String,property:String) {
        self.id = id
        self.nickname = nickname
        self.portrait = portrait
        self.age = age
        self.gender = gender
        self.region = gender
        self.property = gender
    }
}
