//
//  SettingViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/16.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBAction func phone_reset(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "手机绑定"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func email_reset(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "邮箱绑定"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func password_reset(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "密码重置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func private_set(_ sender: Any) {
    }
    
    @IBAction func common_set(_ sender: Any) {
    }
    
    @IBAction func feedback_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "意见反馈"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func help_btn(_ sender: Any) {
        
    }
    
    @IBAction func version_btn(_ sender: Any) {
        self.view.makeToast("当前版本：2.0.0")
    }
    
    
    
    @IBAction func lougout_btn(_ sender: Any) {
        let userInfo = UserDefaults()
        userInfo.removeObject(forKey: "userID")
        userInfo.removeObject(forKey: "userNickName")
        userInfo.removeObject(forKey: "userPortrait")
//        let sb = UIStoryboard(name: "Main1", bundle:nil)
//        let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
//        vc.hidesBottomBarWhenPushed = true
//        self.show(vc, sender: nil)
        //let sb = UIStoryboard(name: "Main", bundle:nil)
        //let vc = sb.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        //self.present(vc, animated: true, completion: nil)
        //self.show(vc, sender: nil)
        self.navigationController?.tabBarController?.selectedIndex = 0
//        let sb = UIStoryboard(name: "Main1", bundle:nil)
//        let vc = sb.instantiateViewController(withIdentifier: "ShenBian") as! Main1ViewController
//        vc.tabBarController?.tabBar.isHidden = false
//        self.show(vc, sender: nil)
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
