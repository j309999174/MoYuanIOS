//
//  LuntanData.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/11.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation

class LuntanData{
    var id:String
    var plateid:String
    var platename:String
    var authid: String
    var authnickname:String
    var authportrait:String
    var posttip:String?
    var posttitle:String?
    var posttext:String?
    var postpicture:String?
    var like:String?
    var favorite:String?
    var time:String?
    
    var age:String?
    var gender:String?
    var region:String?
    var property:String?
    
    init(id:String,plateid:String,platename:String,authid: String,authnickname:String,authportrait:String,posttip:String,posttitle:String,posttext:String,postpicture:String,like:String,favorite:String,time:String,age:String,gender:String,region:String,property:String) {
        self.id = id
        self.plateid = plateid
        self.platename = platename
        self.authid = authid
        self.authnickname = authnickname
        self.authportrait = authportrait
        self.posttip = posttip
        self.posttitle = posttitle
        self.posttext = posttext
        self.postpicture = postpicture
        self.like = like
        self.favorite = favorite
        self.time = time
        
        self.age = age
        self.gender = gender
        self.region = region
        self.property = property
        
    }
}
