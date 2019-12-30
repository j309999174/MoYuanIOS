//
//  NewFriendViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire


struct NewFriendStruct: Codable {
    let yourid: String
    let yournickname: String
    let yourportrait: String
    let yourleavewords: String
    let agree: String
}

class NewFriendViewController: UIViewController,UIGestureRecognizerDelegate {

    
    @IBOutlet weak var newFriendTableView: UITableView!
    
    let userInfo = UserDefaults()
    var userID:String?
    var userNickName:String?
    var userPortrait:String?
    var dataList:[NewFriendData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //保存当前申请好友数
        let parameters: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friendsapplynumber&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "0" {
                    self.tabBarController?.tabBar.items![2].badgeValue = nil
                }else{
                    let newFriendNumber = UserDefaults()
                    newFriendNumber.setValue(utf8Text, forKey: "no")
                    self.tabBarController?.tabBar.items![2].badgeValue = nil
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = userInfo.string(forKey: "userID")
        userNickName = userInfo.string(forKey: "userNickName")
        userPortrait = userInfo.string(forKey: "userPortrait")
        let parameters: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=friendsapply&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([NewFriendStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = NewFriendData(userID:jsonModel[index].yourid,userNickName: jsonModel[index].yournickname,userPortrait: jsonModel[index].yourportrait,userLeaveWords: jsonModel[index].yourleavewords,agree: jsonModel[index].agree)
                        self.dataList.append(cell)
                    }
                   self.newFriendTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
            
        }
        // Do any additional setup after loading the view.
        
        
        
        
        
        //长按删除
        setupLongPressGesture()
        
    }

   func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.newFriendTableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.newFriendTableView)
            if let indexPath = newFriendTableView.indexPathForRow(at: touchPoint) {
                print("长按了\(dataList[indexPath[1]].userID)")
                print("长按了\(dataList[indexPath[1]].userNickName)")
                //删除申请的好友
                let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                
                actionSheet.addAction(UIAlertAction(title: "删除", style: .default, handler: {(action: UIAlertAction) in
                    let parameters: Parameters = ["myid": self.dataList[indexPath[1]].userID,"yourid":self.userID!]
                    Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=DeleteFriendsapply&m=socialchat", method: .post, parameters: parameters).response { response in
                        print("Request: \(String(describing: response.request))")
                        print("Response: \(String(describing: response.response))")
                        print("Error: \(String(describing: response.error))")

                        self.dataList.remove(at: indexPath[1])
                        self.newFriendTableView.reloadData()
                        print("已删除新好友项")
                        
                        
                    }
                }))
                
                
                actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                if UIDevice.current.userInterfaceIdiom == .pad {
                    actionSheet.popoverPresentationController!.sourceView = self.view
                    actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
                }
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
}


extension NewFriendViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newFriendCell") as! NewFriendTableViewCell
        
        cell.setData(data: oneOfList)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = dataList[indexPath.row].userID
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
    
}


extension NewFriendViewController:NewFriendTableViewCellDelegate{
    func didAgree(yourid: String, yournickname: String, yourportrait: String,agreebtn:UIButton) {
        print("userid:\(userID!);yourid\(yourid);yournickname:\(yournickname);yourportrait:\(yourportrait)")
        let parameters: Parameters = ["myid": userID!,"mynickname":userNickName!,"myportrait":userPortrait!,"yourid":yourid,"yournickname":yournickname,"yourportrait":yourportrait]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=agreefriend&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            agreebtn.setTitle("已同意", for: UIControl.State.normal)
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
    
}


