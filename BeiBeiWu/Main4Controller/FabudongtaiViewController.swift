//
//  FabudongtaiViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/11.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
class FabudongtaiViewController: UIViewController {
    
    var dongtaiWord = ""
    var dongtaiPicture:String?
    var dongtaiShare = "是"

    @IBOutlet weak var dongtaiWord_text: UITextField!
    
    @IBOutlet weak var dongtaiPicture_image: UIImageView!
    
    @IBAction func dongtaiShared_segment(_ sender: UISegmentedControl) {
        dongtaiShare = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    
    @IBAction func dongtaiRelease(_ sender: UIButton) {
        
        
        if dongtaiPicture_image.image == UIImage(named: "plus.png"){
            self.view.makeToast("请选择图片")
            return
        }
        
        
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let userNickName = userInfo.string(forKey: "userNickName")
        let userPortrait = userInfo.string(forKey: "userPortrait")
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        
        let imageURL = URL(fileURLWithPath: filePath)
        
        dongtaiWord = dongtaiWord_text.text!
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(userID!.data(using: String.Encoding.utf8)!, withName: "userID")
            multipartFormData.append(userNickName!.data(using: String.Encoding.utf8)!, withName: "userNickname")
            multipartFormData.append(userPortrait!.data(using: String.Encoding.utf8)!, withName: "userPortrait")
            multipartFormData.append(self.dongtaiWord.data(using: String.Encoding.utf8)!, withName: "dongtaiWord")
            multipartFormData.append(self.dongtaiShare.data(using: String.Encoding.utf8)!, withName: "dongtaiShare")
            multipartFormData.append(imageURL, withName: "dongtaiImage", fileName: "portrait.jpg", mimeType: "image/*")
        }, to: "https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fabudongtai&m=socialchat",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                        print("Data: \(utf8Text)")
                        //关闭当前页
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Dongtai") as! Main4ViewController
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                        self.navigationController?.pushViewController(vc, animated: true)
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

        // 图片点击事件
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imAction))
        dongtaiPicture_image.addGestureRecognizer(imgClick)
        dongtaiPicture_image.isUserInteractionEnabled = true
        
        
        // Do any additional setup after loading the view.
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
        //ipad必须加上下面两个属性
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


extension FabudongtaiViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dongtaiPicture_image.image = image
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
