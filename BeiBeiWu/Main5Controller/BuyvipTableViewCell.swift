//
//  BuyvipTableViewCell.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/17.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

protocol BuyvipTableViewCellDelegate{
    func weixinpay(vipid:String)
    func alipaypay(vipid:String)
}

class BuyvipTableViewCell: UITableViewCell {

    @IBOutlet weak var vipid: UILabel!
    
    @IBOutlet weak var vipname: UILabel!
    
    
    @IBOutlet weak var viptime: UILabel!
    
    
    @IBOutlet weak var vipprice: UILabel!
    
    @IBOutlet weak var weixin_image: UIImageView!
    @IBOutlet weak var weixin_btn: UIButton!
    
    @IBAction func weixinpay(_ sender: Any) {
        delegate?.weixinpay(vipid: vipidString!)
    }
    
    @IBOutlet weak var alipay_image: UIImageView!
    
    @IBAction func alipay(_ sender: Any) {
        delegate?.alipaypay(vipid: vipidString!)
    }
    
    var delegate:BuyvipTableViewCellDelegate?
    
    var vipidString:String?
    func setData(data:BuyvipData){
        vipidString = data.vipid
        vipid.text = data.vipid
        vipname.text = data.vipname
        viptime.text = "\(data.viptime)天"
        vipprice.text = "\(data.vipprice)元"
        
        if WXApi.isWXAppInstalled(){
            weixin_image.isHidden = false
            weixin_btn.isHidden = false
        }else{
            weixin_image.isHidden = true
            weixin_btn.isHidden = true
        }
        
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(weixin_image_Action))
        weixin_image.addGestureRecognizer(imgClick)
        //开启 isUserInteractionEnabled 手势否则点击事件会没有反应
        weixin_image.isUserInteractionEnabled = true
        
        
        let imgClick1 = UITapGestureRecognizer(target: self, action: #selector(alipay_image_Action))
        alipay_image.addGestureRecognizer(imgClick1)
        //开启 isUserInteractionEnabled 手势否则点击事件会没有反应
        alipay_image.isUserInteractionEnabled = true
    }
    
    

    
    //点击事件方法
    @objc func weixin_image_Action() -> Void {
        print("图片点击事件")
        delegate?.weixinpay(vipid: vipidString!)
    }
    
    
    //点击事件方法
    @objc func alipay_image_Action() -> Void {
        print("图片点击事件")
        delegate?.alipaypay(vipid: vipidString!)
    }
}
