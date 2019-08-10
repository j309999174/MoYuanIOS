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
    var userNickName: String
    
    init(userID: String,userNickName:String,userPortrait:String) {
        self.userID = userID
        self.userNickName = userNickName
        self.userPortrait = userPortrait
    }
}
