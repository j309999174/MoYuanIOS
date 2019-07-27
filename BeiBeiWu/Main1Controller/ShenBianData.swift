//
//  ShenBianData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/27.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
import UIKit
class ShenBianData{
    
    var userPortrait:String
    var userNickName: String
    var userAge: String
    var userGender: String
    var userProperty: String
    var userDistance: String
    var userRegion: String
    var userVIP: String
    
    init(userPortrait:String,userNickName:String,userAge: String,userGender: String,userProperty: String,userDistance: String,userRegion: String,userVIP: String) {
        self.userPortrait = userPortrait
        self.userNickName = userNickName
        self.userAge = userAge
        self.userGender = userGender
        self.userProperty = userProperty
        self.userDistance = userDistance
        self.userRegion = userRegion
        self.userVIP = userVIP
    }
}
