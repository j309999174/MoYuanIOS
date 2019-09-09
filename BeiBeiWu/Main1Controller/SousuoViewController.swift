//
//  SousuoViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/30.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

class SousuoViewController: UIViewController {
    var userGenderString = "不限"
    var userPropertyString = "不限"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func userGender(_ sender: UISegmentedControl) {
        userGenderString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    
    @IBAction func userProperty(_ sender: UISegmentedControl) {
        userPropertyString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBOutlet weak var userAge: UITextField!
    
    @IBOutlet weak var userRegion: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SousuoResultStoryBoard") as! SousuoResultViewController
        vc.type = "condition"
        vc.userAge = userAge.text ?? ""
        vc.userRegion = userRegion.text ?? ""
        vc.userGender = userGenderString
        vc.userProperty = userPropertyString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var viptime: UILabel!
    @IBOutlet weak var property_segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textfield图
        let ageImage = UIImage(named: "age")!
        addLeftImageTo(txtField: userAge, andImage: ageImage)
        let regionImage = UIImage(named: "region")!
        addLeftImageTo(txtField: userRegion, andImage: regionImage)
        
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        initViptime()
    }
    func addLeftImageTo(txtField:UITextField,andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 30))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
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
                self.viptime.text = utf8Text
                if utf8Text == "会员已到期"{
                    self.property_segment.setEnabled(false, forSegmentAt: 0)
                    self.property_segment.setEnabled(false, forSegmentAt: 1)
                    self.property_segment.setEnabled(false, forSegmentAt: 2)
                    self.property_segment.setEnabled(false, forSegmentAt: 3)
                    self.userRegion.isUserInteractionEnabled = false
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


extension SousuoViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SousuoResultStoryBoard") as! SousuoResultViewController
        vc.type = "direct"
        vc.nameOrPhone = searchBar.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
