//
//  ResetPersonalInfoViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/14.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class ResetPersonalInfoViewController: UIViewController {
    @IBAction func portraitSet(_ sender: Any) {
        //同一个StoryBoard下
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "头像设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nameSet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "昵称设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ageSet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "年龄设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func genderSet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "性别设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func propertySet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "属性设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func regionSet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "地区设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signatureSet(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! ResetViewController
        vc.titleType = "签名设置"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
