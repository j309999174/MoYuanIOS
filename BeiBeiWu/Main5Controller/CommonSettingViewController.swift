//
//  CommonSettingViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/10/13.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

class CommonSettingViewController: UIViewController {
    @IBAction func cleanCache(_ sender: Any) {
        self.view.makeToast("已清除缓存")
    }
    
    @IBAction func cleanRecord(_ sender: Any) {
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friends&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([FriendsStruct].self, from: data)
                    
                    for index in 0..<jsonModel.count{
                        RCIMClient.shared()?.clearHistoryMessages(RCConversationType.ConversationType_PRIVATE, targetId: jsonModel[index].id, recordTime: 0, clearRemote: true, success: {
                            
                        }, error: { (RCErrorCode) in
                            
                        })
                    }
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        self.view.makeToast("已清除聊天记录")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
