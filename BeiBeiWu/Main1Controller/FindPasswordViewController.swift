//
//  FindPasswordViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/22.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

class FindPasswordViewController: UIViewController {

    @IBOutlet weak var userPhone: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var authCode: UITextField!
    
    var smscode:String?
    
    @IBAction func verification_btn(_ sender: UIButton) {
        if userPhone.text != nil {
            let parameters: Parameters = ["phoneNumber": userPhone.text!]
            Alamofire.request("https://www.banghua.xin/sms.php", method: .post, parameters: parameters).response { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    self.smscode = utf8Text
                }
            }
            
            var time = 60
            let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
            codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
            codeTimer.setEventHandler {
                
                time = time - 1
                
                DispatchQueue.main.async {
                    sender.isEnabled = false
                }
                
                if time == 0 {
                    codeTimer.cancel()
                    DispatchQueue.main.async {
                        sender.isEnabled = true
                        sender.setTitle("重新发送", for: .normal)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    sender.setTitle("\(time)", for: .normal)
                }
                
            }
            
            codeTimer.activate()
        }else{
            self.view.makeToast("请输入手机号")
        }
        
    }
    
    @IBAction func signIn_btn(_ sender: Any) {
        
        if ((userPhone?.text) != nil) && ((userPassword?.text) != nil) && ((authCode?.text) != nil){
            
            if (authCode?.text) == smscode {
                let parameters: Parameters = ["userPhone":userPhone.text!,"userPassword":userPassword.text!]
                Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=findpassword&m=socialchat", method: .post, parameters: parameters).response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        let sb = UIStoryboard(name: "Main1", bundle:nil)
                        let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
                        vc.hidesBottomBarWhenPushed = true
                        self.show(vc, sender: nil)
                    }
                }
            }else{
                self.view.makeToast("验证码错误")
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //textfield图
//        let phoneImage = UIImage(named: "phone")!
//        addLeftImageTo(txtField: userPhone, andImage: phoneImage)
//        let passwordImage = UIImage(named: "password")!
//        addLeftImageTo(txtField: userPassword, andImage: passwordImage)
        
        // Do any additional setup after loading the view.
        //键盘遮挡问题
        NotificationCenter.default.addObserver(self,selector:#selector(self.kbFrameChanged(_:)),name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
