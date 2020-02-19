//
//  AppDelegate.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/22.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import RongContactCard
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SKPaymentQueue.default().add(StoreObserver.shared)
        
        checkLocationServices()
       
        UINavigationBar.appearance().backgroundColor = UIColor.orange
        IQKeyboardManager.shared.enable = true
        //注册融云
        RCIM.shared()?.initWithAppKey("m7ua80gbmo0km")
        RCIM.shared()?.enableMessageRecall = true
        RCIM.shared()?.enableTypingStatus = true
        
        //注册微信
        WXApi.registerApp("wxef862b4ad2079599", universalLink: "https://www.banghua.xin/")
        //请求通知权限
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    print("用户不允许消息通知。")
                }
        }
        //向APNs请求token
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("推送token是\(token.utf8)")
        RCIMClient.shared()?.setDeviceToken(token)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("urlhost")
        print(url.host ?? "")
        if url.host == "oauth" {
            WXApi.handleOpen(url, delegate: self)
        }
        //支付宝回调
//        if url.host == "safepay"{
//            AlipaySDK.defaultService().processOrder(withPaymentResult: url){
//                value in
//                let code = value!
//                let resultStatus = code["resultStatus"] as!String
//                var content = ""
//                switch resultStatus {
//                case "9000":
//                    content = "支付成功"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaySuccessNotification"), object: nil)
//                case "8000":
//                    content = "订单正在处理中"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
//                case "4000":
//                    content = "支付失败"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
//                case "5000":
//                    content = "重复请求"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
//                case "6001":
//                    content = "中途取消"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
//                case "6002":
//                    content = "网络连接出错"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
//                case "6004":
//                    content = "支付结果未知"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
//                default:
//                    content = "支付失败"
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
//                    break
//                }
//            }
//        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("进入后台")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SKPaymentQueue.default().remove(StoreObserver.shared)
    }


}

extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.8f", location.coordinate.latitude))
            let long = Double(String(format: "%.8f", location.coordinate.longitude))
            //let lat = location.coordinate.latitude
            //let long = location.coordinate.longitude
            print("纬度:\(String(describing: long))")
            print("经度:\(String(describing: lat))")
    
            let userInfo = UserDefaults()
            userInfo.setValue(lat, forKey: "latitude")
            userInfo.setValue(long, forKey: "longitude")
            
            //停止定位
            //locationManager.stopUpdatingLocation()
        }
    }
}


extension AppDelegate: WXApiDelegate{
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         return WXApi.handleOpen(url, delegate: self)
    }
    func onReq(_ req: BaseReq) {
        
    }
    func onResp(_ resp: BaseResp) {
        print("微信回调")
        //微信支付回调
        print(resp.errCode)
        //  微信支付回调
        if resp.isKind(of: PayResp.self)
        {
            print("微信回调retcode = \(resp.errCode), retstr = \(resp.errStr)")
            switch resp.errCode
            {
            //  支付成功
            case 0 :
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaySuccessNotification"), object: nil)
               break
            //  支付失败
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
                break
                
            }
        }else{
        //  微信登录回调
        if resp.errCode == 0 && resp.type == 0{//授权成功
            let response = resp as! SendAuthResp
            //  微信登录成功通知
            print("微信登录回调")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
           }
        }
    }
}




//所有组件在storyboard中增加圆角栏
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        // also  set(newValue)
        set {
            layer.cornerRadius = newValue
        }
    }
}
//扩展日期，返回时间戳
extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}

extension UIViewController{
    func removePictureFile(){
        //删除文件
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let filePath1 = "\(rootPath)/pickedimage1.jpg"
        let filePath2 = "\(rootPath)/pickedimage2.jpg"
        let filePath3 = "\(rootPath)/pickedimage3.jpg"
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: filePath)
            try fileManager.removeItem(atPath: filePath1)
            try fileManager.removeItem(atPath: filePath2)
            try fileManager.removeItem(atPath: filePath3)
            print("Success to remove file.")
        }catch{
            print("Failed to remove file.")
        }
    }
}

extension UITextView {
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil {
                if (self.font == nil) {
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = self.font
                label?.textColor = UIColor.lightGray
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


extension UIImage{
    func waterMarkedImage(bg:Data,logo:String,scale:CGFloat,margin:CGFloat)->UIImage{
        //let bgImage = UIImage.init(named: bg)
        let bgImage = UIImage(data: bg)
        // 1.创建一个基于位图的上下文(开启一个基于位图的上下文)
        UIGraphicsBeginImageContextWithOptions(bgImage!.size, false, 0.0)
        // 2.画背景
        bgImage?.draw(in: CGRect(x: 0, y: 0, width: bgImage!.size.width, height: bgImage!.size.height))
        
        // 3.画右下角的水印 设置缩放比例 和 距离右边和下边的距离
        let waterImage = UIImage.init(named: logo)
        let waterW = waterImage!.size.width * scale
        let waterH = waterImage!.size.height * scale
        let waterX = bgImage!.size.width - waterW - margin
        let waterY = bgImage!.size.height - waterH - margin
        waterImage?.draw(in: CGRect(x: waterX, y: waterY, width: waterW, height: waterH))
        
        // 4.从上下文中取得制作完毕的UIImage对象
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // 5.结束上下文
        UIGraphicsEndImageContext();
        return newImage
        
        
    }
}

