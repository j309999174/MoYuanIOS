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


class SignInViewController: UIViewController {

    @IBOutlet weak var userAccount_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    
    var userID:String?
    var userNickName:String?
    var userPortrait:String?
    
    @IBAction func signUp_btn(_ sender: Any) {
        let parameters: Parameters = ["userAccount": userAccount_tf.text!,"userPassword": password_tf.text!]
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
                    self.getRongyunToken()
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }
            
            
            
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response))")
//            print("Error: \(String(describing: response.error))")
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")
//            }
        }
        
    }
    
    
    @IBAction func signIn_btn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main1", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
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
    
    
    func getRongyunToken(){
        
        let parameters: Parameters = ["userID": self.userID!,"userNickName":self.userNickName!,"userPortrait":self.userPortrait!]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
