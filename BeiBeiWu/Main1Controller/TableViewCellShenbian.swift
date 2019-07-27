//
//  TableViewCellShenbian.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/27.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class TableViewCellShenbian: UITableViewCell {
    @IBOutlet weak var userPortrait: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userProperty: UILabel!
    @IBOutlet weak var userDistance: UILabel!
    @IBOutlet weak var userRegion: UILabel!
    @IBOutlet weak var userVIP: UILabel!
    
    func setData(shenBianData: ShenBianData){
        do {
            let data = try Data(contentsOf: URL(string: shenBianData.userPortrait)!)
            userPortrait.image = UIImage(data: data)
            userPortrait.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait.layer.cornerRadius = userPortrait.frame.width/2
        }catch let err{
            print(err)
        }
        userNickName.text = shenBianData.userNickName
        userAge.text = shenBianData.userAge
        userGender.text = shenBianData.userGender
        userProperty.text = shenBianData.userProperty
        userDistance.text = shenBianData.userDistance
        userRegion.text = shenBianData.userRegion
        userVIP.text = shenBianData.userVIP
    }

}
