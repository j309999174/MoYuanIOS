//
//  BlackListTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import SDWebImage

protocol BlackListTableViewCellDelegate {
    func delete(yourid:String)
}
class BlackListTableViewCell: UITableViewCell {

    var delegate: BlackListTableViewCellDelegate?
    @IBOutlet weak var portrait: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBAction func deleteItem(_ sender: Any) {
        delegate?.delete(yourid: id.text!)
    }
    @IBOutlet weak var attributes: UILabel!
    
    func setData(data: BlackListData){
        var attributesString = data.age! + " | " + data.gender!
        attributesString = attributesString + " | " + data.region!
        attributesString = attributesString + " | " + data.property!
        attributes.text = attributesString
        do {
            //let data = try Data(contentsOf: URL(string: data.portrait!)!)
            //portrait.image = UIImage(data: data)
            portrait.sd_setImage(with: URL(string: data.portrait!), placeholderImage: UIImage(named: "placeholder.png"))
            portrait.contentMode = .scaleAspectFill
            //设置遮罩
            portrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            portrait.layer.cornerRadius = portrait.frame.width/2
        }catch let err{
            print(err)
        }
        nickname.text = data.nickname
        id.text = data.id
    }
}
