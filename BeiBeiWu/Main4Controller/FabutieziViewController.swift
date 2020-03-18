//
//  FabutieziViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/13.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import Alamofire
class FabutieziViewController: UIViewController {
   
    var postTitleString:String?
    var postContentString:String?
    var postPlateString = "自拍"
    
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContent: UITextView!
    @IBAction func postPlate(_ sender: UISegmentedControl) {
        postPlateString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    @IBOutlet weak var postPicture1: UIImageView!
    @IBOutlet weak var postPicture2: UIImageView!
    @IBOutlet weak var postPicture3: UIImageView!
    @IBAction func postRelease(_ sender: Any) {
        let userInfo = UserDefaults()
        let userID = userInfo.string(forKey: "userID")
        
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
        
        postTitleString = self.postTitle.text!
        postContentString = self.postContent.text!
        
        self.view.makeToast("已发布成功，等待审核")
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(userID!.data(using: String.Encoding.utf8)!, withName: "authid")
            multipartFormData.append(self.postTitleString!.data(using: String.Encoding.utf8)!, withName: "posttitle")
            multipartFormData.append(self.postContentString!.data(using: String.Encoding.utf8)!, withName: "posttext")
            multipartFormData.append(self.postPlateString.data(using: String.Encoding.utf8)!, withName: "platename")
            if exist1 {
                multipartFormData.append(imageURL1, withName: "postpicture1", fileName: "postpicture1.jpg", mimeType: "image/*")
            }
            if exist2 {
                multipartFormData.append(imageURL2, withName: "postpicture2", fileName: "postpicture2.jpg", mimeType: "image/*")
            }
            if exist3 {
                multipartFormData.append(imageURL3, withName: "postpicture3", fileName: "postpicture3.jpg", mimeType: "image/*")
            }
            
        }, to: "https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=fabutiezi&m=socialchat",
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
                        print("Data: \(utf8Text)")
                        //同一个StoryBoard下
                        Thread.sleep(forTimeInterval: 1.5)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Luntan") as! LuntanViewController
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
        
        self.view.endEditing(true)
        //删除文件
        removePictureFile()
        //图片点击事件
        let imgClick1 = UITapGestureRecognizer(target: self, action: #selector(picture1Action))
        postPicture1.addGestureRecognizer(imgClick1)
        postPicture1.isUserInteractionEnabled = true
        let imgClick2 = UITapGestureRecognizer(target: self, action: #selector(picture2Action))
        postPicture2.addGestureRecognizer(imgClick2)
        postPicture2.isUserInteractionEnabled = true
        let imgClick3 = UITapGestureRecognizer(target: self, action: #selector(picture3Action))
        postPicture3.addGestureRecognizer(imgClick3)
        postPicture3.isUserInteractionEnabled = true

        
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
    func imAction(){
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


extension FabutieziViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        var filePath = ""
        switch pictureIndex {
        case 1:
            postPicture1.image = image
            filePath = "\(rootPath)/pickedimage1.jpg"
            postPicture2.isHidden = false
        case 2:
            postPicture2.image = image
            filePath = "\(rootPath)/pickedimage2.jpg"
            postPicture3.isHidden = false
        case 3:
            postPicture3.image = image
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
