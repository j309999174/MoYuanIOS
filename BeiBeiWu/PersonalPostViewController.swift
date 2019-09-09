//
//  PersonalPostViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/23.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class PersonalPostViewController: UIViewController {
    @IBOutlet weak var personalPostTableView: UITableView!
    
    var authid:String?
    var dataList:[LuntanData] = []
    @IBOutlet weak var luntanTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("用户id\(authid!)")
        //获取帖子数据
        let getPost: Parameters = ["authid": authid!]
        Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=someonesluntan&m=socialchat", method: .post, parameters: getPost).response { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode([LuntanStruct].self, from: data)
                    for index in 0..<jsonModel.count{
                        let cell = LuntanData(id: jsonModel[index].id, plateid: jsonModel[index].plateid, platename: jsonModel[index].platename, authid: jsonModel[index].authid, authnickname: jsonModel[index].authnickname, authportrait: jsonModel[index].authportrait, posttip: jsonModel[index].posttip ?? "", posttitle: jsonModel[index].posttitle, posttext: jsonModel[index].posttext ?? "", postpicture: jsonModel[index].postpicture ?? "", like: jsonModel[index].like ?? "", favorite: jsonModel[index].favorite ?? "", time: jsonModel[index].time)
                        self.dataList.append(cell)
                    }
                    self.personalPostTableView.reloadData()
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PersonalPostViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneOfList = dataList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalpostCell") as! LuntanTableViewCell
        
        cell.setData(data: oneOfList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //不同StoryBoard下
        let sb = UIStoryboard(name: "Main4", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "PostlistView") as! PostlistViewController
        vc.id = dataList[indexPath.row].id
        vc.plateid = dataList[indexPath.row].plateid
        vc.platename = dataList[indexPath.row].platename
        vc.authid = dataList[indexPath.row].authid
        vc.authnickname = dataList[indexPath.row].authnickname
        vc.authportrait = dataList[indexPath.row].authportrait
        vc.posttip = dataList[indexPath.row].posttip
        vc.posttitle = dataList[indexPath.row].posttitle
        vc.posttext = dataList[indexPath.row].posttext
        vc.postpicture = dataList[indexPath.row].postpicture
        vc.like = dataList[indexPath.row].like
        vc.favorite = dataList[indexPath.row].favorite
        vc.time = dataList[indexPath.row].time
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: nil)
    }
    
    
}
