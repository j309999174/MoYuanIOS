//
//  BuyvipViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/17.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import StoreKit



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
    
    var if_submit = 0
    
    var products = [SKProduct]()
    
    var request: SKProductsRequest!
    
    
    var dataList:[BuyvipData] = []
    
    var system_switch = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购买"
        
        
        //1.获取本地产品标识
        guard let url = Bundle.main.url(forResource: "product_ids", withExtension: "plist") else { fatalError("Unable to resolve url for in the bundle.") }
        do {
            let data = try Data(contentsOf: url)
            let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String]
            self.fetchProduct(productIdentifiers: productIdentifiers!)
           } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
        
        //isHiddenBuyVip()
        
        
        //支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(successnotify), name: NSNotification.Name(rawValue: "PaySuccessNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failnotify), name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
    }
    
    func fetchProduct(productIdentifiers: [String]) {
         let productIdentifiers = Set(productIdentifiers)
         request = SKProductsRequest(productIdentifiers: productIdentifiers)
         request.delegate = self
         request.start()
    }

    @objc func successnotify(){
        self.view.makeToast("支付成功")
    }
    @objc func failnotify(){
        self.view.makeToast("支付失败")
    }
    
    func isHiddenBuyVip() {
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=systemswitch&m=socialchat", method: .post).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "1" {
                    self.system_switch = "1"
                }
                self.initViplist()
            }
        }
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

extension BuyvipViewController:SKProductsRequestDelegate{
    
    // SKProductsRequestDelegate protocol method.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("获取的vip数量\(response.products.count)")
        if !response.products.isEmpty {
            var viptime = ""
        
           products = response.products
            for product in products {
                switch product.localizedTitle {
                case "钻石会员":
                    viptime = "30"
                    break
                case "黑金会员":
                    viptime = "180"
                    break
                case "白金会员":
                    viptime = "360"
                    break
                default:
                    break
                }
               // Handle any invalid product identifiers as appropriate.
                let cell = BuyvipData(vipid: product.productIdentifier, vipname: product.localizedTitle, viptime: viptime, vipprice: product.price.stringValue)
                self.dataList.append(cell)
                
            }
            
           // Custom method.
            DispatchQueue.main.async {
                print("main refresh")
                //self.producttableview.reloadData()
                self.buyvipTableView.reloadData()
            }
           
        }
        for invalidIdentifier in response.invalidProductIdentifiers {
           // Handle any invalid product identifiers as appropriate.
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
        
        cell.setData(data: oneOfList,system_switch: self.system_switch)
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("是否可点击\(if_submit)")
        if if_submit == 0 {
            let payment = SKMutablePayment(product: products[indexPath.row])
            payment.quantity = 1
            SKPaymentQueue.default().add(payment)
            
            if_submit = 1
        }
        
        var time = 3
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            
            time = time - 1
            
            if time == 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    self.if_submit = 0
                    print("计时完成\(self.if_submit)")
                }
                return
            }
            
        }
        codeTimer.activate()
        
//        let oneOfList = dataList[indexPath.row]
//        print("vip数量\(products.count)")
//
//        switch oneOfList.vipname {
//        case "钻石会员":
//            for index in 0...2 {
//                let product = products[index]
//                if product.productIdentifier == "vip6" {
//                    let payment = SKMutablePayment(product: product)
//                    payment.quantity = 1
//                    SKPaymentQueue.default().add(payment)
//                }
//            }
//        case "黑金会员":
//            for index in 0...2 {
//                let product = products[index]
//                if product.productIdentifier == "vip5" {
//                    let payment = SKMutablePayment(product: product)
//                    payment.quantity = 1
//                    SKPaymentQueue.default().add(payment)
//                }
//            }
//        case "白金会员":
//            for index in 0...2 {
//                let product = products[index]
//                if product.productIdentifier == "vip4" {
//                    let payment = SKMutablePayment(product: product)
//                    payment.quantity = 1
//                    SKPaymentQueue.default().add(payment)
//                }
//            }
//        default:
//            break
//        }
        
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
//                AlipaySDK.defaultService()?.payOrder(utf8Text, fromScheme: "beibeiwualipay"){
//                    result in
//                }
            }
        }
    }
}
