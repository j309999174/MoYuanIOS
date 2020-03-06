//
//  SomeonesluntanViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/11.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog                              
class SomeonesluntanViewController: UIViewController {
    var dataList:[LuntanData] = []
    var personid:String?
    var userID:String?
    @IBOutlet weak var someoneslluntanTableView: UITableView!
    
    var isopen:[Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人发帖"
        //获取帖子数据
        if personid == nil {
            let userInfo = UserDefaults()
            userID = userInfo.string(forKey: "userID")
        }else{
            userID = personid
        }
        let getPost: Parameters = ["authid": userID!,"pageindex":1]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=someonesluntan&m=socialchat", method: .post, parameters: getPost).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([LuntanStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = LuntanData(id: jsonModel[index].id, plateid: jsonModel[index].plateid, platename: jsonModel[index].platename, authid: jsonModel[index].authid, authnickname: jsonModel[index].authnickname, authportrait: jsonModel[index].authportrait, posttip: jsonModel[index].posttip ?? "", posttitle: jsonModel[index].posttitle, posttext: jsonModel[index].posttext ?? "", postpicture: jsonModel[index].postpicture ?? "", like: jsonModel[index].like ?? "", favorite: jsonModel[index].favorite ?? "", time: jsonModel[index].time,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?")
                        self.dataList.append(cell)
                        self.isopen.append(false)
                    }
                    self.someoneslluntanTableView.reloadData()
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
        // Do any additional setup after loading the view.
    }
    
    var post_ScrollBottom = false
    var pageIndex = 1
    func initPost(pageindex:Int){
        //获取帖子数据
        let getPost: Parameters = ["authid": userID!,"pageindex":pageindex]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=someonesluntan&m=socialchat", method: .post, parameters: getPost).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([LuntanStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = LuntanData(id: jsonModel[index].id, plateid: jsonModel[index].plateid, platename: jsonModel[index].platename, authid: jsonModel[index].authid, authnickname: jsonModel[index].authnickname, authportrait: jsonModel[index].authportrait, posttip: jsonModel[index].posttip ?? "", posttitle: jsonModel[index].posttitle, posttext: jsonModel[index].posttext ?? "", postpicture: jsonModel[index].postpicture ?? "", like: jsonModel[index].like ?? "", favorite: jsonModel[index].favorite ?? "", time: jsonModel[index].time,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?")
                        self.dataList.append(cell)
                        self.isopen.append(false)
                    }
                    self.someoneslluntanTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
                }
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    self.post_ScrollBottom = true
                    return
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

}

extension SomeonesluntanViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = LuntanData(indexPath:indexPath,id: dataList[indexPath.row].id, plateid: dataList[indexPath.row].plateid, platename: dataList[indexPath.row].platename, authid: dataList[indexPath.row].authid, authnickname: dataList[indexPath.row].authnickname, authportrait: dataList[indexPath.row].authportrait, posttip: dataList[indexPath.row].posttip ?? "", posttitle: dataList[indexPath.row].posttitle!, posttext: dataList[indexPath.row].posttext ?? "", postpicture: dataList[indexPath.row].postpicture ?? "", like: dataList[indexPath.row].like ?? "", favorite: dataList[indexPath.row].favorite ?? "", time: dataList[indexPath.row].time!,age: dataList[indexPath.row].age  ?? "?",gender: dataList[indexPath.row].gender  ?? "?",region: dataList[indexPath.row].region  ?? "?",property: dataList[indexPath.row].property ?? "?")
        let oneOfList1 = dataList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "someonesluntanCell") as! LuntanTableViewCell
        if oneOfList.posttext?.count ?? 0 > 50 && isopen[indexPath.row] == false {
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
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("行按钮")
        print(indexPath.row)
//        if isopen[indexPath.row] == false {
//            isopen[indexPath.row] = true
//        }else{
//            isopen[indexPath.row] = false
//        }
//        someoneslluntanTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        //同一个StoryBoard下
//        let sb = UIStoryboard(name: "Main4", bundle:nil)
//        let vc = sb.instantiateViewController(withIdentifier: "PostlistView") as! PostlistViewController
//        //vc.hidesBottomBarWhenPushed = true
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
//        self.show(vc, sender: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataList.count - 1 == indexPath.row && post_ScrollBottom == false {
            print("到底了")
            pageIndex = pageIndex + 1
            initPost(pageindex: pageIndex)
        }
    }
    
}


extension SomeonesluntanViewController:LuntanTableViewCellDelegate{
    func detail_content(indexPath: IndexPath) {
        print("详情按钮")
        print(indexPath.row)
        if isopen[indexPath.row] == false {
            isopen[indexPath.row] = true
        }else{
            isopen[indexPath.row] = false
        }
        someoneslluntanTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
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
                likebtn.setTitle("赞:\(utf8Text)👍", for: UIControl.State.normal)
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

