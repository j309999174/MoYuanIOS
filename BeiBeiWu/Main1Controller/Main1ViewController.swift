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
    let location: String?
}


class Main1ViewController: UIViewController {
   
    var imageArr = [UIImage]()
    var imageNameArr = [String]()


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
        //判断是否登录
        
        if UserDefaults().string(forKey: "userID") == nil{
            let sb = UIStoryboard(name: "Main1", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            self.present(vc, animated: true, completion: nil)
            
        }else{
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

    }
}





extension Main1ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableViewCellShenbian
        
        cell.setData(shenBianData: oneOfList)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
       
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
       
    }
}
