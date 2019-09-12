//
//  Main5ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class Main5ViewController: UIViewController {
    @IBOutlet weak var userPortrait_image: UIImageView!
    @IBOutlet weak var userNickName_label: UILabel!
    @IBOutlet weak var beiyuanhao: UILabel!
    @IBAction func gerenziliao(_ sender: UIButton) {
        
    }
    @IBAction func circle(_ sender: UIButton) {
        
    }
    @IBAction func openVIP(_ sender: UIButton) {
        
    }
    @IBAction func scoreQuery(_ sender: UIButton) {
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["userid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=getscore&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let allscore = String(data: data, encoding: .utf8) {
                print("Data: \(allscore)")
                //self.view.makeToast("共拥有\(allscore)积分")
                
                let actionSheet = UIAlertController(title: "您共有\(allscore)积分！", message: "", preferredStyle: .actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "兑换一天会员", style: .default, handler: {(action: UIAlertAction) in
                    let parameters: Parameters = ["myid": userID!,"allscore": allscore]
                    Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=sorttovip&m=socialchat", method: .post, parameters: parameters).response { response in
                        print("Request: \(String(describing: response.request))")
                        print("Response: \(String(describing: response.response))")
                        print("Error: \(String(describing: response.error))")
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                            self.view.makeToast(utf8Text)
                        }
                    }
                }))
                
                actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                actionSheet.popoverPresentationController!.sourceView = self.view
                actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func myPromotionCode(_ sender: UIButton) {
        self.view.makeToast("您的推广码是\(userID!)")
    }
    @IBAction func whoSawMe(_ sender: UIButton) {
        
    }
    @IBAction func setting(_ sender: UIButton) {
        
    }
    var userID:String?
    var userNickName:String?
    var userPortrait:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Uniquelogin.compareUniqueLoginToken(view: self)
        
        let userInfo = UserDefaults()
        userID = userInfo.string(forKey: "userID")
        userNickName = userInfo.string(forKey: "userNickName")
        userPortrait = userInfo.string(forKey: "userPortrait")!

        userNickName_label.text = userNickName
        do {
            let data = try Data(contentsOf: URL(string: userPortrait!)!)
            userPortrait_image.image = UIImage(data: data)
            userPortrait_image.contentMode = .scaleAspectFill
            //设置遮罩
            userPortrait_image.layer.masksToBounds = true
            //设置圆角半径(宽度的一半)，显示成圆形。
            userPortrait_image.layer.cornerRadius = userPortrait_image.frame.width/2
        }catch let err{
            print(err)
        }
        beiyuanhao.text = "贝缘号:\(userID!)"
        // Do any additional setup after loading the view.
        //更新融云用户信息
        print("\(userNickName!)")
        
        //刷新融云缓存
        let userinfo = RCUserInfo.init(userId: userID, name:userPortrait, portrait: userPortrait)
        RCIM.shared()?.refreshUserInfoCache(userinfo, withUserId: userID)
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

