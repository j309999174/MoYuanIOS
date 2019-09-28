//
//  FriendsTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/8.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import SDWebImage

protocol FriendsTableViewCellDelegate{
    func personpage(userID:String)
}
class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var userPortrait_img: UIImageView!
    
    @IBOutlet weak var userID_label: UILabel!
    @IBOutlet weak var userNickName_label: UILabel!
    
    @IBAction func personpage(_ sender: Any) {
        delegate?.personpage(userID: userID_label.text!)
    }
    var delegate:FriendsTableViewCellDelegate?
    @IBOutlet weak var attributes: UILabel!
    func setData(data: FriendsData){
        var attributesString = data.age! + " | " + data.gender!
        attributesString = attributesString + " | " + data.region!
        attributesString = attributesString + " | " + data.property!
        attributes.text = attributesString
        do {
            //let data = try Data(contentsOf: URL(string: data.userPortrait)!)
            //userPortrait_img.image = UIImage(data: data)
            userPortrait_img.sd_setImage(with: URL(string: data.userPortrait), placeholderImage: UIImage(named: "placeholder.png"))
            userPortrait_img.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait_img.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait_img.layer.cornerRadius = userPortrait_img.frame.width/2
        }catch let err{
            print(err)
        }
        userNickName_label.text = data.userNickName
        userID_label.text = data.userID
    }
}
