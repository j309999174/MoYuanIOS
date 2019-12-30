//
//  Main2ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import RongContactCard

class Main2ViewController: RCConversationListViewController {
    var dataList:[FriendsData] = [];
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("展示")
        
        Uniquelogin.compareUniqueLoginToken(view: self)
        //        let type1:RCConversationType = .ConversationType_PRIVATE
        //        let type2:RCConversationType = .ConversationType_DISCUSSION
        //        let type3:RCConversationType = .ConversationType_CHATROOM
        //        let type4:RCConversationType = .ConversationType_GROUP
        //        let type5:RCConversationType = .ConversationType_APPSERVICE
        //        let type6:RCConversationType = .ConversationType_SYSTEM
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "会话列表"
        
        //融云个人名片
        RCContactCardKit.shareInstance()?.contactsDataSource = self as RCCCContactsDataSource
        //设置融云当前用户信息
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let userNickName = userInfo.string(forKey: "userNickName")!
        let userPortrait = userInfo.string(forKey: "userPortrait")!
        let myinfo = RCUserInfo.init(userId: userID, name: userNickName, portrait: userPortrait)
        RCIM.shared()?.currentUserInfo = myinfo
        
        // Do any additional setup after loading the view.
        RCIM.shared()?.userInfoDataSource = self
        
        let parameters: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friends&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([FriendsStruct].self, from: data)
                    self.dataList.removeAll()
                    for index in 0..<jsonModel.count{
                        let cell = FriendsData(userID:jsonModel[index].id,userNickName: jsonModel[index].nickname,userPortrait: jsonModel[index].portrait,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?",vip: jsonModel[index].vip ?? "?")
                        self.dataList.append(cell)
                        let userinfo = RCUserInfo.init(userId: jsonModel[index].id, name: jsonModel[index].nickname, portrait: jsonModel[index].portrait)
                        RCIM.shared()?.refreshUserInfoCache(userinfo, withUserId: jsonModel[index].id)
                    }
                    
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        self.setDisplayConversationTypes([1,2,3,4,6,7])
        
        self.setCollectionConversationType([7])
        

        let parameters1: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friendsapplynumber&m=socialchat", method: .post, parameters: parameters1).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "0" {
                    self.tabBarController?.tabBar.items![2].badgeValue = nil
                }else{
                    let newFriendNumber = UserDefaults().string(forKey: "no")
                    if(newFriendNumber ?? "0" == utf8Text){
                        self.tabBarController?.tabBar.items![2].badgeValue = nil
                    }else{
                        self.tabBarController?.tabBar.items![2].badgeValue = utf8Text
                    }
                }
            }
        }
    }
    
    
    override
    func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        let vc = ChatViewController()
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


extension Main2ViewController:RCIMUserInfoDataSource {
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        for index in 0..<dataList.count{
            if dataList[index].userID == userId{
                let userinfo = RCUserInfo.init(userId: dataList[index].userID, name: dataList[index].userNickName, portrait: dataList[index].userPortrait)
                completion(userinfo)
            }
        }
    }
}


extension Main2ViewController:RCCCContactsDataSource {
    func getAllContacts(_ resultBlock: (([RCCCUserInfo]?) -> Void)!) {
        var rcccUserInfo:[RCCCUserInfo] = [];
        for index in 0..<dataList.count{
            let userInfo = RCCCUserInfo.init(userId: dataList[index].userID, name: dataList[index].userNickName, portrait: dataList[index].userPortrait)!
            rcccUserInfo.append(userInfo)
        }
        resultBlock(rcccUserInfo)
    }
}
