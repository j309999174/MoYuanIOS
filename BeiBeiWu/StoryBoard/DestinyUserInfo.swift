//
//  DestinyUserInfo.swift
//  BeiBeiWu
//
//  Created by 江东 on 2020/1/1.
//  Copyright © 2020 江东. All rights reserved.
//

import Foundation
import UIKit
class DestinyUserInfo{
    
    var userID: String
    var userPortrait:String
    var userNickName: String
    var userAge: String
    var userGender: String
    var userProperty: String
    var userRegion: String
    var userSignature: String
    
    init(userID: String,userPortrait:String,userNickName:String,userAge: String,userGender: String,userProperty: String,userRegion: String,userSignature: String) {
        self.userID = userID
        self.userPortrait = userPortrait
        self.userNickName = userNickName
        self.userAge = userAge
        self.userGender = userGender
        self.userProperty = userProperty
        self.userRegion = userRegion
        self.userSignature = userSignature
        
    }
}
