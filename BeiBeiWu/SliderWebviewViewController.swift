//
//  SliderWebviewViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/9/12.
//  Copyright © 2019 江东. All rights reserved.
//


import UIKit
import WebKit

class SliderWebviewViewController: UIViewController {
    
    var url:String?
    var webView: WKWebView!
    
    @IBOutlet weak var webContainerView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: webContainerView.frame)
        // 下面一行代码意思是充满的意思(一定要加，不然也会显示有问题)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        webContainerView.addSubview(webView)
        let mapwayURL = URL(string: url!)!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webView.load(mapwayRequest)
    }
}
