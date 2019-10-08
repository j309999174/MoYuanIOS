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
    
    
    @IBOutlet weak var agepickview: UIPickerView!
    @IBOutlet weak var regionpickview: UIPickerView!
    
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
    
    var ageArray:[String] = ["不限","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"]
    var countriesarray:[String] = Array()
    var states:[[市]] = Array()
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
        
        let path = Bundle.main.path(forResource: "addr_china_selected", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            let data = try Data(contentsOf: url)
            let country = try? JSONDecoder().decode(Country.self, from: data)
            for index in 0..<country!.城市代码.count{
                countriesarray.append(country!.城市代码[index].省)
                states.append(country!.城市代码[index].市)
            }
        } catch let error as Error? {
            print("读取本地数据出现错误!",error ?? "")
        }
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
                    self.regionpickview.isUserInteractionEnabled = false
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


extension SousuoViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == agepickview {
            return 1
        }
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agepickview {
            return ageArray.count
        }
        if component == 0 {
            return countriesarray.count
        }
        return states[pickerView.selectedRow(inComponent: 0)].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agepickview {
            return ageArray[row]
        }
        if component == 0 {
            return countriesarray[row]
        }
        return states[pickerView.selectedRow(inComponent: 0)][row].市名
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == agepickview {
            userAge.text = ageArray[row]
        }else{
            if component == 0 {
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                let statescity = states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
                if statescity == "不限"{
                    userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)]
                }else{
                    userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)] + "-" + states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
                }
                print("\(countriesarray[pickerView.selectedRow(inComponent: 0)])")
            }else{
                let statescity = states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
                if statescity == "不限"{
                    userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)]
                }else{
                    userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)] + "-" + states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
                }
                print("\(states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名)")
            }
        }
    }
}
