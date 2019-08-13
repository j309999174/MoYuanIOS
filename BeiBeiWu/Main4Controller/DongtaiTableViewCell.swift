//
//  DongtaiTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

protocol DongtaiTableViewCellDelegate{
    func like(circleid:String,likebtn:UIButton)
}

class DongtaiTableViewCell: UITableViewCell {
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userPortrait: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var dongtaiWord: UILabel!
    @IBOutlet weak var dongtaiPicture: UIImageView!
    @IBOutlet weak var dongtaiTime: UILabel!

    @IBOutlet weak var dongtaiLike: UIButton!
    @IBAction func dongtaiLike(_ sender: UIButton) {
        delegate?.like(circleid: circleid!,likebtn: dongtaiLike)
    }
    
    var circleid:String?
    
    var delegate:DongtaiTableViewCellDelegate?
    
    func setData(data:DongtaiData){
        circleid = data.circleid
        do {
            let data = try Data(contentsOf: URL(string: data.userPortrait)!)
            userPortrait.image = UIImage(data: data)
            userPortrait.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait.layer.cornerRadius = userPortrait.frame.width/2
        }catch let err{
            print(err)
        }
        userNickName.text = data.userNickName
        userID.text = data.userID
        
        
        
        dongtaiWord.text = data.dongtaiWord
        dongtaiWord.numberOfLines = 0
        do {
            let data = try Data(contentsOf: URL(string: data.dongtaiPicture)!)
            dongtaiPicture.image = UIImage(data: data)
        }catch let err{
            print(err)
        }
        dongtaiTime.text = data.dongtaiTime
        dongtaiLike.setTitle("赞:\(data.dongtaiLike)", for: UIControl.State.normal)
    }
    
    
    
}
