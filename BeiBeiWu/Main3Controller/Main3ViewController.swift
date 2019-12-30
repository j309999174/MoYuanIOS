//
//  Main3ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import RongContactCard

struct FriendsStruct: Codable {
    let id: String
    let nickname: String
    let portrait: String
    
    let age:String?
    let gender:String?
    let region:String?
    let property:String?
    
    let vip:String?
}

class Main3ViewController: UIViewController {
    @IBOutlet weak var friendsTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataList:[FriendsData] = [];
    var currentDataList:[FriendsData] = [];
    // 排序后分组数据
    private var objectsArray : [[FriendsData]]?
    // 头部标题keys
    private var keysArray:[String]?
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        super.viewWillAppear(false)
        
        Uniquelogin.compareUniqueLoginToken(view: self)
        
        print("未读信息数\(String(describing: RCIMClient.shared()?.getTotalUnreadCount()))")
        if RCIMClient.shared()?.getTotalUnreadCount() == 0 {
            self.tabBarController?.tabBar.items![1].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items![1].badgeValue = String(Int((RCIMClient.shared()?.getTotalUnreadCount())!))
        }
    }
    
    @IBOutlet weak var newFriend_label: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RCIM.shared()?.userInfoDataSource = self
        //融云个人名片
        RCContactCardKit.shareInstance()?.contactsDataSource = self as RCCCContactsDataSource
        self.navigationItem.title = "通讯录"
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
                        let cell = FriendsData(userID:jsonModel[index].id,userNickName: jsonModel[index].nickname,userPortrait: jsonModel[index].portrait,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?",vip: jsonModel[index].vip ?? "?" )
                        self.dataList.append(cell)
                    }
                    self.currentDataList = self.dataList
                    UILocalizedIndexedCollation.getCurrentKeysAndObjectsData(needSortArray: self.currentDataList) { (dataArray,titleArray) in
                        self.objectsArray = dataArray   //分类后的数组合集
                        self.keysArray    = titleArray  //字母数组
                        self.friendsTableView.reloadData()
                    }
                    print("分组数\(String(describing: self.keysArray))")
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
                
                if utf8Text == "0" {
                    self.tabBarController?.tabBar.items![2].badgeValue = nil
                }else{
                    let newFriendNumber = UserDefaults().string(forKey: "no")
                    if(newFriendNumber ?? "0" == utf8Text){
                        self.tabBarController?.tabBar.items![2].badgeValue = nil
                        self.newFriend_label.setTitle("+新朋友", for: UIControl.State.normal)
                    }else{
                        self.tabBarController?.tabBar.items![2].badgeValue = utf8Text
                        self.newFriend_label.setTitle("+新朋友 \(utf8Text)", for: UIControl.State.normal)
                    }
                }
            }
        }
        //点击空白处键盘收起
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(Main3ViewController.handleTap(sender:))))
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //当前TextView/当前TextField.resignFirstResponder()
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

}


extension Main3ViewController:UITableViewDataSource,UITableViewDelegate{
    
    //MARK: tabView数据源及代理相关     分类数和每类条目数
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray![section].count
    }
    
    //MARK: 这是Setion标题 以及右侧索引数组设置  顶部分类标题和侧边导航
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray?[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = objectsArray![indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FriendsTableViewCell
        cell.delegate = self
        cell.setData(data: oneOfList)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneOfList = objectsArray![indexPath.section][indexPath.row]
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
            UILocalizedIndexedCollation.getCurrentKeysAndObjectsData(needSortArray: self.currentDataList) { (dataArray,titleArray) in
                self.objectsArray = dataArray   //分类后的数组合集
                self.keysArray    = titleArray  //字母数组
                self.friendsTableView.reloadData()
            }
            friendsTableView.reloadData()
            return
        }
        currentDataList = dataList.filter({ friendsData -> Bool in
            friendsData.userNickName.contains(searchText)
        })
        UILocalizedIndexedCollation.getCurrentKeysAndObjectsData(needSortArray: self.currentDataList) { (dataArray,titleArray) in
            self.objectsArray = dataArray   //分类后的数组合集
            self.keysArray    = titleArray  //字母数组
            self.friendsTableView.reloadData()
        }
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

extension Main3ViewController:FriendsTableViewCellDelegate{
    func personpage(userID:String){
        //跳转个人
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = userID
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }

}

//MARK: 排序成功处理
typealias successHandler = (_ dataArray : [[FriendsData]], _ sectionTitlesArray : [String]) -> Void
extension UILocalizedIndexedCollation{
    //MARK: 成功后 --- 得到对应的标题文字数组 以及对应分组中数据
    static func getCurrentKeysAndObjectsData(needSortArray : [FriendsData], finishCallback : @escaping successHandler) -> Void{
        
        // 数据源  用于分组，多对象的数组
        var dataArray = [[FriendsData]]()
        // 每个section的标题   分组标题
        var sectionTitleArray = [String]()
        
        let indexedCollation = self.current()
        
        var sortArray = [FriendsData]()
        
        //数组数据放入对象
        for sortObj in needSortArray {

            sortArray.append(sortObj)
        }
        
        //分组数
        // 获得索引数, 这里是27个（26个字母和1个#）
        let indexCount = indexedCollation.sectionTitles.count
        
        //创建分组，但是分组中还没有数据
        // 每一个一维数组可能有多个数据要添加，所以只能先创建一维数组，到时直接取来用
        for _ in 0..<indexCount {
            let array = [FriendsData]()
            dataArray.append(array)
        }
        
        // 将数据进行分类，存储到对应数组中
        for sortObj in sortArray {
            
            // 根据 SortObjectModel 的 objValue 判断应该放入哪个数组里
            // 返回值就是在 indexedCollation.sectionTitles 里对应的下标
            let sectionNumber = indexedCollation.section(for: sortObj, collationStringSelector: #selector(getter: FriendsData.userNickName))
            
            // 添加到对应一维数组中
            dataArray[sectionNumber].append(sortObj)
        }
        
        // 对每个已经分类的一维数组里的数据进行排序，如果仅仅只是分类可以不用这步    应该可以省略
//        for i in 0..<indexCount {
//
//            // 排序结果数组
//            let sortedPersonArray = indexedCollation.sortedArray(from: dataArray[i], collationStringSelector: #selector(getter: SortObjectModel.objValue))
//            // 替换原来数组
//            dataArray[i] = sortedPersonArray as! [SortObjectModel]
//        }
        
        
        //删除没有数据的分组
        // 用来保存没有数据的一维数组的下标
        var tempArray = [Int]()
        
        for (i, array) in dataArray.enumerated() {
            
            if array.count == 0 {
                tempArray.append(i)
            } else {
                // 给标题数组添加数据
                sectionTitleArray.append(indexedCollation.sectionTitles[i])
            }
        }
        
        // 删除没有数据的数组
        for i in tempArray.reversed() {
            dataArray.remove(at: i)
        }
        
        //将得到新的 分组数据以及标题数组
        finishCallback(dataArray, sectionTitleArray)
        
    }
}

extension Main3ViewController:RCCCContactsDataSource {
    func getAllContacts(_ resultBlock: (([RCCCUserInfo]?) -> Void)!) {
        var rcccUserInfo:[RCCCUserInfo] = [];
        for index in 0..<dataList.count{
            let userInfo = RCCCUserInfo.init(userId: dataList[index].userID, name: dataList[index].userNickName, portrait: dataList[index].userPortrait)
            rcccUserInfo.append(userInfo!)
        }
        resultBlock(rcccUserInfo)
    }
}

