//
//  Uniquelogin.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//

import Foundation
import Alamofire
class Uniquelogin{
    static var saveToken:String{
        let uniquelogintoken = Date().milliStamp
        let userInfo = UserDefaults()
        userInfo.setValue(uniquelogintoken, forKey: "uniquelogintoken")
        return uniquelogintoken
    }
    
    static func compareUniqueLoginToken(view:UIViewController){
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let uniquelogintoken = userInfo.string(forKey: "uniquelogintoken")
        let parameters: Parameters = ["myid": userID!,"token": uniquelogintoken!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=uniquelogin&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "false"{
                    let userInfo = UserDefaults()
                    userInfo.setValue("", forKey: "userID")
                    let sb = UIStoryboard(name: "Main1", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
                    vc.hidesBottomBarWhenPushed = false
                    vc.isuniquetoken = false
                    view.show(vc, sender: nil)
                }
            }
        }
    }
    
}
