//
//  AppDelegate.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/22.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkLocationServices()
        //注册融云
        RCIM.shared()?.initWithAppKey("3argexb63qxke")
        //注册微信
        WXApi.registerApp("wxc7ff179d403b7a51")
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //支付宝回调
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url){
                value in
                let code = value!
                let resultStatus = code["resultStatus"] as!String
                var content = ""
                switch resultStatus {
                case "9000":
                    content = "支付成功"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaySuccessNotification"), object: nil)
                case "8000":
                    content = "订单正在处理中"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                case "4000":
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
                case "5000":
                    content = "重复请求"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
                case "6001":
                    content = "中途取消"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
                case "6002":
                    content = "网络连接出错"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
                case "6004":
                    content = "支付结果未知"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                default:
                    content = "支付失败"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayFailNotification"), object: nil)
                    break
                }
            }
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            let long = Double(String(format: "%.1f", location.coordinate.longitude))
            print("纬度:\(long!)")
            print("经度:\(lat!)")
    
            let userInfo = UserDefaults()
            userInfo.setValue(lat!, forKey: "latitude")
            userInfo.setValue(long!, forKey: "longitude")
            
            //停止定位
            locationManager.stopUpdatingLocation()
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
        //微信支付回调
        print(resp.errCode)
        //  微信支付回调
        if resp.isKind(of: PayResp.self)
        {
            print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
           }
        }
    }
}
