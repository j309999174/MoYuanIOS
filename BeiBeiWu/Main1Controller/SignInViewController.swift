//
//  SignInViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct UserInfo: Codable {
    let error: String
    let info: String
    let userID: String
    let userNickName:String
    let userPortrait:String
    let userAge: String
    let userGender: String
    let userProperty: String
    let userRegion: String
}

struct RongyunToken: Codable {
    let code: Int
    let userId: String
    let token: String
}


struct WXToken: Codable {
    let access_token:String?
    let expires_in:Int?
    let refresh_token:String?
    let openid:String?
    let scope:String?
    let unionid:String?
}

struct WXUserinfo: Codable {
    let openid:String?
    let nickname:String?
    let sex:Int?
    let province:String?
    let city:String?
    let country:String?
    let headimgurl:String?
    let privilege:[String]?
    let unionid:String?
}

struct WXLogin: Codable {
    let type:String?
    let id:String?
    let nickname:String?
    let portrait:String?
    let openid:String?
    let forbidtime:String?
}

class SignInViewController: UIViewController {

    @IBOutlet weak var userAccount_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var weixin_btn: UIButton!
    @IBOutlet weak var thirdparty_label: UILabel!
    var userID:String?
    var userNickName:String?
    var userPortrait:String?
    var openid:String?
    
    var isuniquetoken:Bool?
    @IBAction func weixinBtn(_ sender: Any) {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "wechat_sdk_demo"
        WXApi.send(req)
    }
    @IBAction func signUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpIdentity") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func findPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FindPasswordIdentity") as! FindPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signIn_btn(_ sender: Any) {
        let parameters: Parameters = ["userAccount": userAccount_tf.text!,"userPassword": password_tf.text!,"uniquelogintoken":Uniquelogin.saveToken]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=signin&m=socialchat", method: .post, parameters: parameters).response { response in
            
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(UserInfo.self, from: data)
                    print(jsonModel.userNickName)
                    
                    
                    self.userID = jsonModel.userID
                    self.userNickName = jsonModel.userNickName
                    self.userPortrait = jsonModel.userPortrait
                    //保存用户ID，名字，头像
                    let userInfo = UserDefaults()
                    userInfo.setValue(self.userID, forKey: "userID")
                    userInfo.setValue(self.userNickName, forKey: "userNickName")
                    userInfo.setValue(self.userPortrait, forKey: "userPortrait")
                    
                    //调用融云，获取token
                    self.getRongyunToken(userid: self.userID!, nickname: self.userNickName!, portrait: self.userPortrait!)
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }

        }

    }
    //  微信成功通知
    @objc func WXLoginSuccess(notification:Notification) {
        self.view.makeToast("微信成功通知")
        let code = notification.object as! String
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxc7ff179d403b7a51&secret=1cac4e740d7d91d2c8a76eaf00acad02&code=\(code)&grant_type=authorization_code"
        //获取access_token
        Alamofire.request(url, method: .post).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("微信token: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(WXToken.self, from: data)
                    print("获取微信用户信息")
                    self.getWXUserinfo(token: jsonModel.access_token!, openid: jsonModel.openid!)
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        
    }
    
    func getWXUserinfo(token:String,openid:String){
        //调用token
        let url = "https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openid)"
        Alamofire.request(url, method: .post).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("微信用户信息: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(WXUserinfo.self, from: data)
                    //http转为https
                    var portrait:String = jsonModel.headimgurl!
                    portrait.insert("s", at: (portrait.index(portrait.startIndex, offsetBy: 4)))
                    //微信已获取到用户信息，现在需要保存到数据库
                    self.openid = jsonModel.openid!
                    self.uploadWXUserinfo(openid: jsonModel.openid!, nickname: jsonModel.nickname!, portrait: portrait)
                    
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    
    func uploadWXUserinfo(openid:String,nickname:String,portrait:String){
        let parameters: Parameters = ["openid": openid,"nickname":nickname,"portrait":portrait,"uniquelogintoken":Uniquelogin.saveToken]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=weinxinregister&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShenBian") as! Main1ViewController
//                self.navigationController?.pushViewController(vc, animated: true)
                //根据返回值判断跳转哪
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(WXLogin.self, from: data)
                    //保存用户信息
                    let userInfo = UserDefaults()
                    userInfo.setValue(jsonModel.id, forKey: "userID")
                    userInfo.setValue(nickname, forKey: "userNickName")
                    userInfo.setValue(portrait, forKey: "userPortrait")
                    //调用融云，获取token
                    self.getRongyunToken(userid:jsonModel.id!, nickname: nickname, portrait: portrait)
                    
                    switch jsonModel.type {
                    case "1":
                        let userInfo = UserDefaults()
                        userInfo.setValue(jsonModel.id, forKey: "userID")
                        userInfo.setValue(jsonModel.nickname, forKey: "userNickName")
                        userInfo.setValue(jsonModel.portrait, forKey: "userPortrait")
                        //已存在，直接跳转
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShenBian") as! Main1ViewController
//                        self.navigationController?.show(vc, sender: true)
                        let sb = UIStoryboard(name: "Main1", bundle:nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ShenBian") as! Main1ViewController
                        vc.tabBarController?.tabBar.isHidden = false
                        self.show(vc, sender: nil)
                        break
                    case "2":
                        let userInfo = UserDefaults()
                        userInfo.setValue(jsonModel.id, forKey: "userID")
                        userInfo.setValue(jsonModel.nickname, forKey: "userNickName")
                        userInfo.setValue(jsonModel.portrait, forKey: "userPortrait")
                        //不存在，需要跳转设置页
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSetIdentity") as! UserSetViewController
                        vc.logtype = "2"
                        vc.openid = self.openid!
                        self.navigationController?.pushViewController(vc, animated: true)
                        break
                    case "3":
                        //被禁言
                        break
                    default :
                        break
                    }

                } catch {
                    print("解析 JSON 失败")
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WXApi.isWXAppInstalled(){
            thirdparty_label.isHidden = true
            weixin_btn.isHidden = true
        }
        
        if !(isuniquetoken ?? true) {
            self.view.makeToast("您的账号在其他设备登录，强制退出")
        }
        //textfield图
        let phoneImage = UIImage(named: "phone")!
        addLeftImageTo(txtField: userAccount_tf, andImage: phoneImage)
        let passwordImage = UIImage(named: "password")!
        addLeftImageTo(txtField: password_tf, andImage: passwordImage)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        //通知调用
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        //删除文件
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: filePath)
            print("Success to remove file.")
        }catch{
            print("Failed to remove file.")
        }
        // Do any additional setup after loading the view.
    }
    
    
    func getRongyunToken(userid:String,nickname:String,portrait:String){
        
        let parameters: Parameters = ["userID": userid,"userNickName":nickname,"userPortrait":portrait]
        Alamofire.request("https://rongyun.banghua.xin/RongCloud/example/User/userregister.php", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data{
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(RongyunToken.self, from: data)
                    print(jsonModel.token)
                    
                    //保存用户ID，名字，头像
                    let userInfo = UserDefaults()
                    userInfo.setValue(jsonModel.token, forKey: "rongyunToken")
                    
                    //跳转首页
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                } catch {
                    print("解析 JSON 失败")
                }
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
            
        }
    }

    
    func addLeftImageTo(txtField:UITextField,andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 30))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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

