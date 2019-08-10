//
//  NewFriendData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
class NewFriendData {
    var userID: String
    var userPortrait:String
    var userNickName: String
    var userLeaveWords: String
    var agree: String
    
    init(userID: String,userNickName:String,userPortrait:String,userLeaveWords:String,agree:String) {
        self.userID = userID
        self.userNickName = userNickName
        self.userPortrait = userPortrait
        self.userLeaveWords = userLeaveWords
        self.agree = agree
    }
}
