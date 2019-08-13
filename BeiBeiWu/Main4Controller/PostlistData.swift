//
//  PostlistData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/13.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation

class PostlistData{
    var authid:String
    var authnickname:String
    var authportrait:String
    var followtext:String
    var followpicture:String
    var time:String
    
    init(authid:String,authnickname:String,authportrait:String,followtext:String,followpicture:String,time:String) {
        self.authid = authid
        self.authnickname = authnickname
        self.authportrait = authportrait
        self.followtext = followtext
        self.followpicture = followpicture
        self.time = time
    }
}
