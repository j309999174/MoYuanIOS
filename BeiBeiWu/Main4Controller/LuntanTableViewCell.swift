//
//  LuntanTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import SDWebImage

protocol LuntanTableViewCellDelegate{
    func like(postid:String,likebtn:UIButton)
    func personpage(userID:String)
    func threepoints(postid:String,userID:String)
    func pictureClick(pictureurl:String)
    func detail_content(posttext:UILabel!,post_detail_text:String!,sender:UIButton)
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
    
    @IBOutlet weak var post_full_text: UITextView!
    
    @IBOutlet weak var posttip1: UIImageView!
    @IBOutlet weak var posttip2: UIImageView!
    @IBOutlet weak var attributes: UILabel!
    
    @IBOutlet weak var postpicture1: UIImageView!
    @IBOutlet weak var postpicture2: UIImageView!
    @IBOutlet weak var postpicture3: UIImageView!
    
    
    @IBAction func detail_content(_ sender: UIButton) {
        print("内部")
        sender.isHidden = true
        posttext.text = post_detail_text
        
        delegate?.detail_content(posttext: posttext,post_detail_text: post_detail_text,sender: sender)
    }
    @IBOutlet weak var detail_btn: UIButton!
    
    @IBAction func threePoints(_ sender: Any) {
        print("论坛的菜单")
        delegate?.threepoints(postid: postid.text!, userID: authid.text!)
    }
    

    @IBAction func like(_ sender: UIButton) {
        print("论坛的like")
        delegate?.like(postid: postid.text!,likebtn:sender)
    }
    
    var delegate:LuntanTableViewCellDelegate?
//    var data1:Data?
//    var data2:Data?
//    var data3:Data?
    var pictureurl1:String?
    var pictureurl2:String?
    var pictureurl3:String?
    var post_detail_text:String?
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
            //let data = try Data(contentsOf: URL(string: data.authportrait)!)
            //authportrait.image = UIImage(data: data)
            authportrait.sd_setImage(with: URL(string: data.authportrait), placeholderImage: UIImage(named: "placeholder.png"))
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
        
        posttext.lineBreakMode = NSLineBreakMode.byWordWrapping
        posttext.numberOfLines = 0
        post_detail_text = data.posttext
        //posttext.text = data.posttext
        detail_btn.isEnabled = false
        detail_btn.setTitleColor(UIColor?.init(UIColor.init(red: 0, green: 0, blue: 255, alpha: 1)), for: UIControl.State.normal)
        if data.posttext?.count ?? 0 == 56 {
            posttext.text = data.posttext
            //posttext.text = String((data.posttext?.prefix(50))!) + "......"
            detail_btn.isHidden = false
        }else{
            posttext.text = data.posttext
            detail_btn.isHidden = true
        }
        do {
            let arraySubstrings: [Substring] = (data.postpicture?.split(separator: ","))!
            let arrayStrings: [String] = arraySubstrings.compactMap { "\($0)" }
            for index in 0..<arrayStrings.count{
                print(arrayStrings[index])
            }
            if arrayStrings.count < 1{
                postpicture1.isHidden = true
            }else{
                postpicture1.isHidden = false
                //data1 = try Data(contentsOf: URL(string: arrayStrings[0])!)
                //postpicture1.image = UIImage(data: data1!)
                pictureurl1 = arrayStrings[0]
                postpicture1.sd_setImage(with: URL(string: arrayStrings[0]), placeholderImage: UIImage(named: "placeholder.png"))
                //图一点击
                let imgClick1 = UITapGestureRecognizer(target: self, action: #selector(imAction1))
                postpicture1.addGestureRecognizer(imgClick1)
                postpicture1.isUserInteractionEnabled = true
            }
            if arrayStrings.count < 2{
                postpicture2.isHidden = true
            }else{
                postpicture2.isHidden = false
                //data2 = try Data(contentsOf: URL(string: arrayStrings[1])!)
                //postpicture2.image = UIImage(data: data2!)
                pictureurl2 = arrayStrings[1]
                postpicture2.sd_setImage(with: URL(string: arrayStrings[1]), placeholderImage: UIImage(named: "placeholder.png"))
                //图一点击
                let imgClick2 = UITapGestureRecognizer(target: self, action: #selector(imAction2))
                postpicture2.addGestureRecognizer(imgClick2)
                postpicture2.isUserInteractionEnabled = true
            }
            if arrayStrings.count < 3{
                postpicture3.isHidden = true
            }else{
                postpicture3.isHidden = false
                //data3 = try Data(contentsOf: URL(string: arrayStrings[2])!)
                //postpicture3.image = UIImage(data: data3!)
                pictureurl3 = arrayStrings[2]
                postpicture3.sd_setImage(with: URL(string: arrayStrings[2]), placeholderImage: UIImage(named: "placeholder.png"))
                //图一点击
                let imgClick3 = UITapGestureRecognizer(target: self, action: #selector(imAction3))
                postpicture3.addGestureRecognizer(imgClick3)
                postpicture3.isUserInteractionEnabled = true
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
    //图一点击事件方法
    @objc func imAction1() -> Void {
        print("图片点击事件")
        delegate?.pictureClick(pictureurl: pictureurl1!)
    }
    //图二点击事件方法
    @objc func imAction2() -> Void {
        print("图片点击事件")
        delegate?.pictureClick(pictureurl: pictureurl2!)
    }
    //图三点击事件方法
    @objc func imAction3() -> Void {
        print("图片点击事件")
        delegate?.pictureClick(pictureurl: pictureurl3!)
    }
}


