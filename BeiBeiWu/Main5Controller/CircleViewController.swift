//
//  CircleViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/14.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class CircleViewController: UIViewController {
    @IBOutlet weak var dongtaiTableView: UITableView!
    var userID:String?
    var userNickName:String?
    var userPortrait:String?
    var dataList:[DongtaiData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = UserDefaults()
        userID = userInfo.string(forKey: "userID")
        userNickName = userInfo.string(forKey: "userNickName")
        userPortrait = userInfo.string(forKey: "userPortrait")!
        // Do any additional setup after loading the view.
        initDongtai()
    }
    
    func initDongtai(){
        let parameters: Parameters = ["userID": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=circle&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([DongtaiStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = DongtaiData(circleid: jsonModel[index].id,userID: jsonModel[index].myid, userPortrait:jsonModel[index].myportrait, userNickName: jsonModel[index].mynickname, dongtaiWord: jsonModel[index].context, dongtaiPicture: jsonModel[index].picture, dongtaiTime: jsonModel[index].time, dongtaiLike: jsonModel[index].like,age: jsonModel[index].age  ?? "?",gender: jsonModel[index].gender  ?? "?",region: jsonModel[index].region  ?? "?",property: jsonModel[index].property ?? "?")
                        self.dataList.append(cell)
                    }
                    self.dongtaiTableView.reloadData()
                } catch {
                    print("解析 JSON 失败")
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


extension CircleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleCell") as! DongtaiTableViewCell
        
        cell.setData(data: oneOfList)
        cell.delegate = self
        cell.dongtaiWord.numberOfLines = 0
        return cell
    }
}


extension CircleViewController:DongtaiTableViewCellDelegate{
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
    func personpage(userID: String) {
        //跳转个人
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = userID
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
    func threepoints(circleid: String, userID: String) {
        let userInfo = UserDefaults()
        let myid = userInfo.string(forKey: "userID")
        let actionSheet = UIAlertController(title: "举报与拉黑", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "举报", style: .default, handler: {(action: UIAlertAction) in
            let sb = UIStoryboard(name: "Main4", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "InformReason") as! InformReasonViewController
            vc.type = "circle"
            vc.itemid = circleid
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
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController!.sourceView = self.view
        actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
        self.present(actionSheet, animated: true, completion: nil)

    }
}
