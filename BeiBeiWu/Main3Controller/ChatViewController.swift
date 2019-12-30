//
//  ChatViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/9.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import RongContactCard

class ChatViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(title: "⚙️", style: UIBarButtonItem.Style.plain, target: nil, action: #selector(rightbarAction)), animated: false)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        print("未读信息数\(String(describing: RCIMClient.shared()?.getTotalUnreadCount()))")
        if RCIMClient.shared()?.getTotalUnreadCount() == 0 {
            self.tabBarController?.tabBar.items![1].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items![1].badgeValue = String(Int((RCIMClient.shared()?.getTotalUnreadCount())!))
        }
    }
    //点击事件方法
    @objc func rightbarAction() -> Void {
        print("设置点击")
        let sb = UIStoryboard(name: "Main2", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ConversationSetting") as! ConversationSettingViewController
        //vc.hidesBottomBarWhenPushed = true
        vc.userid = self.targetId
        self.show(vc, sender: nil)
    }
    
    override func didTapCellPortrait(_ userId: String!) {
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = userId
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
    //融云消息点击事件
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        
        if model.content.isKind(of: RCContactCardMessage.self){
            let cardMessage = model.content as! RCContactCardMessage
            //不同的StoryBoard下
            let sb = UIStoryboard(name: "Personal", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
            vc.userID = cardMessage.userId
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }
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
