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
    
    @IBOutlet weak var dongtaiPicture_image1: UIImageView!
    @IBOutlet weak var dongtaiPicture_image2: UIImageView!
    @IBOutlet weak var dongtaiPicture_image3: UIImageView!
    
    @IBAction func dongtaiShared_segment(_ sender: UISegmentedControl) {
        dongtaiShare = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    
    @IBAction func dongtaiRelease(_ sender: UIButton) {
        
        
//        if dongtaiPicture_image1.image == UIImage(named: "plus.png"){
//            self.view.makeToast("请选择图片")
//            return
//        }
        
        
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        let userNickName = userInfo.string(forKey: "userNickName")
        let userPortrait = userInfo.string(forKey: "userPortrait")
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        
        
        let fileManager = FileManager.default
        let filePath1 = "\(rootPath)/pickedimage1.jpg"
        let imageURL1 = URL(fileURLWithPath: filePath1)
        let exist1 = fileManager.fileExists(atPath: filePath1)
        let filePath2 = "\(rootPath)/pickedimage2.jpg"
        let imageURL2 = URL(fileURLWithPath: filePath2)
        let exist2 = fileManager.fileExists(atPath: filePath2)
        let filePath3 = "\(rootPath)/pickedimage3.jpg"
        let imageURL3 = URL(fileURLWithPath: filePath3)
        let exist3 = fileManager.fileExists(atPath: filePath3)
        
        
        
        dongtaiWord = dongtaiWord_text.text!
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(userID!.data(using: String.Encoding.utf8)!, withName: "userID")
            multipartFormData.append(userNickName!.data(using: String.Encoding.utf8)!, withName: "userNickname")
            multipartFormData.append(userPortrait!.data(using: String.Encoding.utf8)!, withName: "userPortrait")
            multipartFormData.append(self.dongtaiWord.data(using: String.Encoding.utf8)!, withName: "dongtaiWord")
            multipartFormData.append(self.dongtaiShare.data(using: String.Encoding.utf8)!, withName: "dongtaiShare")
            if exist1 {
                multipartFormData.append(imageURL1, withName: "dongtaiImage1", fileName: "dongtaiImage1.jpg", mimeType: "image/*")
            }
            if exist2 {
                multipartFormData.append(imageURL2, withName: "dongtaiImage2", fileName: "dongtaiImage2.jpg", mimeType: "image/*")
            }
            if exist3 {
                multipartFormData.append(imageURL3, withName: "dongtaiImage3", fileName: "dongtaiImage3.jpg", mimeType: "image/*")
            }
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
    
    var pictureIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        //删除文件
        removePictureFile()
        // 图片点击事件
        let imgClick1 = UITapGestureRecognizer(target: self, action: #selector(picture1Action))
        dongtaiPicture_image1.addGestureRecognizer(imgClick1)
        dongtaiPicture_image1.isUserInteractionEnabled = true
        let imgClick2 = UITapGestureRecognizer(target: self, action: #selector(picture2Action))
        dongtaiPicture_image2.addGestureRecognizer(imgClick2)
        dongtaiPicture_image2.isUserInteractionEnabled = true
        let imgClick3 = UITapGestureRecognizer(target: self, action: #selector(picture3Action))
        dongtaiPicture_image3.addGestureRecognizer(imgClick3)
        dongtaiPicture_image3.isUserInteractionEnabled = true
        
        
        // Do any additional setup after loading the view.
    }
    @objc func picture1Action() -> Void {
        pictureIndex = 1
        imAction()
    }
    @objc func picture2Action() -> Void {
        pictureIndex = 2
        imAction()
    }
    @objc func picture3Action() -> Void {
        pictureIndex = 3
        imAction()
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController!.sourceView = self.view
            actionSheet.popoverPresentationController!.sourceRect = CGRect(x: 0,y: 0,width: 1.0,height: 1.0);
        }
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
        
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        var filePath = ""
        
        switch pictureIndex {
        case 1:
            dongtaiPicture_image1.image = image
            filePath = "\(rootPath)/pickedimage1.jpg"
            dongtaiPicture_image2.isHidden = false
        case 2:
            dongtaiPicture_image2.image = image
            filePath = "\(rootPath)/pickedimage2.jpg"
            dongtaiPicture_image3.isHidden = false
        case 3:
            dongtaiPicture_image3.image = image
            filePath = "\(rootPath)/pickedimage3.jpg"
        default:
            break
        }
        
        let imageData = image.jpegData(compressionQuality: 0.1)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
