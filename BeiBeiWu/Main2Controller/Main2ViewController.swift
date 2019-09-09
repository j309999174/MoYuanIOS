//
//  Main2ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class Main2ViewController: RCConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let type1:RCConversationType = .ConversationType_PRIVATE
//        let type2:RCConversationType = .ConversationType_DISCUSSION
//        let type3:RCConversationType = .ConversationType_CHATROOM
//        let type4:RCConversationType = .ConversationType_GROUP
//        let type5:RCConversationType = .ConversationType_APPSERVICE
//        let type6:RCConversationType = .ConversationType_SYSTEM
        
        setDisplayConversationTypes([1,2,3,4,6,7])
        
        setCollectionConversationType([7])
        // Do any additional setup after loading the view.
        
    }
    
    
    override
    func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        let vc = RCConversationViewController()
        vc.conversationType = model.conversationType
        vc.targetId = model.targetId
        vc.hidesBottomBarWhenPushed = true
        print("vc.unReadMessage\(vc.unReadMessage)")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override
    func notifyUpdateUnreadMessageCount() {
        DispatchQueue.global(qos: .userInitiated).async {
            // back to the main thread
            DispatchQueue.main.async {
//                角标
//                let root = self.tabBarController
//                var tabBarItem = UITabBarItem()
//                tabBarItem = root!.tabBar.items![1]
//                tabBarItem.badgeValue = "1"
            }
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


