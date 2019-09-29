//
//  ConversationViewCustomViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/28.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class ConversationViewCustomViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "⚙️", style: UIBarButtonItem.Style.plain, target: nil, action: #selector(imAction)), animated: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    //点击事件方法
    @objc func imAction() -> Void {
        print("设置点击")
        let sb = UIStoryboard(name: "Main2", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ConversationSetting") as! ConversationSettingViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.userid = self.targetId
        self.show(vc, sender: nil)
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
