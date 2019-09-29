//
//  LuntanViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/10.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import FSPagerView
import MarqueeLabel
import PopupDialog

struct GonggaoStruct:Codable {
    let id:String
    let noticeinfo:String
}

struct LuntanStruct: Codable {
    let id:String
    let plateid:String
    let platename:String
    let authid: String
    let authnickname:String
    let authportrait:String
    let posttip:String?
    let posttitle:String
    let posttext:String?
    let postpicture:String?
    let like:String?
    let favorite:String?
    let time:String
    
    let age:String?
    let gender:String?
    let region:String?
    let property:String?
}

class LuntanViewController: UIViewController {
    @IBAction func guangchangDongtai(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            //同一个StoryBoard下
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Dongtai") as! Main4ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var plate_segment: UISegmentedControl!
    @IBAction func plateMenu(_ sender: UISegmentedControl) {
        subNav = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        post_ScrollBottom = false
        pageIndex = 1
        if subNav == "大圈" {
            initViptime()
        }else{
            switch self.subNav {
            case "首页":
                if imageArr_1.count > 0 {
                    imageArr = imageArr_1
                    imageNameArr = imageNameArr_1
                    imageUrl = imageUrl_1
                    self.pagerView.reloadData()
                }else{
                    initSlider()
                }
                break
            case "自拍":
                if imageArr_2.count > 0 {
                    imageArr = imageArr_2
                    imageNameArr = imageNameArr_2
                    imageUrl = imageUrl_2
                    self.pagerView.reloadData()
                }else{
                    initSlider()
                }
                break
            case "真实":
                if imageArr_3.count > 0 {
                    imageArr = imageArr_3
                    imageNameArr = imageNameArr_3
                    imageUrl = imageUrl_3
                    self.pagerView.reloadData()
                }else{
                    initSlider()
                }
                break
            case "情感":
                if imageArr_4.count > 0 {
                    imageArr = imageArr_4
                    imageNameArr = imageNameArr_4
                    imageUrl = imageUrl_4
                    self.pagerView.reloadData()
                }else{
                    initSlider()
                }
                break
            case "大圈":
                if imageArr_5.count > 0 {
                    imageArr = imageArr_5
                    imageNameArr = imageNameArr_5
                    imageUrl = imageUrl_5
                    self.pagerView.reloadData()
                }else{
                    initSlider()
                }
                break
            default:
                break
            }
            dataList_original.removeAll()
            dataList.removeAll()
        
            initPost(pageindex: 1)
        }
        
    }
    @IBOutlet weak var luntanTableView: UITableView!
    @IBOutlet weak var marqueeLabel: MarqueeLabel!
    
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
    var imageArr = [String]()
    var imageNameArr = [String]()
    var imageUrl = [String]()
    var imageArr_1 = [String]()
    var imageNameArr_1 = [String]()
    var imageUrl_1 = [String]()
    var imageArr_2 = [String]()
    var imageNameArr_2 = [String]()
    var imageUrl_2 = [String]()
    var imageArr_3 = [String]()
    var imageNameArr_3 = [String]()
    var imageUrl_3 = [String]()
    var imageArr_4 = [String]()
    var imageNameArr_4 = [String]()
    var imageUrl_4 = [String]()
    var imageArr_5 = [String]()
    var imageNameArr_5 = [String]()
    var imageUrl_5 = [String]()
    

    var subNav = "首页"
    var dataList:[LuntanData] = []
    var dataList_original:[LuntanData] = []
    var gonggao = ""
    var isopen:[Bool] = []
    var post_full_text = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        print("未读信息数\(String(describing: RCIMClient.shared()?.getTotalUnreadCount()))")
        if RCIMClient.shared()?.getTotalUnreadCount() == 0 {
            self.tabBarController?.tabBar.items![1].badgeValue = nil
        }else{
            self.tabBarController?.tabBar.items![1].badgeValue = String(Int((RCIMClient.shared()?.getTotalUnreadCount())!))
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        
        let font_normal = UIFont.systemFont(ofSize: 20)
        let font_selected = UIFont.systemFont(ofSize: 25)
        plate_segment.setTitleTextAttributes([NSAttributedString.Key.font:font_normal], for: .normal)
        plate_segment.setTitleTextAttributes([NSAttributedString.Key.font:font_selected], for: .selected)
        //删除文件
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath1 = "\(rootPath)/pickedimage1.jpg"
        let filePath2 = "\(rootPath)/pickedimage2.jpg"
        let filePath3 = "\(rootPath)/pickedimage3.jpg"
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: filePath1)
            try fileManager.removeItem(atPath: filePath2)
            try fileManager.removeItem(atPath: filePath3)
            print("Success to remove file.")
        }catch{
            print("Failed to remove file.")
        }
        //公告
        let parameters: Parameters = ["type": "getGonggao"]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=luntan&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([GonggaoStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        self.gonggao += jsonModel[index].noticeinfo
                    }
                    self.marqueeLabel.text = self.gonggao
                    self.marqueeLabel.reloadInputViews()
                } catch {
                    print("解析 JSON 失败")
                }
            }
        }
        
        
        initSlider()
        initPost(pageindex: 1)
        // Do any additional setup after loading the view.
    }
    
    
    
    func initSlider(){
        //获取幻灯片数据
        let getSlide: Parameters = ["type": "getSlide","slidesort":subNav]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=luntan&m=socialchat", method: .post, parameters: getSlide).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([SliderImages].self, from: data)
                    for index in 0..<jsonModel.count{
                        //let data = try Data(contentsOf: URL(string: jsonModel[index].slidepicture)!)
                        //self.imageArr.append(UIImage(data: data)!)
                        self.imageNameArr.append(jsonModel[index].slidename)
                        self.imageArr.append(jsonModel[index].slidepicture)
                        self.imageUrl.append(jsonModel[index].slideurl ?? "")
                        switch self.subNav {
                        case "首页":
                            self.imageArr_1.append(jsonModel[index].slidepicture)
                            self.imageNameArr_1.append(jsonModel[index].slidename)
                            self.imageUrl_1.append(jsonModel[index].slideurl ?? "")
                            break
                        case "自拍":
                            self.imageArr_2.append(jsonModel[index].slidepicture)
                            self.imageNameArr_2.append(jsonModel[index].slidename)
                            self.imageUrl_2.append(jsonModel[index].slideurl ?? "")
                            break
                        case "真实":
                            self.imageArr_3.append(jsonModel[index].slidepicture)
                            self.imageNameArr_3.append(jsonModel[index].slidename)
                            self.imageUrl_3.append(jsonModel[index].slideurl ?? "")
                            break
                        case "情感":
                            self.imageArr_4.append(jsonModel[index].slidepicture)
                            self.imageNameArr_4.append(jsonModel[index].slidename)
                            self.imageUrl_4.append(jsonModel[index].slideurl ?? "")
                            break
                        case "大圈":
                            self.imageArr_5.append(jsonModel[index].slidepicture)
                            self.imageNameArr_5.append(jsonModel[index].slidename)
                            self.imageUrl_5.append(jsonModel[index].slideurl ?? "")
                            break
                        default:
                            break
                        }
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
        
    }
    
    var post_ScrollBottom = false
    var pageIndex = 1
    func initPost(pageindex:Int){
        //获取帖子数据
        let getPost: Parameters = ["type": "getPostlist","platename":subNav,"pageindex":pageindex]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=luntan&m=socialchat", method: .post, parameters: getPost).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([LuntanStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = LuntanData(id: jsonModel[index].id, plateid: jsonModel[index].plateid, platename: jsonModel[index].platename, authid: jsonModel[index].authid, authnickname: jsonModel[index].authnickname, authportrait: jsonModel[index].authportrait, posttip: jsonModel[index].posttip ?? "", posttitle: jsonModel[index].posttitle, posttext: jsonModel[index].posttext ?? "", postpicture: jsonModel[index].postpicture ?? "", like: jsonModel[index].like ?? "", favorite: jsonModel[index].favorite ?? "", time: jsonModel[index].time,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?")
                        self.dataList_original.append(cell)
                        self.isopen.append(false)
                    }
                    self.dataList = self.dataList_original
                    self.luntanTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    if utf8Text == "[]" {
                        self.post_ScrollBottom = true
                        return
                    }
                }
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
    func initViptime(){
        //获取会员时间
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let parameters: Parameters = ["id": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=viptimeinsousuo&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "会员已到期"{
                    self.view.makeToast("此版块需要开通会员")
                }else{
                    self.dataList.removeAll()
                    self.imageArr.removeAll()
                    self.imageNameArr.removeAll()
                    self.imageUrl.removeAll()
                    self.initSlider()
                    self.initPost(pageindex: 1)
                }
            }
        }
    }
}



extension LuntanViewController:FSPagerViewDataSource,FSPagerViewDelegate{
    
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


extension LuntanViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        
        let oneOfList1 = dataList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "luntanCell") as! LuntanTableViewCell
        if oneOfList1.posttext?.count ?? 0 > 50 && isopen[indexPath.row] == false {
            let oneOfList = LuntanData(id: dataList[indexPath.row].id, plateid: dataList[indexPath.row].plateid, platename: dataList[indexPath.row].platename, authid: dataList[indexPath.row].authid, authnickname: dataList[indexPath.row].authnickname, authportrait: dataList[indexPath.row].authportrait, posttip: dataList[indexPath.row].posttip ?? "", posttitle: dataList[indexPath.row].posttitle!, posttext: dataList[indexPath.row].posttext ?? "", postpicture: dataList[indexPath.row].postpicture ?? "", like: dataList[indexPath.row].like ?? "", favorite: dataList[indexPath.row].favorite ?? "", time: dataList[indexPath.row].time!,age: dataList[indexPath.row].age  ?? "?",gender: dataList[indexPath.row].gender  ?? "?",region: dataList[indexPath.row].region  ?? "?",property: dataList[indexPath.row].property ?? "?")
            print("省了\(String(describing: oneOfList.posttext))")
            oneOfList.posttext = String((oneOfList.posttext?.prefix(50) ?? "")) + "......"
            cell.delegate = self
            cell.setData(data: oneOfList)
        }else{
            print("不省略\(String(describing: oneOfList1.posttext))")
            print("全文\(String(describing: dataList[indexPath.row].posttext))")
            cell.delegate = self
            cell.setData(data: oneOfList1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isopen[indexPath.row] == false {
            isopen[indexPath.row] = true
        }else{
            isopen[indexPath.row] = false
        }
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        //同一个StoryBoard下
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostlistView") as! PostlistViewController
//        vc.id = dataList[indexPath.row].id
//        vc.plateid = dataList[indexPath.row].plateid
//        vc.platename = dataList[indexPath.row].platename
//        vc.authid = dataList[indexPath.row].authid
//        vc.authnickname = dataList[indexPath.row].authnickname
//        vc.authportrait = dataList[indexPath.row].authportrait
//        vc.posttip = dataList[indexPath.row].posttip
//        vc.posttitle = dataList[indexPath.row].posttitle
//        vc.posttext = dataList[indexPath.row].posttext
//        vc.postpicture = dataList[indexPath.row].postpicture
//        vc.like = dataList[indexPath.row].like
//        vc.favorite = dataList[indexPath.row].favorite
//        vc.time = dataList[indexPath.row].time
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataList.count - 1 == indexPath.row && post_ScrollBottom == false {
            print("到底了")
            pageIndex = pageIndex + 1
            initPost(pageindex: pageIndex)
        }
    }
}


extension LuntanViewController:LuntanTableViewCellDelegate{

    
    func detail_content(posttext: UILabel!, post_detail_text: String!,sender:UIButton) {
//        print("全文")
//                if post_detail_text?.count ?? 0 > 50 {
//                    posttext.text = String((post_detail_text?.prefix(50))!) + "......"
//                    sender.isHidden = false
//                }else{
//                    posttext.text = post_detail_text
//                    sender.isHidden = true
//                    
//                }
//        posttext.text = post_detail_text
//        sender.isHidden = true
        
        
    }
    
    func pictureClick(pictureurl: String) {
        do {
            let pictureData = try Data(contentsOf: URL(string: pictureurl)!)
            let image = UIImage(data: pictureData)
            // Create the dialog
            let popup = PopupDialog(title: nil, message: nil, image: image)
            // Create buttons
            let buttonOne = CancelButton(title: "取消") {
                print("You canceled the car dialog.")
            }
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }catch let err{
            print(err)
        }
    }
    
    func like(postid: String,likebtn: UIButton) {
        print("论坛喜欢")
        let parameters: Parameters = ["postid": postid]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=luntanlike&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                likebtn.setTitle("赞:\(utf8Text)", for: UIControl.State.normal)
            }
        }
    }
    func personpage(userID:String){
        print("论坛个人")
        //跳转个人
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = userID
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
    func threepoints(postid: String, userID: String) {
        print("论坛三点")
        let userInfo = UserDefaults()
        let myid = userInfo.string(forKey: "userID")
        let actionSheet = UIAlertController(title: "举报与拉黑", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "举报", style: .default, handler: {(action: UIAlertAction) in
            let sb = UIStoryboard(name: "Main4", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "InformReason") as! InformReasonViewController
            vc.type = "post"
            vc.itemid = postid
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "拉黑", style: .default, handler: {(action: UIAlertAction) in
            print("开始拉黑")
            let parameters: Parameters = ["myid":myid!,"yourid":userID]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=addblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    self.view.makeToast("拉黑成功")
                }
            }
        }))
        
        if myid! == userID {
            actionSheet.addAction(UIAlertAction(title: "删除", style: .default, handler: {(action: UIAlertAction) in
                print("开始删除")
                let parameters: Parameters = ["postid":postid]
                Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=deletepost&m=socialchat", method: .post, parameters: parameters).response { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Error: \(String(describing: response.error))")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        self.view.makeToast("删除已提交")
                    }
                }
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController!.sourceView = self.view
            actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
        }
        self.present(actionSheet, animated: true, completion: nil)
        
    }
}
