//
//  BlackListViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct BlackListStruct: Codable {
    let id: String
    let nickname: String
    let portrait: String
    let age: String
    let gender:String
    let region:String
    let property:String
}
class BlackListViewController: UIViewController {

    @IBOutlet weak var blacklistTableView: UITableView!
    
    var userID:String?
    var dataList:[BlackListData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = UserDefaults()
        userID = userInfo.string(forKey: "userID")
        
        let parameters: Parameters = ["myid": userID!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=getblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([BlackListStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                    
                        let cell = BlackListData(id:jsonModel[index].id,nickname: jsonModel[index].nickname,portrait: jsonModel[index].portrait,age: jsonModel[index].age,gender: jsonModel[index].gender,region: jsonModel[index].region,property: jsonModel[index].property)
                        self.dataList.append(cell)
                    }
                    self.blacklistTableView.reloadData()
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

extension BlackListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "blackListCell") as! BlackListTableViewCell
        
        cell.setData(data: oneOfList)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //不同的StoryBoard下
        let sb = UIStoryboard(name: "Personal", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
        vc.userID = dataList[indexPath.row].id
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
        
        
    }

    
}


extension BlackListViewController:BlackListTableViewCellDelegate{
    func delete(yourid: String) {
        //删除黑名单
        print("删除黑名单")
        let parameters: Parameters = ["myid": userID!,"yourid":yourid]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=deleteblacklist&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                self.dataList.removeAll()
                self.viewDidLoad()
            }
        }
    }
    
}
