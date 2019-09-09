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
    
    
    
    @IBOutlet weak var leaveWords: UITextField!
    
    @IBAction func personalPost_btn(_ sender: Any) {
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "PersonalPostIdentity") as! PersonalPostViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.authid = userID!
        self.show(vc, sender: nil)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        let userInfo = UserDefaults()
        let yourid = userInfo.string(forKey: "userID")
        let yournickname = userInfo.string(forKey: "userNickName")
        let yourportrait = userInfo.string(forKey: "userPortrait")
        let yourwords = leaveWords.text
        let parameters: Parameters = ["myid": userID!,"yourid":yourid!,"yournickname":yournickname!,"yourportrait":yourportrait!,"yourwords":yourwords ?? ""]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addfriend&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            
            self.presentingViewController?.dismiss(animated:true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
