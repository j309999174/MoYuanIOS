//
//  PersonalViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/30.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct personalInfo: Codable {
    let portrait: String?
    let nickname: String?
    let age: String?
    let gender: String?
    let property: String?
    let region: String?
    let signature:String?
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
    
    @IBOutlet weak var viewClick_friend: UIView!
    
    @IBOutlet weak var viewClick_blacklist: UIView!
    
    @IBAction func personalPost_btn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main5", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Someonesluntan") as! SomeonesluntanViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.personid = userID
        self.show(vc, sender: nil)
    }
    
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBAction func addFriend(_ sender: Any) {
        getFriendNumber()
        addFriendBtn.isEnabled = false
        addFriendBtn.setTitle("已申请，等待对方同意", for: UIControl.State.normal)
    }
    
    @IBAction func addblacklist(_ sender: Any) {
        let parameters: Parameters = ["myid":yourid!,"yourid":userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("拉黑成功")
            }
        }
        addFriendBtn.isEnabled = false
        addFriendBtn.setTitle("已加入黑名单", for: UIControl.State.normal)
    }
    
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
        getFriendNumber()
        addFriendBtn.isEnabled = false
        addFriendBtn.setTitle("已申请，等待对方同意", for: UIControl.State.normal)
    }
    @objc func blacklistClickFunc() -> Void {
        let parameters: Parameters = ["myid":yourid!,"yourid":userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("拉黑成功")
            }
        }
        addFriendBtn.isEnabled = false
        addFriendBtn.setTitle("已加入黑名单", for: UIControl.State.normal)
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
                    self.userPortrait.image = UIImage(data: imageData)
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
                if utf8Text != "还未申请好友" {
                    self.addFriendBtn.isEnabled = false
                    self.addFriendBtn.setTitle(utf8Text, for: UIControl.State.normal)
                    self.view.makeToast(utf8Text)
                }
            }
        }
    }
}
