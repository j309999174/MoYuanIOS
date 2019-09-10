//
//  DongtaiData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation


class DongtaiData{
    var circleid:String
    var userID:String
    var userPortrait:String
    var userNickName: String
    var dongtaiWord:String
    var dongtaiPicture:String
    var dongtaiTime:String
    var dongtaiLike:String
    
    var age:String?
    var gender:String?
    var region:String?
    var property:String?
    
    init(circleid:String,userID:String,userPortrait:String,userNickName: String,dongtaiWord:String,dongtaiPicture:String,dongtaiTime:String,dongtaiLike:String,age:String,gender:String,region:String,property:String) {
        self.circleid = circleid
        self.userID = userID
        self.userPortrait = userPortrait
        self.userNickName = userNickName
        self.dongtaiWord = dongtaiWord
        self.dongtaiPicture = dongtaiPicture
        self.dongtaiTime = dongtaiTime
        self.dongtaiLike = dongtaiLike
        
        self.age = age
        self.gender = gender
        self.region = region
        self.property = property
    }
}
