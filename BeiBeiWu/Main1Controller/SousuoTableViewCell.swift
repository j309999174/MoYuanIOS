//
//  SousuoTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/30.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import SDWebImage

class SousuoTableViewCell: UITableViewCell {
    @IBOutlet weak var userPortrait: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userProperty: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userRegion: UILabel!
    @IBOutlet weak var userVIP: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    func setData(data: ShenBianData){
        do {
            //let data = try Data(contentsOf: URL(string: data.userPortrait)!)
            //userPortrait.image = UIImage(data: data)
            userPortrait.sd_setImage(with: URL(string: data.userPortrait), placeholderImage: UIImage(named: "placeholder.png"))
            userPortrait.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait.layer.cornerRadius = userPortrait.frame.width/2
        }catch let err{
            print(err)
        }
        userNickName.text = data.userNickName
        userAge.text = data.userAge
        userGender.text = data.userGender
        userProperty.text = data.userProperty
        userDistance.text = data.userDistance+"km"
        userRegion.text = data.userRegion
        userVIP.text = data.userVIP
        userID.text = data.userID
        if data.userGender == "男" {
            genderImage.image = UIImage(named: "male")
        }else{
            genderImage.image = UIImage(named: "female")
        }
        if data.userVIP == "普通" {
            vipImage.image = UIImage(named: "member")
        }else{
            vipImage.image = UIImage(named: "vip")
        }
    }
    

}
