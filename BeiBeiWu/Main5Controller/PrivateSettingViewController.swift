//
//  PrivateSettingViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/24.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct PrivateSetting:Codable {
    let allowgroup:String?
    let allowlocation:String?
    let allowstatus:String?
    let allowfriend:String?
}

class PrivateSettingViewController: UIViewController {

    @IBOutlet weak var switch_btn1: UISwitch!
    
    @IBOutlet weak var switch_btn2: UISwitch!
    
    @IBOutlet weak var switch_btn3: UISwitch!
    
    @IBOutlet weak var switch_btn4: UISwitch!
    
    
    @IBAction func switch1(_ sender: UISwitch) {
        if sender.isOn == true {
            self.view.makeToast("开启")
            setPrivateSetting(type: "group")
        }else{
            self.view.makeToast("关闭")
            setPrivateSetting(type: "group")
        }
    }
    
    @IBAction func switch2(_ sender: UISwitch) {
        if sender.isOn == true {
            self.view.makeToast("开启")
            setPrivateSetting(type: "location")
        }else{
            self.view.makeToast("关闭")
            setPrivateSetting(type: "location")
        }
    }
    
    
    @IBAction func switch3(_ sender: UISwitch) {
        if sender.isOn == true {
            self.view.makeToast("开启")
            setPrivateSetting(type: "status")
        }else{
            self.view.makeToast("关闭")
            setPrivateSetting(type: "status")
        }
    }
    
    @IBAction func switch4(_ sender: UISwitch) {
        if sender.isOn == true {
            self.view.makeToast("开启")
            setPrivateSetting(type: "friend")
        }else{
            self.view.makeToast("关闭")
            setPrivateSetting(type: "friend")
        }
    }
    
    func setPrivateSetting(type:String) {
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["userid": userID!,"type":type]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=setprivatesetting&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
               
            }
        }
    }
    
    func getPrivateSetting(){
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["userid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=getprivatesetting&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(PrivateSetting.self, from: data)
                    if jsonModel.allowgroup == "1" {
                        self.switch_btn1.setOn(true, animated: true)
                    }else{
                        self.switch_btn1.setOn(false, animated: true)
                    }
                    if jsonModel.allowlocation == "1" {
                        self.switch_btn2.setOn(true, animated: true)
                    }else{
                        self.switch_btn2.setOn(false, animated: true)
                    }
                    if jsonModel.allowstatus == "1" {
                        self.switch_btn3.setOn(true, animated: true)
                    }else{
                        self.switch_btn3.setOn(false, animated: true)
                    }
                    if jsonModel.allowfriend == "1" {
                        self.switch_btn4.setOn(true, animated: true)
                    }else{
                        self.switch_btn4.setOn(false, animated: true)
                    }
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        getPrivateSetting()
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

}
