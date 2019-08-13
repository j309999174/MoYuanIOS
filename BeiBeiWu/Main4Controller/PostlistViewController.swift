//
//  PostlistViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

struct PostlistStruct:Codable {
    let id:String
    let postid:String
    let posttitle:String
    let authid: String
    let authnickname:String
    let authportrait:String
    let followtext:String?
    let followpicture:String?
    let like:String?
    let favorite:String?
    let time:String
}




class PostlistViewController: UIViewController {
    var id:String?
    var plateid:String?
    var platename:String?
    var authid: String?
    var authnickname:String?
    var authportrait:String?
    var posttip:String?
    var posttitle:String?
    var posttext:String?
    var postpicture:String?
    var like:String?
    var favorite:String?
    var time:String?
    
    var dataList:[PostlistData] = []
    @IBOutlet weak var postlistTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        postlistTableView.reloadData()
        
        initPostlist()
        // Do any additional setup after loading the view.
    }
    
    func initPostlist(){
        let parameters: Parameters = ["type": "getDataFollowlist","postid": id!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=postdetail&m=socialchat", method: .post, parameters: parameters).response { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([PostlistStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = PostlistData(authid: jsonModel[index].authid, authnickname: jsonModel[index].authnickname, authportrait: jsonModel[index].authportrait, followtext: jsonModel[index].followtext ?? "", followpicture: jsonModel[index].followpicture ?? "", time: jsonModel[index].time)
                        self.dataList.append(cell)
                    }
                    print("ccccc")
                    self.postlistTableView.reloadData()
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

extension PostlistViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            print("aaaaaa")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Posthead") as! PostheadTableViewCell
            cell.setData(authid: self.authid!, posttitle: self.posttitle!, authportrait: self.authportrait!, authnickname: self.authnickname!, posttext: self.posttext ?? "", time: self.time!, postpicture: self.postpicture ?? "")
            return cell
        }else{
            let oneOfList = dataList[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Postlist") as! PostlistTableViewCell
            cell.setData(data: oneOfList,louceng: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            //不同的StoryBoard下
            let sb = UIStoryboard(name: "Personal", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
            vc.userID = self.authid
            self.present(vc, animated: true, completion: nil)
        }else{
            //不同的StoryBoard下
            let sb = UIStoryboard(name: "Personal", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "Personal") as! PersonalViewController
            vc.userID = dataList[indexPath.row - 1].authid
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
}
