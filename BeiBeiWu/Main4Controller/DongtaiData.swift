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
    
    init(circleid:String,userID:String,userPortrait:String,userNickName: String,dongtaiWord:String,dongtaiPicture:String,dongtaiTime:String,dongtaiLike:String) {
        self.circleid = circleid
        self.userID = userID
        self.userPortrait = userPortrait
        self.userNickName = userNickName
        self.dongtaiWord = dongtaiWord
        self.dongtaiPicture = dongtaiPicture
        self.dongtaiTime = dongtaiTime
        self.dongtaiLike = dongtaiLike
        
    }
}
