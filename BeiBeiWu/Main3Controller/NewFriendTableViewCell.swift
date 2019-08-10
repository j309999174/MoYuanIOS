//
//  NewFriendTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

protocol NewFriendTableViewCellDelegate {
    func didAgree(yourid:String,yournickname:String,yourportrait:String,agreebtn:UIButton)
}


class NewFriendTableViewCell: UITableViewCell {


    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var userLeaveWords: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var userPortrait: UIImageView!
    
    var delegate: NewFriendTableViewCellDelegate?
    var yourid:String?
    var yournickname:String?
    var yourportrait:String?
    func setData(data: NewFriendData){
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
        userLeaveWords.text = data.userLeaveWords
        data.agree == "1" ? agreeBtn.setTitle("已同意", for: UIControl.State.normal)  : agreeBtn.setTitle("同意", for: UIControl.State.normal)
        
        
        yourid = data.userID
        yournickname = data.userNickName
        yourportrait = data.userPortrait
    }
    @IBAction func agreeBtn(_ sender: Any) {
        print("同意按钮")
        if agreeBtn.title(for: UIControl.State.normal) == "同意"{
            delegate?.didAgree(yourid: yourid!, yournickname: yournickname!, yourportrait: yourportrait!,agreebtn: agreeBtn)
      }
    }
}
