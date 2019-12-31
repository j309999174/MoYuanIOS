//
//  BasicsCell.swift
//  CollectionView-Note
//
//  Created by zuber on 2018/11/19.
//  Copyright © 2018年 zuber. All rights reserved.
//

import UIKit

import Alamofire
import PopupDialog

class BasicsCell: UICollectionViewCell {
  static let reuseID = "basicsCell"

    
    @IBOutlet weak var userPortrait: UIImageView!{
        didSet{
            userPortrait.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait.layer.cornerRadius = userPortrait.frame.width/2
        }
    }
    
    @IBOutlet weak var destinyNumber: UILabel!
    
    @IBOutlet weak var userNickName: UILabel!
    
    @IBOutlet weak var userProperty: UILabel!
    
    @IBOutlet weak var userRegion: UILabel!
    
    @IBOutlet weak var userGender: UILabel!
    
    @IBOutlet weak var userAge: UILabel!
    
    @IBOutlet weak var userSignature: UILabel!
    
    

    
    
    func setData(data:DestinyUserInfo){
        self.destinyNumber.text = "缘分值：\(arc4random() % (100 - 60) + 60)"
        self.userNickName.text = data.userNickName
        self.userPortrait.sd_setImage(with: URL(string: data.userPortrait), placeholderImage: UIImage(named: "placeholder.png"))
        self.userRegion.text = data.userRegion
        self.userGender.text = data.userGender
        self.userAge.text = data.userAge
        self.userSignature.text = data.userSignature
        self.userProperty.text = data.userProperty

    }
    
   
    
    
}
