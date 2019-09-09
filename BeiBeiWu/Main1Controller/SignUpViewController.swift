//
//  SignUpViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

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
                
                if time < 0 {
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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSetIdentity") as! UserSetViewController
                vc.userPhone = userPhone.text!
                vc.userPassword = userPassword.text!
                self.navigationController?.pushViewController(vc, animated: true)
                }else{
                self.view.makeToast("验证码错误")
            }
           
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //textfield图
        let phoneImage = UIImage(named: "phone")!
        addLeftImageTo(txtField: userPhone, andImage: phoneImage)
        let passwordImage = UIImage(named: "password")!
        addLeftImageTo(txtField: userPassword, andImage: passwordImage)
        
        // Do any additional setup after loading the view.
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
