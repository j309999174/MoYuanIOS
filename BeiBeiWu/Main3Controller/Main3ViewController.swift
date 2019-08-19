//
//  Main3ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
struct FriendsStruct: Codable {
    let id: String
    let nickname: String
    let portrait: String
}

class Main3ViewController: UIViewController {
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataList:[FriendsData] = [];
    var currentDataList:[FriendsData] = [];
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    @IBOutlet weak var newFriend_label: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RCIM.shared()?.userInfoDataSource = self
        //设置融云当前用户信息
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let userNickName = userInfo.string(forKey: "userNickName")!
        let userPortrait = userInfo.string(forKey: "userPortrait")!
        let myinfo = RCUserInfo.init(userId: userID, name: userNickName, portrait: userPortrait)
        RCIM.shared()?.currentUserInfo = myinfo
        
        
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
                        let cell = FriendsData(userID:jsonModel[index].id,userNickName: jsonModel[index].nickname,userPortrait: jsonModel[index].portrait)
                        self.dataList.append(cell)
                    }
                    self.currentDataList = self.dataList
                    self.friendsTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friendsapplynumber&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.newFriend_label.setTitle("+新朋友 \(utf8Text)", for: UIControl.State.normal)
                
            }
        }
    }
    

}


extension Main3ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = currentDataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FriendsTableViewCell
        
        cell.setData(data: oneOfList)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneOfList = dataList[indexPath.row]
        //同一个StoryBoard下
        let vc = ChatViewController.init(conversationType: .ConversationType_PRIVATE, targetId: oneOfList.userID)!
        vc.title = oneOfList.userNickName
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Main3ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentDataList = dataList
            friendsTableView.reloadData()
            return
        }
        currentDataList = dataList.filter({ friendsData -> Bool in
            friendsData.userNickName.contains(searchText)
        })
        friendsTableView.reloadData()
    }
}


extension Main3ViewController:RCIMUserInfoDataSource {
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        for index in 0..<dataList.count{
            if dataList[index].userID == userId{
               let userinfo = RCUserInfo.init(userId: dataList[index].userID, name: dataList[index].userNickName, portrait: dataList[index].userPortrait)
               completion(userinfo)
            }
        }
    }
}
