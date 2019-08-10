//
//  UserSetViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/25.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire

class UserSetViewController: UIViewController {

    var userPhone: String = ""
    var userPassword: String = ""
    
    var userGenderString = "男"
    var userPropertyString = "Z"
    var userNickNameString = ""
    var userAgeString = ""
    var userRegionString = ""
    var userSignatureString = ""
    var userReferralString = ""
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPortrait.image = UIImage(named: "plus.png")
        // Do any additional setup after loading the view.
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imAction))
        userPortrait.addGestureRecognizer(imgClick)
        //开启 isUserInteractionEnabled 手势否则点击事件会没有反应
        userPortrait.isUserInteractionEnabled = true

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
        let imageData = image.jpegData(compressionQuality: 0.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
