//
//  LuntanTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

protocol LuntanTableViewCellDelegate{
    func like(postid:String,likebtn:UIButton)
    func personpage(userID:String)
    func threepoints(postid:String,userID:String)
}
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
    
    
    @IBOutlet weak var posttip1: UIImageView!
    @IBOutlet weak var posttip2: UIImageView!
    @IBOutlet weak var attributes: UILabel!
    
    @IBAction func threePoints(_ sender: Any) {
        print("论坛的菜单")
        delegate?.threepoints(postid: postid.text!, userID: authid.text!)
    }
    

    @IBAction func like(_ sender: UIButton) {
        print("论坛的like")
        delegate?.like(postid: postid.text!,likebtn:sender)
    }
    
    var delegate:LuntanTableViewCellDelegate?
    func setData(data:LuntanData){
        var attributesString = data.age! + " | " + data.gender!
        attributesString = attributesString + " | " + data.region!
        attributesString = attributesString + " | " + data.property!
        attributes.text = attributesString
        
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
        if data.posttip == "置顶" {
            posttip1.image = UIImage(named: "ontop")
        }else if data.posttip == "加精"{
            posttip1.image = UIImage(named: "essence")
        }else if data.posttip == "置顶,加精"{
            posttip1.image = UIImage(named: "ontop")
            posttip2.image = UIImage(named: "essence")
        }else{
            posttip1.image = UIImage(named: "")
            posttip2.image = UIImage(named: "")
        }
        posttitle.text = data.posttitle
        posttext.numberOfLines = 0
        posttext.text = data.posttext
        do {
            let arraySubstrings: [Substring] = (data.postpicture?.split(separator: ","))!
            let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
            for index in 0..<arrayStrings.count{
                print(arrayStrings[index])
            }
            if arrayStrings.count > 0{
                let data = try Data(contentsOf: URL(string: arrayStrings[0])!)
                postpicture.image = UIImage(data: data)
            }else{
                postpicture.isHidden = true
            }
        }catch let err{
            print(err)
        }
        
        like.setTitle("赞:\(data.like ?? "0")", for: UIControl.State.normal)
        //头像点击
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imAction))
        authportrait.addGestureRecognizer(imgClick)
        authportrait.isUserInteractionEnabled = true
    }
    
    //点击事件方法
    @objc func imAction() -> Void {
        print("图片点击事件")
        delegate?.personpage(userID: authid.text!)
    }
}


