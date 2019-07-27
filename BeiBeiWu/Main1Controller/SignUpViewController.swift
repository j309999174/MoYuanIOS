//
//  SignUpViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userPhone: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var authCode: UITextField!
    
    
    @IBAction func signIn_btn(_ sender: Any) {
        
        if ((userPhone?.text) != nil) && ((userPassword?.text) != nil) {
           let sb = UIStoryboard(name: "Main1", bundle:nil)
           let vc = sb.instantiateViewController(withIdentifier: "UserSet") as! UserSetViewController
           vc.userPhone = userPhone.text!
           vc.userPassword = userPassword.text!
           self.present(vc, animated: true, completion: nil)
        }
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
