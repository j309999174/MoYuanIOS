//
//  PostlistTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class PostlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authid: UILabel!
    @IBOutlet weak var authportrait: UIImageView!
    @IBOutlet weak var authnickname: UILabel!
    @IBOutlet weak var louceng: UILabel!
    @IBOutlet weak var followtext: UILabel!
    @IBOutlet weak var followpicture1: UIImageView!
    @IBOutlet weak var followpicture2: UIImageView!
    @IBOutlet weak var followpicture3: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    func setData(data:PostlistData,louceng:Int){
        self.authid.text = data.authid
        do {
            let data = try Data(contentsOf: URL(string: data.authportrait)!)
            self.authportrait.image = UIImage(data: data)
            self.authportrait.contentMode = .scaleAspectFill
            //设置遮罩
            self.authportrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            self.authportrait.layer.cornerRadius = self.authportrait.frame.width/2
        }catch let err{
            print(err)
        }
        self.authnickname.text = data.authnickname
        self.louceng.text = "\(louceng)楼"
        self.followtext.text = data.followtext
        do {
            let arraySubstrings: [Substring] = data.followpicture.split(separator: ",")
            let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
            for index in 0..<arrayStrings.count{
                print(arrayStrings[index])
            }
            switch arrayStrings.count {
            case 1:
                if arrayStrings[0] != ""{
                    let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                    self.followpicture1.image = UIImage(data: data1)
                    self.followpicture1.isHidden = false
                }
                break
            case 2:
                let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                self.followpicture1.image = UIImage(data: data1)
                self.followpicture1.isHidden = false
                let data2 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.followpicture2.image = UIImage(data: data2)
                self.followpicture2.isHidden = false
                break
            case 3:
                let data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                self.followpicture1.image = UIImage(data: data1)
                self.followpicture1.isHidden = false
                let data2 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.followpicture2.image = UIImage(data: data2)
                self.followpicture2.isHidden = false
                let data3 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                self.followpicture3.image = UIImage(data: data3)
                self.followpicture3.isHidden = false
                break
            default: break
            }
        }catch let err{
            print(err)
        }
        self.time.text = data.time
    }
}
