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
    
    
    @IBAction func weixinpay(_ sender: Any) {
        delegate?.weixinpay(vipid: vipidString!)
    }
    
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
    }
}
