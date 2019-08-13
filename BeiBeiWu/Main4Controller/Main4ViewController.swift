//
//  Main4ViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import FSPagerView


struct DongtaiStruct: Codable {
    let id:String
    let myid:String
    let mynickname:String
    let myportrait:String
    let context:String
    let picture:String
    let video:String?
    let share:String
    let like:String
    let time:String
}




class Main4ViewController: UIViewController {
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
    
    @IBAction func guangchangDongtai(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            //同一个StoryBoard下
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Luntan") as! LuntanViewController
            self.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var dongtaiTableView: UITableView!
    
    @IBAction func dongtaiRelease(_ sender: Any) {
        
    }
    
    
    var imageArr = [UIImage]()
    var imageNameArr = [String]()
    var dataList:[DongtaiData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //删除文件
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: filePath)
            print("Success to remove file.")
        }catch{
            print("Failed to remove file.")
        }
        //获取幻灯片数据
        let getSlide: Parameters = ["type": "getSlide"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=guangchang&m=socialchat", method: .post, parameters: getSlide).response { response in
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
                                    print("Request: \(String(describing: response.request))")
                                    print("Response: \(String(describing: response.response))")
                                    print("Error: \(String(describing: response.error))")
                
                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        print("Data: \(utf8Text)")
                                    }
            }
        }
        
        
        
        let parameters: Parameters = ["type": "getDongtai"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=guangchang&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([DongtaiStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = DongtaiData(circleid: jsonModel[index].id,userID: jsonModel[index].myid, userPortrait:jsonModel[index].myportrait, userNickName: jsonModel[index].mynickname, dongtaiWord: jsonModel[index].context, dongtaiPicture: jsonModel[index].picture, dongtaiTime: jsonModel[index].time, dongtaiLike: jsonModel[index].like)
                        self.dataList.append(cell)
                    }
                    self.dongtaiTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
            }
            
        }
        
        // Do any additional setup after loading the view.
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


extension Main4ViewController:FSPagerViewDataSource,FSPagerViewDelegate{
    
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


extension Main4ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dongtaiCell") as! DongtaiTableViewCell
        
        cell.setData(data: oneOfList)
        cell.delegate = self
        cell.dongtaiWord.numberOfLines = 0
        return cell
    }
}


extension Main4ViewController:DongtaiTableViewCellDelegate{
    func like(circleid: String,likebtn:UIButton) {
        let parameters: Parameters = ["circleid": circleid]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=guangchanglike&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                likebtn.setTitle("赞:\(utf8Text)", for: UIControl.State.normal)
            }
        }
    }
}
