//
//  PersonalViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/30.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

struct ifFriendInfo: Codable {
    let blacklistinfo: String?
    let friendinfo: String?
}

struct personalInfo: Codable {
    let portrait: String?
    let nickname: String?
    let age: String?
    let gender: String?
    let property: String?
    let region: String?
    let signature:String?
    let vip:String?
}

class PersonalViewController: UIViewController {

    var userID:String?
    
    @IBAction func goback_btn(_ sender: Any) {
        presentingViewController?.dismiss(animated:true)
    }
    
    @IBOutlet weak var userPortrait: UIImageView!{
        didSet{
            userPortrait.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait.layer.cornerRadius = userPortrait.frame.width/2
        }
    }
    
    @IBOutlet weak var userNickName: UILabel!
    
    @IBOutlet weak var userProperty: UILabel!
    
    @IBOutlet weak var userRegion: UILabel!
    
    @IBOutlet weak var userGender: UILabel!
    
    @IBOutlet weak var userAge: UILabel!
    
    @IBOutlet weak var userSignature: UILabel!
    
    @IBOutlet weak var userinfobackground: UIView!
    var yourid:String?
    var yournickname:String?
    var yourportrait:String?
    
    @IBOutlet weak var leaveWords: UITextField!
    
    @IBOutlet weak var viewClick_post: UIView!
    
    @IBOutlet weak var viewClick_startconversation: UIView!
    
    
    @IBOutlet weak var viewClick_friend: UIView!
    
    @IBOutlet weak var viewClick_blacklist: UIView!
    
    @IBOutlet weak var viewClick_deletefriend: UIView!
    
    
    @IBAction func personalPost_btn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main5", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Someonesluntan") as! SomeonesluntanViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.personid = userID
        self.show(vc, sender: nil)
    }
    
    @IBOutlet weak var addFriendBtn: UIButton!

    
    @IBOutlet weak var addblacklist_btn: UIButton!

    var blacklistinfo:String?
    var friendinfo:String?
    
    func getFriendNumber(){
        let parameters: Parameters = ["myid": yourid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friendsnumber&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "好友人数未超过限制"{
                    self.makefriend()
                }else{
                    self.addFriendBtn.setTitle(utf8Text, for: UIControl.State.normal)
                    self.view.makeToast(utf8Text)
                }
            }
        }
    }
    
    func makefriend(){
        let yourwords = leaveWords.text
        let parameters: Parameters = ["myid": userID!,"yourid":yourid!,"yournickname":yournickname!,"yourportrait":yourportrait!,"yourwords":yourwords ?? ""]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addfriend&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("好友申请成功")
            }
            
            //self.presentingViewController?.dismiss(animated:true)
        }
    }
    //点击事件方法
    @objc func postClickFunc() -> Void {
        let sb = UIStoryboard(name: "Main5", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Someonesluntan") as! SomeonesluntanViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.personid = userID
        self.show(vc, sender: nil)
    }
    @objc func friendClickFunc() -> Void {
        // Prepare the popup assets
        let title = "提示"
        let message = "是否添加好友"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let buttonOne = CancelButton(title: "取消") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "确认", dismissOnTap: true) {
            self.getFriendNumber()
            self.addFriendBtn.isEnabled = false
            self.addFriendBtn.setTitle("已申请，等待对方同意", for: UIControl.State.normal)
            self.viewClick_friend.isUserInteractionEnabled = false
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        popup.buttonAlignment = .horizontal
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    @objc func blacklistClickFunc() -> Void {
        if addblacklist_btn.currentTitle == "加入黑名单"{
            // Prepare the popup assets
            let title = "提示"
            let message = "是否加入黑名单"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            // Create buttons
            let buttonOne = CancelButton(title: "取消") {
                print("You canceled the car dialog.")
            }
            
            // This button will not the dismiss the dialog
            let buttonTwo = DefaultButton(title: "确认", dismissOnTap: true) {
                let parameters: Parameters = ["myid":self.yourid!,"yourid":self.userID!]
                Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        self.view.makeToast("拉黑成功")
                        self.addblacklist_btn.setTitle("移除黑名单", for: UIControl.State.normal)
                    }
                }
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo])
            popup.buttonAlignment = .horizontal
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        
        }else{
            // Prepare the popup assets
            let title = "提示"
            let message = "是否移除黑名单"
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            // Create buttons
            let buttonOne = CancelButton(title: "取消") {
                print("You canceled the car dialog.")
            }
            
            // This button will not the dismiss the dialog
            let buttonTwo = DefaultButton(title: "确认", dismissOnTap: true) {
                let parameters: Parameters = ["myid":self.yourid!,"yourid":self.userID!]
                Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=deleteblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        self.view.makeToast("移除成功")
                        self.addblacklist_btn.setTitle("加入黑名单", for: UIControl.State.normal)
                    }
                }
            }
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo])
            popup.buttonAlignment = .horizontal
            // Present dialog
            self.present(popup, animated: true, completion: nil)
            
        }
        
        
    }
    @objc func startconversationClickFunc() -> Void {
        //同一个StoryBoard下
        let vc = ChatViewController.init(conversationType: .ConversationType_PRIVATE, targetId: userID)!
        vc.title = self.userNickName.text
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func deletefriendClickFunc() -> Void {
        // Prepare the popup assets
        let title = "提示"
        let message = "是否删除好友"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // Create buttons
        let buttonOne = CancelButton(title: "取消") {
            print("You canceled the car dialog.")
        }
        
        // This button will not the dismiss the dialog
        let buttonTwo = DefaultButton(title: "确认", dismissOnTap: true) {
            RCIMClient.shared()?.remove(RCConversationType.ConversationType_PRIVATE, targetId: self.userID!)
            // Present dialog
            let parameters: Parameters = ["myid":self.yourid!,"yourid":self.userID!]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=deletefriend&m=socialchat", method: .post, parameters: parameters).response { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    self.view.makeToast("删除成功")
                    self.viewClick_friend.isHidden = false
                    self.viewClick_deletefriend.isHidden = true
                    self.viewClick_startconversation.isHidden = true
                }
            }
        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo])
        popup.buttonAlignment = .horizontal
        
        self.present(popup, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        
        //帖子，h好友，黑名单的view点击事件
        let postClick = UITapGestureRecognizer(target: self, action: #selector(postClickFunc))
        viewClick_post.addGestureRecognizer(postClick)
        let friendClick = UITapGestureRecognizer(target: self, action: #selector(friendClickFunc))
        viewClick_friend.addGestureRecognizer(friendClick)
        let blacklistClick = UITapGestureRecognizer(target: self, action: #selector(blacklistClickFunc))
        viewClick_blacklist.addGestureRecognizer(blacklistClick)
        //删除好友和发起会话
        let startconversationClick = UITapGestureRecognizer(target: self, action: #selector(startconversationClickFunc))
        viewClick_startconversation.addGestureRecognizer(startconversationClick)
        let deletefriendClick = UITapGestureRecognizer(target: self, action: #selector(deletefriendClickFunc))
        viewClick_deletefriend.addGestureRecognizer(deletefriendClick)
        
        userinfobackground.layer.contents = UIImage.init(named: "hover")?.cgImage
        userinfobackground.contentMode = UIView.ContentMode.scaleToFill
        
        let userInfo = UserDefaults()
        yourid = userInfo.string(forKey: "userID")
        yournickname = userInfo.string(forKey: "userNickName")
        yourportrait = userInfo.string(forKey: "userPortrait")
        
        ifFriend()
        
        let parameters: Parameters = ["userid": userID!]
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
                    let jsonModel = try decoder.decode(personalInfo.self, from: data)
                    self.userNickName.text = jsonModel.nickname
                    let imageData = try Data(contentsOf: URL(string: jsonModel.portrait!)!)
                    if jsonModel.vip == "VIP"{
                        self.userPortrait.image = UIImage().waterMarkedImage(bg: imageData, logo: "vip", scale: 0.2, margin: 20)
                    }else{
                        self.userPortrait.image = UIImage.init(data: imageData)
                    }
                    self.userRegion.text = jsonModel.region
                    self.userGender.text = jsonModel.gender
                    self.userAge.text = jsonModel.age
                    self.userSignature.text = jsonModel.signature
                    self.userProperty.text = jsonModel.property
                } catch {
                    print("解析 JSON 失败")
                }
            }
            
        }
        // Do any additional setup after loading the view.
        //键盘遮挡问题
        //NotificationCenter.default.addObserver(self,selector:#selector(self.kbFrameChanged(_:)),name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
    }
    
    @objc func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: offsetY/2)
            //键盘上弹时候, 将返回 button 下移同样的位置,确保在弹出键盘期间可以返回.
            //self.backBt.transform = CGAffineTransform(translationX: 0, y: -offsetY)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func ifFriend(){
        let parameters: Parameters = ["myid": userID!,"yourid":yourid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=iffriend&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(ifFriendInfo.self, from: data)
                    self.blacklistinfo = jsonModel.blacklistinfo
                    self.friendinfo = jsonModel.friendinfo
                    
                    if self.blacklistinfo == "已加入黑名单"{
                        self.addblacklist_btn.setTitle("移除黑名单", for: UIControl.State.normal)
                        self.view.makeToast(self.blacklistinfo)
                    }
                    if self.friendinfo == "已经是好友"{
                        self.viewClick_friend.isHidden = true
                        self.viewClick_deletefriend.isHidden = false
                        self.viewClick_startconversation.isHidden = false
                        self.view.makeToast(self.friendinfo)
                    }else if self.friendinfo == "已申请，等待对方同意"{
                        self.addFriendBtn.setTitle(self.friendinfo, for: UIControl.State.normal)
                        self.viewClick_friend.isUserInteractionEnabled = false
                    }
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
}
