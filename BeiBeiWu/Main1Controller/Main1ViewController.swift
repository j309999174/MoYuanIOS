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
   
    @IBAction func menuAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tuijian_btn()
            break
        case 1:
            fujin_btn()
            break
        case 2:
        let sb = UIStoryboard(name: "Main1", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "SousuoViewIdentity") as! SousuoViewController
        //vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
            break
        default:
            break
        }
    }
    
    
    
    func tuijian_btn() {
        
        //获取幻灯片数据
        let getSlide: Parameters = ["type": "getSlide"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getSlide).response { response in
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
                        let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                        self.imageArr.append(UIImage(data: data)!)
                        self.imageNameArr.append(jsonModel[index].slidename)
                        self.imageUrl.append(jsonModel[index].slideurl ?? "")
                    }
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
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getUserInfo).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                        self.dataList.append(cell)
                    }
                    self.shenBianTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    
    func fujin_btn() {
        //获取幻灯片数据
        let getSlide: Parameters = ["type": "getSlide"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fujin&m=socialchat", method: .post, parameters: getSlide).response { response in
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
                        let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                        self.imageArr.append(UIImage(data: data)!)
                        self.imageNameArr.append(jsonModel[index].slidename)
                        self.imageUrl.append(jsonModel[index].slideurl ?? "")
                    }
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
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                            , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                        self.dataList.append(cell)
                    }
                    self.shenBianTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
    }
    
    
    
    var imageArr = [UIImage]()
    var imageNameArr = [String]()
    var imageUrl = [String]()


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
    var dataList:[ShenBianData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
        
        
        
        //判断是否登录
        if UserDefaults().string(forKey: "userID") == nil{
            let sb = UIStoryboard(name: "Main1", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            vc.hidesBottomBarWhenPushed = false
            self.show(vc, sender: nil)
            
        }else{
            Uniquelogin.compareUniqueLoginToken(view: self)
            //保存定位
            let userInfo = UserDefaults()
            if let latitude = userInfo.string(forKey: "latitude"),let longitude = userInfo.string(forKey: "longitude"),let userID = userInfo.string(forKey: "userID") {
                let parameters: Parameters = ["userID": userID,"latitude": latitude,"longitude": longitude]
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
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let jsonModel = try decoder.decode([SliderImages].self, from: data)
                        for index in 0..<jsonModel.count{
                            let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                            self.imageArr.append(UIImage(data: data)!)
                            self.imageNameArr.append(jsonModel[index].slidename)
                            self.imageUrl.append(jsonModel[index].slideurl ?? "")
                        }
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
            
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: getUserInfo).response { response in
                                    print("Request: \(String(describing: response.request))")
                                    print("Response: \(String(describing: response.response))")
                                    print("Error: \(String(describing: response.error))")
                
                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        print("Data: \(utf8Text)")
                                    }
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let jsonModel = try decoder.decode([TuiJianUserInfo].self, from: data)
                        for index in 0..<jsonModel.count{
                            let cell = ShenBianData(userID:jsonModel[index].id,userPortrait: jsonModel[index].portrait ?? "", userNickName: jsonModel[index].nickname ?? "未知", userAge: jsonModel[index].age ?? "未知", userGender: jsonModel[index].gender ?? "未知", userProperty: jsonModel[index].property ?? "未知", userDistance: jsonModel[index].location ?? "未知"
                                , userRegion: jsonModel[index].region ?? "未知", userVIP: jsonModel[index].vip ?? "普通")
                            self.dataList.append(cell)
                        }
                        self.shenBianTableView.reloadData()
                    } catch {
                        print("解析 JSON 失败")
                    }
                }
            }
            
            //角标
        }
        
        let userInfo = UserDefaults()
        let rongyunToken = userInfo.string(forKey: "rongyunToken")
        //链接融云
        RCIM.shared()?.connect(withToken: rongyunToken, success: { (ok) in
            print("融云链接成功\(ok ?? "ok")")
        }, error: { (code) in
            print("融云链接失败\(code)")
        }, tokenIncorrect: {
            print("token不对")
        })

    }
    
    
    func addLeftImageTo(txtField:UITextField,andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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
}


extension Main1ViewController:FSPagerViewDataSource,FSPagerViewDelegate{
    
    // MARK:- FSPagerViewDataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageArr.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = self.imageArr[index]
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




