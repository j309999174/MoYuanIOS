//
//  InformReasonViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/11.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class InformReasonViewController: UIViewController {

    @IBOutlet weak var inform_reason: UITextView!
    @IBAction func submit_btn(_ sender: Any) {
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["type": type!,"itemid": itemid!,"informerid": userID!,"reason": inform_reason.text ?? ""]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addinform&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.view.makeToast("举报成功")
                self.presentingViewController?.dismiss(animated:true)
            }
        }
    }
    var type:String?
    var itemid:String?
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
