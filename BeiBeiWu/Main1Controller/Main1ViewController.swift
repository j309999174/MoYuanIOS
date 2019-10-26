//
//  Main1ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import FSPagerView

struct SliderImages: Codable {
    let id: String
    let slidesort: String
    let slidename: String
    let slidepicture:String
    let slideurl:String?
}

struct TuiJianUserInfo: Codable {
    let id: String
    let portrait: String?
    let nickname: String?
    let age: String?
    let gender: String?
    let property: String?
    let region: String?
    let vip: String?
    let latitude:String?
    let longitude:String?
    let location: String?
}


class Main1ViewController: UIViewController {
    
    
    @IBOutlet weak var menu_sgement: UISegmentedControl!
    @IBAction func menuAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tuijian_btn()
            seewho_segment.selectedSegmentIndex = 0
            break
        case 1:
            fujin_btn()
            seewho_segment.selectedSegmentIndex = 0
            break
        case 2:
            let sb = UIStoryboard(name: "Main1", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SousuoViewIdentity") as! SousuoViewController
            //vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        case 3:
            if seewho_segment.isHidden {
                seewho_segment.isHidden = false
            }else{
                seewho_segment.isHidden = true
            }
            break
        default:
            break
        }
    }
    
    @IBOutlet weak var seewho_segment: UISegmentedControl!
    
    @IBAction func seewho(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("看全部")
            self.dataList.removeAll()
            for index in 0..<userID.count{
                print(userGender[index])
                    let cell = ShenBianData(userID:userID[index],userPortrait: userPortrait[index] , userNickName: userNickName[index] , userAge: userAge[index] , userGender: userGender[index] , userProperty: userProperty[index] , userDistance: userDistance[index]
                        , userRegion: userRegion[index] , userVIP: userVIP[index] )
                    self.dataList.append(cell)
            }
            self.shenBianTableView.reloadData()
            break
        case 1:
            print("只看女")
            self.dataList.removeAll()
            for index in 0..<userID.count{
                print(userGender[index])
                if userGender[index].elementsEqual("女") {
                    let cell = ShenBianData(userID:userID[index],userPortrait: userPortrait[index] , userNickName: userNickName[index] , userAge: userAge[index] , userGender: userGender[index] , userProperty: userProperty[index] , userDistance: userDistance[index]
                        , userRegion: userRegion[index] , userVIP: userVIP[index] )
                    self.dataList.append(cell)
                }
            }
            self.shenBianTableView.reloadData()
            break
        case 2:
            print("只看男")
            self.dataList.removeAll()
            for index in 0..<userID.count{
                print(userGender[index])
                if userGender[index].elementsEqual("男") {
                    let cell = ShenBianData(userID:userID[index],userPortrait: userPortrait[index] , userNickName: userNickName[index] , userAge: userAge[index] , userGender: userGender[index] , userProperty: userProperty[index] , userDistance: userDistance[index]
                        , userRegion: userRegion[index] , userVIP: userVIP[index] )
                    self.dataList.append(cell)
                }
            }
            self.shenBianTableView.reloadData()
            break
        default:
            break
        }
    }
    
    func tuijian_btn() {
        //更新幻灯片
        imageArr = imageArr_tuijian
        imageNameArr = imageNameArr_tuijian
        imageUrl = imageUrl_tuijian
        self.pagerView.reloadData()
        //更新用户
        tuijian_fujin = "tuijian"
        dataList = dataList_tuijian
        //只刷新tableview
        self.shenBianTableView.reloadData()
        
        
        
        //初始化时获取一次就够了
        //获取幻灯片数据
//        let getSlide: Parameters = ["type": "getSlide"]
//        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getSlide).response { response in
//            if let data = response.data {
//                let decoder = JSONDecoder()
//                do {
//                    let jsonModel = try decoder.decode([SliderImages].self, from: data)
//                    //清零
//                    self.imageArr.removeAll()
//                    self.imageNameArr.removeAll()
//                    self.imageUrl.removeAll()
//                    self.dataList.removeAll()
//                    for index in 0..<jsonModel.count{
//                        let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
//                        self.imageArr.append(UIImage(data: data)!)
//                        self.imageNameArr.append(jsonModel[index].slidename)
//                        self.imageUrl.append(jsonModel[index].slideurl ?? "")
//                    }
//                    self.pagerView.reloadData()
//                } catch {
//                    print("解析 JSON 失败")
//                }
//                //                    print("Request: \(String(describing: response.request))")
//                //                    print("Response: \(String(describing: response.response))")
//                //                    print("Error: \(String(describing: response.error))")
//                //
//                //                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                //                        print("Data: \(utf8Text)")
//                //                    }
//            }
//        }
        
        //获取推荐列表
//        var getUserInfo: Parameters
//        if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
//            getUserInfo = ["type": "getUserInfo","latitude":latitude,"longitude":longitude]
//        }else{
//            getUserInfo = ["type": "getUserInfo"]
//        }
//
//        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getUserInfo).response { response in
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response))")
//            print("Error: \(String(describing: response.error))")
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)")
//            }
//            if let data = response.data {
//                let decoder = JSONDecoder()
//                do {
//                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
//                    self.userID.removeAll()
//                    self.userPortrait.removeAll()
//                    self.userNickName.removeAll()
//                    self.userAge.removeAll()
//                    self.userGender.removeAll()
//                    self.userProperty.removeAll()
//                    self.userDistance.removeAll()
//                    self.userRegion.removeAll()
//                    self.userVIP.removeAll()
//                    for index in 0..<jsonModel.count{
//
//                        self.userID.append(jsonModel[index].id)
//                        self.userPortrait.append(jsonModel[index].portrait ?? "")
//                        self.userNickName.append(jsonModel[index].nickname ?? "未知")
//                        self.userAge.append(jsonModel[index].age ?? "未知")
//                        self.userGender.append(jsonModel[index].gender ?? "未知")
//                        self.userProperty.append(jsonModel[index].property ?? "未知")
//                        self.userDistance.append(jsonModel[index].location ?? "未知")
//                        self.userRegion.append(jsonModel[index].region ?? "未知")
//                        self.userVIP.append(jsonModel[index].vip ?? "未知")
//                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
//                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
//                        self.dataList.append(cell)
//                    }
//                    self.shenBianTableView.reloadData()
//                } catch {
//                    print("解析 JSON 失败")
//                }
//            }
//        }
    }
    
    func fujin_btn() {
        tuijian_fujin = "fujin"
        if dataList_fujin.count > 0 {
            //更新幻灯片
            imageArr = imageArr_fujin
            imageNameArr = imageNameArr_fujin
            imageUrl = imageUrl_fujin
            self.pagerView.reloadData()
            //更新用户
            dataList = dataList_fujin
            self.shenBianTableView.reloadData()
            return
        }
        //获取幻灯片数据
        let getSlide: Parameters = ["type": "getSlide"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fujin&m=socialchat", method: .post, parameters: getSlide).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "[]"{
                    self.pagerView.isHidden = true
                }else{
                    self.pagerView.isHidden = false
                }
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([SliderImages].self, from: data)
                    //清零
                    self.imageArr.removeAll()
                    self.imageNameArr.removeAll()
                    self.imageUrl.removeAll()
                    self.dataList.removeAll()
                    for index in 0..<jsonModel.count{
                        //let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                        //self.imageArr_fujin.append(UIImage(data: data)!)
                        self.imageArr_fujin.append(jsonModel[index].slidepicture)
                        self.imageNameArr_fujin.append(jsonModel[index].slidename)
                        self.imageUrl_fujin.append(jsonModel[index].slideurl ?? "")
                    }
                    self.imageArr = self.imageArr_fujin
                    self.imageNameArr = self.imageNameArr_fujin
                    self.imageUrl = self.imageUrl_fujin
                    self.pagerView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
                //                    print("Request: \(String(describing: response.request))")
                //                    print("Response: \(String(describing: response.response))")
                //                    print("Error: \(String(describing: response.error))")
                //
                //                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //                        print("Data: \(utf8Text)")
                //                    }
            }
        }
        
        //获取推荐列表
        var getUserInfo: Parameters
        if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
            getUserInfo = ["type": "getUserInfo","latitude":latitude,"longitude":longitude]
        }else{
            getUserInfo = ["type": "getUserInfo"]
        }
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fujin&m=socialchat", method: .post, parameters: getUserInfo).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            self.dataList.removeAll()
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                    self.userID.removeAll()
                    self.userPortrait.removeAll()
                    self.userNickName.removeAll()
                    self.userAge.removeAll()
                    self.userGender.removeAll()
                    self.userProperty.removeAll()
                    self.userDistance.removeAll()
                    self.userRegion.removeAll()
                    self.userVIP.removeAll()
                    for index in 0..<jsonModel.count{
                        self.userID.append(jsonModel[index].id)
                        self.userPortrait.append(jsonModel[index].portrait ?? "")
                        self.userNickName.append(jsonModel[index].nickname ?? "未知")
                        self.userAge.append(jsonModel[index].age ?? "未知")
                        self.userGender.append(jsonModel[index].gender ?? "未知")
                        self.userProperty.append(jsonModel[index].property ?? "未知")
                        self.userDistance.append(jsonModel[index].location ?? "未知")
                        self.userRegion.append(jsonModel[index].region ?? "未知")
                        self.userVIP.append(jsonModel[index].vip ?? "未知")
                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                        self.dataList_fujin.append(cell)
                    }
                    self.dataList = self.dataList_fujin
                    self.shenBianTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    
    
    
    
    
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.itemSize = FSPagerView.automaticSize
            pagerView.isInfinite = true
            pagerView.alwaysBounceHorizontal = true
            pagerView.removesInfiniteLoopForSingleItem = true
            pagerView.automaticSlidingInterval = 3.0
        }
    }
    
    //列表
    
    @IBOutlet weak var shenBianTableView: UITableView!
    //判断哪个n按钮被点击了，上拉加载就调用不同方法
    var tuijian_fujin = "tuijian"
    
    var dataList:[ShenBianData] = []
    var dataList_tuijian:[ShenBianData] = []
    var dataList_fujin:[ShenBianData] = []
    
    var userID = [String]()
    var userPortrait = [String]()
    var userNickName = [String]()
    var userAge = [String]()
    var userGender = [String]()
    var userProperty = [String]()
    var userDistance = [String]()
    var userRegion = [String]()
    var userVIP = [String]()

    var imageArr = [String]()
    var imageNameArr = [String]()
    var imageUrl = [String]()
    var imageArr_tuijian = [String]()
    var imageNameArr_tuijian = [String]()
    var imageUrl_tuijian = [String]()
    var imageArr_fujin = [String]()
    var imageNameArr_fujin = [String]()
    var imageUrl_fujin = [String]()
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults().string(forKey: "userID") == nil{
            let sb = UIStoryboard(name: "Main1", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            vc.hidesBottomBarWhenPushed = false
            self.show(vc, sender: nil)
        }
        
        print("未读信息数\(String(describing: RCIMClient.shared()?.getTotalUnreadCount()))")
        if RCIMClient.shared()?.getTotalUnreadCount() == 0 {
            self.tabBarController?.tabBar.items![1].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items![1].badgeValue = String(Int((RCIMClient.shared()?.getTotalUnreadCount())!))
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        print("嘿")
      
    

        
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        
        let font_normal = UIFont.systemFont(ofSize: 20)
        let font_selected = UIFont.systemFont(ofSize: 25)
        menu_sgement.setTitleTextAttributes([NSAttributedString.Key.font:font_normal], for: .normal)
        menu_sgement.setTitleTextAttributes([NSAttributedString.Key.font:font_selected], for: .selected)
        let color_normal = UIColor.init(named: "primarycolor")
        menu_sgement.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:color_normal as Any], for: .normal)
        let color_selected = UIColor.white
        menu_sgement.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:color_selected], for: .selected)

        //判断是否登录
        if UserDefaults().string(forKey: "userID") == nil{
            let sb = UIStoryboard(name: "Main1", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            vc.hidesBottomBarWhenPushed = false
            self.show(vc, sender: nil)
            
        }else{
           
            let userInfo = UserDefaults()
            let rongyunToken = userInfo.string(forKey: "rongyunToken")
            let userID = userInfo.string(forKey: "userID")
            //链接融云
            RCIM.shared()?.connect(withToken: rongyunToken, success: { (ok) in
                print("融云链接成功\(ok ?? "ok")")
            }, error: { (code) in
                print("融云链接失败\(code)")
            }, tokenIncorrect: {
                print("token不对")
            })

            
            Uniquelogin.compareUniqueLoginToken(view: self)
             //保存定位
            if let latitude = userInfo.string(forKey: "latitude"),let longitude = userInfo.string(forKey: "longitude") {
                let parameters: Parameters = ["userID": userID!,"latitude": latitude,"longitude": longitude]
                Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=updatelocation&m=socialchat", method: .post, parameters: parameters).response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                }
            }
            
            
            //获取幻灯片数据
            let getSlide: Parameters = ["type": "getSlide"]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getSlide).response { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    if utf8Text == "[]"{
                        self.pagerView.isHidden = true
                    }else{
                        self.pagerView.isHidden = false
                    }
                }
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let jsonModel = try decoder.decode([SliderImages].self, from: data)
                        for index in 0..<jsonModel.count{
                            //let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                            //self.imageArr_tuijian.append(UIImage(data: data)!)
                            self.imageArr_tuijian.append(jsonModel[index].slidepicture)
                            self.imageNameArr_tuijian.append(jsonModel[index].slidename)
                            self.imageUrl_tuijian.append(jsonModel[index].slideurl ?? "")
                        }
                        self.imageArr = self.imageArr_tuijian
                        self.imageNameArr = self.imageNameArr_tuijian
                        self.imageUrl = self.imageUrl_tuijian
                        self.pagerView.reloadData()
                    } catch {
                        print("解析 JSON 失败")
                    }
                    //                    print("Request: \(String(describing: response.request))")
                    //                    print("Response: \(String(describing: response.response))")
                    //                    print("Error: \(String(describing: response.error))")
                    //
                    //                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //                        print("Data: \(utf8Text)")
                    //                    }
                }
            }
            
            //获取推荐列表
            var getUserInfo: Parameters
            if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
                getUserInfo = ["type": "getUserInfo","myid": userID!,"latitude":latitude,"longitude":longitude,"pageindex":1]
            }else{
                getUserInfo = ["type": "getUserInfo","myid": userID!,"pageindex":1]
            }
            
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getUserInfo).response { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                print("获取推荐列表")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                        
                        for index in 0..<jsonModel.count{
                            self.userID.append(jsonModel[index].id)
                            self.userPortrait.append(jsonModel[index].portrait ?? "")
                            self.userNickName.append(jsonModel[index].nickname ?? "未知")
                            self.userAge.append(jsonModel[index].age ?? "未知")
                            self.userGender.append(jsonModel[index].gender ?? "未知")
                            self.userProperty.append(jsonModel[index].property ?? "未知")
                            self.userDistance.append(jsonModel[index].location ?? "未知")
                            self.userRegion.append(jsonModel[index].region ?? "未知")
                            self.userVIP.append(jsonModel[index].vip ?? "未知")
                            let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                                , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                            self.dataList_tuijian.append(cell)
                        }
                        self.dataList = self.dataList_tuijian
                        self.shenBianTableView.reloadData()
                    } catch {
                        print("解析 JSON 失败")
                    }
                }
            }
            
            
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
                        self.tabBarController?.tabBar.items![2].badgeValue = utf8Text
                    }
                }
            }
        }
        
        
    }
    
    
    func addLeftImageTo(txtField:UITextField,andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    var tuijian_pageindex = 1
    var tuijian_ScrollBottom = false
    func tuijianPage(pageindex:Int) {
        print("页码数\(pageindex)")
        //获取推荐列表
        var getUserInfo: Parameters
        if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
            getUserInfo = ["type": "getUserInfo","latitude":latitude,"longitude":longitude,"pageindex":pageindex]
        }else{
            getUserInfo = ["type": "getUserInfo","pageindex":pageindex]
        }
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getUserInfo).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "[]" {
                    self.tuijian_ScrollBottom = true
                    return
                }
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                    for index in 0..<jsonModel.count{
                        self.userID.append(jsonModel[index].id)
                        self.userPortrait.append(jsonModel[index].portrait ?? "")
                        self.userNickName.append(jsonModel[index].nickname ?? "未知")
                        self.userAge.append(jsonModel[index].age ?? "未知")
                        self.userGender.append(jsonModel[index].gender ?? "未知")
                        self.userProperty.append(jsonModel[index].property ?? "未知")
                        self.userDistance.append(jsonModel[index].location ?? "未知")
                        self.userRegion.append(jsonModel[index].region ?? "未知")
                        self.userVIP.append(jsonModel[index].vip ?? "未知")
                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                        self.dataList_tuijian.append(cell)
                    }
                    self.dataList = self.dataList_tuijian
                    self.shenBianTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    
    var fujin_pageindex = 1
    var fujin_ScrollBottom = false
    func fujinPage(pageindex:Int) {
        print("页码数\(pageindex)")
        //获取推荐列表
        var getUserInfo: Parameters
        if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
            getUserInfo = ["type": "getUserInfo","latitude":latitude,"longitude":longitude,"pageindex":pageindex]
        }else{
            getUserInfo = ["type": "getUserInfo","pageindex":pageindex]
        }
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fujin&m=socialchat", method: .post, parameters: getUserInfo).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "[]" {
                    self.fujin_ScrollBottom = true
                    return
                }
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                    for index in 0..<jsonModel.count{
                        self.userID.append(jsonModel[index].id)
                        self.userPortrait.append(jsonModel[index].portrait ?? "")
                        self.userNickName.append(jsonModel[index].nickname ?? "未知")
                        self.userAge.append(jsonModel[index].age ?? "未知")
                        self.userGender.append(jsonModel[index].gender ?? "未知")
                        self.userProperty.append(jsonModel[index].property ?? "未知")
                        self.userDistance.append(jsonModel[index].location ?? "未知")
                        self.userRegion.append(jsonModel[index].region ?? "未知")
                        self.userVIP.append(jsonModel[index].vip ?? "未知")
                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                        self.dataList_fujin.append(cell)
                    }
                    self.dataList = self.dataList_fujin
                    self.shenBianTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
}





extension Main1ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableViewCellShenbian
        
        cell.setData(data: oneOfList)
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataList.count - 1 == indexPath.row {
            print("身边到底了")
            
            if tuijian_fujin == "tuijian" && tuijian_ScrollBottom == false{
                tuijian_pageindex = tuijian_pageindex + 1
                tuijianPage(pageindex: tuijian_pageindex)
            }else if tuijian_fujin == "fujin" && fujin_ScrollBottom == false{
                fujin_pageindex = fujin_pageindex + 1
                fujinPage(pageindex: fujin_pageindex)
            }
        }
    }
}


extension Main1ViewController:FSPagerViewDataSource,FSPagerViewDelegate{
    
    // MARK:- FSPagerViewDataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageArr.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        //cell.imageView?.image = self.imageArr[index]
        cell.imageView?.sd_setImage(with: URL(string: self.imageArr[index]), placeholderImage: UIImage(named: "placeholder.png"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = imageNameArr[index]
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        print("点了我\(self.imageUrl[index])")
        if  self.imageUrl[index] != "" {
            let sb = UIStoryboard(name: "Personal", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SliderWebview") as! SliderWebviewViewController
            vc.url = self.imageUrl[index]
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        
    }
    
}




