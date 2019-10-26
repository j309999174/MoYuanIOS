//
//  BuyvipViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/17.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire



struct WeixinpayStruct:Codable {
    let appid:String?
    let mch_id:String?
    let nonce_str:String?
    let prepay_id:String?
    let sign:String?
    let timeStamp:Int32
}

struct BuyvipStruct:Codable {
    let id:String?
    let vipsort:String?
    let vipname:String?
    let viptime:String?
    let vipprice:String?
}

class BuyvipViewController: UIViewController {

    @IBOutlet weak var buyvipTableView: UITableView!
    
    
    var dataList:[BuyvipData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购买会员"
        
        
        
        initViplist()
        //支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(successnotify), name: NSNotification.Name(rawValue: "PaySuccessNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failnotify), name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
    }

    @objc func successnotify(){
        self.view.makeToast("支付成功")
    }
    @objc func failnotify(){
        self.view.makeToast("支付失败")
    }
    
    
    
    func initViplist(){

        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=getvip&m=socialchat", method: .post).response { response in
            if let data = response.data , let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([BuyvipStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = BuyvipData(vipid: jsonModel[index].id!, vipname: jsonModel[index].vipname!, viptime: jsonModel[index].viptime!, vipprice: jsonModel[index].vipprice!)
                        self.dataList.append(cell)
                    }
                    self.buyvipTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }


}


extension BuyvipViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyvipCell") as! BuyvipTableViewCell
        
        cell.setData(data: oneOfList)
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}


extension BuyvipViewController:BuyvipTableViewCellDelegate{
    func weixinpay(vipid: String) {
        print("weixinpay\(vipid)")
        //传递参数，生成订单，返回参数，调用支付
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["userid": userID!,"vipid":vipid]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=payunifiedorder&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(WeixinpayStruct.self, from: data)
                    //调用微信支付
                    //调起微信
                    let req = PayReq()
                    //应用的AppID(固定的)
                    req.openID = jsonModel.appid!
                    //商户号(固定的)
                    req.partnerId = jsonModel.mch_id!
                    //扩展字段(固定的)
                    req.package = "Sign=WXPay"
                    //统一下单返回的预支付交易会话ID
                    req.prepayId = jsonModel.prepay_id!
                    //随机字符串
                    req.nonceStr = jsonModel.nonce_str!
                    //时间戳(10位)
                    req.timeStamp = UInt32(jsonModel.timeStamp)
                    //签名
                    req.sign = jsonModel.sign!
                    WXApi.send(req)
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    func alipaypay(vipid: String) {
        print("alipay\(vipid)")
        //服务器获取orderstring，然后调用支付
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["userid": userID!,"vipid":vipid]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=alipayaddorder&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                AlipaySDK.defaultService()?.payOrder(utf8Text, fromScheme: "beibeiwualipay"){
                    result in
                }
            }
        }
    }
}
