//
//  LuntanTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class LuntanTableViewCell: UITableViewCell {

    @IBOutlet weak var postid: UILabel!
    @IBOutlet weak var plateid: UILabel!
    @IBOutlet weak var platename: UILabel!
    @IBOutlet weak var authid: UILabel!
    @IBOutlet weak var authportrait: UIImageView!
    @IBOutlet weak var authnickname: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var posttip: UILabel!
    @IBOutlet weak var posttitle: UILabel!
    @IBOutlet weak var posttext: UILabel!
    @IBOutlet weak var postpicture: UIImageView!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var like: UIButton!
    
    func setData(data:LuntanData){
        postid.text = data.id
        plateid.text = data.plateid
        platename.text = data.platename
        authid.text = data.authid
        do {
            let data = try Data(contentsOf: URL(string: data.authportrait)!)
            authportrait.image = UIImage(data: data)
            authportrait.contentMode = .scaleAspectFill
            //设置遮罩
            authportrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            authportrait.layer.cornerRadius = authportrait.frame.width/2
        }catch let err{
            print(err)
        }
        authnickname.text = data.authnickname
        time.text = data.time
        posttip.text = data.posttip
        posttitle.text = data.posttitle
        posttext.numberOfLines = 0
        posttext.text = data.posttext
        do {
            let arraySubstrings: [Substring] = data.postpicture.split(separator: ",")
            let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
            for index in 0..<arrayStrings.count{
                print(arrayStrings[index])
            }
            if arrayStrings[0] != ""{
                let data = try Data(contentsOf: URL(string: arrayStrings[0])!)
                postpicture.image = UIImage(data: data)
            }else{
                postpicture.isHidden = true
            }
        }catch let err{
            print(err)
        }
    }
}
