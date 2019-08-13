//
//  PostheadTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class PostheadTableViewCell: UITableViewCell {

    @IBOutlet weak var authid: UILabel!
    @IBOutlet weak var posttitle: UILabel!
    @IBOutlet weak var authportrait: UIImageView!
    @IBOutlet weak var authnickname: UILabel!
    @IBOutlet weak var posttext: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var postpicture1: UIImageView!
    @IBOutlet weak var postpicture2: UIImageView!
    @IBOutlet weak var postpicture3: UIImageView!
    
    
    func setData(authid:String,posttitle:String,authportrait:String,authnickname:String,posttext:String,time:String,postpicture:String){
        self.authid.text = authid
        self.posttitle.text = posttitle
        do {
            let data = try Data(contentsOf: URL(string: authportrait)!)
            self.authportrait.image = UIImage(data: data)
            self.authportrait.contentMode = .scaleAspectFill
            //设置遮罩
            self.authportrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            self.authportrait.layer.cornerRadius = self.authportrait.frame.width/2
        }catch let err{
            print(err)
        }
        self.authnickname.text = authnickname
        self.posttext.text = posttext
        self.time.text = time
        do {
            let arraySubstrings: [Substring] = postpicture.split(separator: ",")
            let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
            for index in 0..<arrayStrings.count{
                print(arrayStrings[index])
            }
            switch arrayStrings.count {
            case 1:
                if arrayStrings[0] != ""{
                    let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                    self.postpicture1.image = UIImage(data: data1)
                    self.postpicture1.isHidden = false
                }
                break
            case 2:
                let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                self.postpicture1.image = UIImage(data: data1)
                self.postpicture1.isHidden = false
                let data2 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.postpicture2.image = UIImage(data: data2)
                self.postpicture2.isHidden = false
                break
            case 3:
                let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                self.postpicture1.image = UIImage(data: data1)
                self.postpicture1.isHidden = false
                let data2 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.postpicture2.image = UIImage(data: data2)
                self.postpicture2.isHidden = false
                let data3 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.postpicture3.image = UIImage(data: data3)
                self.postpicture3.isHidden = false
                 break
            default: break
            }
        }catch let err{
            print(err)
        }
    }
    
    
    
}
