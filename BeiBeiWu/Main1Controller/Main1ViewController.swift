//
//  Main1ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct SliderImages: Codable {
    let id: String
    let slidesort: String
    let slidename: String
    let slidepicture:String
    let slideurl:String?
}


class Main1ViewController: UIViewController {

    //幻灯片
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    var imageArr = [UIImage]()
    var timer = Timer()
    var counter = 0
    
    //列表
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
            let parameters: Parameters = ["type": "getSlide"]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=tuijian&m=socialchat", method: .post, parameters: parameters).response { response in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let jsonModel = try decoder.decode([SliderImages].self, from: data)
                        for index in 0..<jsonModel.count{
                            let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                            self.imageArr.removeAll()
                            self.imageArr.append(UIImage(data: data)!)
                            self.pageView.numberOfPages = self.imageArr.count
                            self.pageView.currentPage = 0
                            DispatchQueue.main.async {
                                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                            }
                        }
                        
                    } catch {
                        print("解析 JSON 失败")
                    }
                }
            }
        }
        
    }
    
    
    @objc func changeImage(){
        if counter < imageArr.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
            pageView.currentPage = counter
        }else{
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
    
}


extension Main1ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imageArr[indexPath.row]
        }else if let ab = cell.viewWithTag(222) as? UIPageControl{
            ab.currentPage = indexPath.row
        }
        return cell
    }
    
}

extension Main1ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
