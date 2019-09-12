//
//  HelpCenterViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit
import WebKit

class HelpCenterViewController: UIViewController {
    var url = "https://applet.banghua.xin/app/index.php?i=99999&c=entry&a=webapp&do=helpcenter&m=socialchat"
    var webView: WKWebView!
    @IBOutlet weak var webContainerView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        webView = WKWebView(frame: webContainerView.frame)
        // 下面一行代码意思是充满的意思(一定要加，不然也会显示有问题)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        webContainerView.addSubview(webView)
        
        let mapwayURL = URL(string: url)!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webView.load(mapwayRequest)
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
