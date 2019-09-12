//
//  SawmeViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/14.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class SawmeViewController: UIViewController {
    @IBOutlet weak var sawmeTableView: UITableView!
    var dataList:[ShenBianData] = []
    
    var userID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "谁看过我"
        // Do any additional setup after loading the view.
        let userInfo = UserDefaults()
        userID = userInfo.string(forKey: "userID")
        
        getvip()
    }
    
    
    func getvip(){
        let parameters: Parameters = ["id": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=viptimeinsousuo&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                if utf8Text == "会员已到期"{
                    let actionSheet = UIAlertController(title: "查看本页需要购买会员权限哦！", message: "", preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "购买会员", style: .default, handler: {(action: UIAlertAction) in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BuyVip") as! BuyvipViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    actionSheet.popoverPresentationController!.sourceView = self.view
                    actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
                    self.present(actionSheet, animated: true, completion: nil)
                }else{
                    self.initSawme()
                }
            }
        }
    }
    
    func initSawme(){
        //获取推荐列表
        var getUserInfo: Parameters
        if let latitude = UserDefaults().string(forKey: "latitude"),let longitude = UserDefaults().string(forKey: "longitude"){
            getUserInfo = ["type": "getUserInfo","userID": UserDefaults().string(forKey: "userID")!,"latitude":latitude,"longitude":longitude]
        }else{
            getUserInfo = ["type": "getUserInfo"]
        }
        
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=sawme&m=socialchat", method: .post, parameters: getUserInfo).response { response in
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
                    self.sawmeTableView.reloadData()
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

extension SawmeViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SawmeCell") as! TableViewCellShenbian
        
        cell.setData(data: oneOfList)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = dataList[indexPath.row].userID
        self.show(vc, sender: nil)
    }
}
