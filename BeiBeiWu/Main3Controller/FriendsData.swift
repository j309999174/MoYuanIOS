//
//  FriendsData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/8.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
class FriendsData {
    var userID: String
    var userPortrait:String
    @objc var userNickName: String
    
    var age:String?
    var gender:String?
    var region:String?
    var property:String?
    
    var vip:String?
    
    init(userID: String,userNickName:String,userPortrait:String,age:String,gender:String,region:String,property:String,vip:String) {
        self.userID = userID
        self.userNickName = userNickName
        self.userPortrait = userPortrait
        
        self.age = age
        self.gender = gender
        self.region = region
        self.property = property
        
        self.vip = vip
    }
}
