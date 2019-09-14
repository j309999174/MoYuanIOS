//
//  UserSetViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
// MARK: - Country
struct Country: Codable {
    let 城市代码: [城市代码]
}
// MARK: - 城市代码
struct 城市代码: Codable {
    let 省: String
    let 市: [市]
}
// MARK: - 市
struct 市: Codable {
    let 市名, 编码: String
}

class UserSetViewController: UIViewController {
    
    var logtype: String = ""
    var openid: String = ""
    
    var userPhone: String = ""
    var userPassword: String = ""
    
    var userGenderString = "男"
    var userPropertyString = "Z"
    var userNickNameString = ""
    var userAgeString = ""
    var userRegionString = ""
    var userSignatureString = ""
    var userReferralString = ""
    
    @IBOutlet weak var agepickview: UIPickerView!
    @IBOutlet weak var citypickview: UIPickerView!
    
    @IBOutlet weak var userPortrait: UIImageView!
    
    @IBOutlet weak var userNickName: UITextField!
    
    @IBAction func userGender(_ sender: UISegmentedControl) {
        userGenderString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBOutlet weak var userAge: UITextField!
    
    @IBOutlet weak var userRegion: UITextField!
    
    @IBOutlet weak var userSignature: UITextField!
    
    
    @IBAction func userProperty(_ sender: UISegmentedControl) {
        userPropertyString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    
    @IBOutlet weak var userReferral: UITextField!
    
    
    @IBAction func submit(_ sender: Any) {
        if logtype == "1" {
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        
        let imageURL = URL(fileURLWithPath: filePath)
        
        userNickNameString = self.userNickName.text!
        userAgeString = self.userAge.text!
        userRegionString = self.userRegion.text!
        userSignatureString = self.userSignature.text!
        userReferralString = self.userReferral.text!
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(self.userPhone.data(using: String.Encoding.utf8)!, withName: "userAccount")
            multipartFormData.append(self.userPassword.data(using: String.Encoding.utf8)!, withName: "userPassword")
            multipartFormData.append(self.userNickNameString.data(using: String.Encoding.utf8)!, withName: "userNickname")
            multipartFormData.append(self.userAgeString.data(using: String.Encoding.utf8)!, withName: "userAge")
            multipartFormData.append(self.userGenderString.data(using: String.Encoding.utf8)!, withName: "userGender")
            multipartFormData.append(self.userPropertyString.data(using: String.Encoding.utf8)!, withName: "userProperty")
            multipartFormData.append(self.userRegionString.data(using: String.Encoding.utf8)!, withName: "userRegion")
            multipartFormData.append(self.userSignatureString.data(using: String.Encoding.utf8)!, withName: "userSignature")
            multipartFormData.append(self.userReferralString.data(using: String.Encoding.utf8)!, withName: "referral")
            multipartFormData.append(imageURL, withName: "userPortrait", fileName: "portrait.jpg", mimeType: "image/*")
        }, to: "https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=signup&m=socialchat",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
            upload.responseJSON { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                    print("Data: \(utf8Text)")
                    //回到登陆
                    let sb = UIStoryboard(name: "Main1", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
                    self.present(vc, animated: true, completion: nil)
                  }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
          }
        )
        }else{
            print("进入微信注册")
            userAgeString = self.userAge.text!
            userRegionString = self.userRegion.text!
            userSignatureString = self.userSignature.text!
            userReferralString = self.userReferral.text!
            print(openid+userAgeString+userRegionString+userSignatureString+userReferralString)
            let parameters: Parameters = ["openid": openid,"userAge": userAgeString,"userGender": userGenderString,"userProperty": userPropertyString,"userRegion": userRegionString,"userSignature": userSignatureString,"referral": userReferralString]
            Alamofire.request("https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=signupwx&m=socialchat", method: .post, parameters: parameters).response { response in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShenBian") as! Main1ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    var ageArray:[String] = ["15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50"]
    var countriesarray:[String] = Array()
    var states:[[市]] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        //删除文件
        removePictureFile()
        //textfield图
        let userNickNameImage = UIImage(named: "nickname")!
        addLeftImageTo(txtField: userNickName, andImage: userNickNameImage)
        let userAgeImage = UIImage(named: "age")!
        addLeftImageTo(txtField: userAge, andImage: userAgeImage)
        let userRegionImage = UIImage(named: "region")!
        addLeftImageTo(txtField: userRegion, andImage: userRegionImage)
        let userSignatureImage = UIImage(named: "signature")!
        addLeftImageTo(txtField: userSignature, andImage: userSignatureImage)
        let userReferralImage = UIImage(named: "Promotion code")!
        addLeftImageTo(txtField: userReferral, andImage: userReferralImage)
        
        print("logtype=\(logtype)")
        if logtype == "2"{
            userPortrait.isHidden = true
            userNickName.isHidden = true
        }
        
        userPortrait.image = UIImage(named: "plus.png")
        // Do any additional setup after loading the view.
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imAction))
        userPortrait.addGestureRecognizer(imgClick)
        //开启 isUserInteractionEnabled 手势否则点击事件会没有反应
        userPortrait.isUserInteractionEnabled = true
        
        let path = Bundle.main.path(forResource: "addr_china", ofType: "json")
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
    
    //点击事件方法
    @objc func imAction() -> Void {
        print("图片点击事件")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "图片选择器", message: "选择图片", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "相机", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.popoverPresentationController!.sourceView = self.view
        actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    
    
    func addLeftImageTo(txtField:UITextField,andImage img:UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 30))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
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


extension UserSetViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        userPortrait.image = image
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = image.jpegData(compressionQuality: 0.1)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension UserSetViewController:UIPickerViewDelegate,UIPickerViewDataSource{
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
            userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)] + "-" + states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
            print("\(countriesarray[pickerView.selectedRow(inComponent: 0)])")
        }else{
            userRegion.text = countriesarray[pickerView.selectedRow(inComponent: 0)] + "-" + states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名
            print("\(states[pickerView.selectedRow(inComponent: 0)][pickerView.selectedRow(inComponent: 1)].市名)")
        }
        }
    }
}
