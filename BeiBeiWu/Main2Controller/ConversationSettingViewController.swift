//
//  ConversationSettingViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/28.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
struct PersonUserInfo: Codable {
    let id: String?
    let portrait: String?
    let nickname: String?
    let age: String?
    let gender: String?
    let property: String?
    let region: String?
    let vip: String?
    let latitude:String?
    let longitude:String?
    let location: String?
}
class ConversationSettingViewController: UIViewController{

    var myid:String?
    
    @IBOutlet weak var user_portrait: UIImageView!
    
    @IBOutlet weak var user_nickname: UILabel!
    
    @IBOutlet weak var iftop: UISwitch!
    
    @IBAction func iftop_switch(_ sender: UISwitch) {
        if sender.isOn {
            RCIMClient.shared()?.setConversationToTop(RCConversationType.ConversationType_PRIVATE, targetId: userid, isTop: true)
            self.view.makeToast("已开启置顶")
        }else{
            RCIMClient.shared()?.setConversationToTop(RCConversationType.ConversationType_PRIVATE, targetId: userid, isTop: false)
            self.view.makeToast("已关闭置顶")
        }
    }
    
    @IBOutlet weak var ifshield: UISwitch!
    
    @IBAction func ifshield_switch(_ sender: UISwitch) {
        if sender.isOn {
            RCIMClient.shared()?.setConversationNotificationStatus(RCConversationType.ConversationType_PRIVATE, targetId: userid, isBlocked: true, success: { (RCConversationNotificationStatus) in
                print("已开启免打扰\(RCConversationNotificationStatus.rawValue)")
            }, error: { (RCErrorCode) in
                print("已开启免打扰错误\(RCErrorCode)")
            })
            self.view.makeToast("已开启免打扰")
        }else{
            RCIMClient.shared()?.setConversationNotificationStatus(RCConversationType.ConversationType_PRIVATE, targetId: userid, isBlocked: false, success: { (RCConversationNotificationStatus) in
                print("已关闭打扰\(RCConversationNotificationStatus.rawValue)")
            }, error: { (RCErrorCode) in
                print("已关闭免打扰错误\(RCErrorCode)")
            })
            self.view.makeToast("已关闭免打扰")
        }
    }
    
    @IBAction func clearmessage(_ sender: Any) {
        RCIMClient.shared()?.clearHistoryMessages(RCConversationType.ConversationType_PRIVATE, targetId: userid, recordTime: 0, clearRemote: true, success: {
            
        }, error: { (RCErrorCode) in
            
        })
        self.view.makeToast("已删除聊天记录")
    }
    
    @IBAction func addblacklist(_ sender: Any) {
        let parameters: Parameters = ["myid":myid!,"yourid":userid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("拉黑成功")
            }
        }
    }
    
    @IBAction func deletefriend(_ sender: Any) {
        let parameters: Parameters = ["myid":myid!,"yourid":userid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=deletefriend&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("删除成功")
            }
        }
    }
    
    var userid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ifshield.isOn = false
        
        
        let userInfo = UserDefaults()
        myid = userInfo.string(forKey: "userID")
        //获取用户信息
        let parameters: Parameters = ["userid": userid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=personage&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(PersonUserInfo.self, from: data)
                    self.user_portrait.sd_setImage(with: URL(string: jsonModel.portrait!), placeholderImage: UIImage(named: "placeholder.png"))
                    self.user_portrait.contentMode = .scaleAspectFill
                    self.user_portrait.layer.masksToBounds = true
                    self.user_portrait.layer.cornerRadius =  self.user_portrait.frame.width/2
                    self.user_nickname.text = jsonModel.nickname
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        

        
        if RCIMClient().getConversation(RCConversationType.ConversationType_PRIVATE, targetId: userid)!.isTop {
            iftop.isOn = true
        }else{
            iftop.isOn = false
        }
        
        RCIMClient().getConversationNotificationStatus(RCConversationType.ConversationType_PRIVATE, targetId: userid, success: { (RCConversationNotificationStatus) in
            print("看看\(RCConversationNotificationStatus.rawValue)")
            if RCConversationNotificationStatus.rawValue == 0{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.ifshield.isOn = true
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.ifshield.isOn = false
                }
            }
        }, error: { (RCErrorCode) in

        })
        

        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imAction))
        user_portrait.addGestureRecognizer(imgClick)
        //开启 isUserInteractionEnabled 手势否则点击事件会没有反应
        user_portrait.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
    }
    
    
    //点击事件方法
    @objc func imAction() -> Void {
        print("图片点击事件")
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = userid
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
