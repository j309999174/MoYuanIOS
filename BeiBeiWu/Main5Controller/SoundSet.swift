//
//  SoundSet.swift
//  BeiBeiWu
//
//  Created by 江东 on 2020/3/7.
//  Copyright © 2020 江东. All rights reserved.
//

import UIKit

class SoundSet: UIViewController {

    
    @IBOutlet weak var soundSet: UISegmentedControl!
    @IBAction func soundSet_action(_ sender: UISegmentedControl) {
        let userInfo = UserDefaults()
        userInfo.setValue(sender.titleForSegment(at: sender.selectedSegmentIndex), forKey: "soundSet")
        if userInfo.string(forKey: "soundSet") == "消息免打扰" {
            RCIMClient.shared()?.setNotificationQuietHours("00:00:00", spanMins: 1339, success: {
                
            }, error: { (RCErrorCode) in
                
            })
        }else{
            RCIMClient.shared()?.removeNotificationQuietHours({
                
            }, error: { (RCErrorCode) in
                
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userInfo = UserDefaults()
        if userInfo.string(forKey: "soundSet") == "消息免打扰" {
            soundSet.selectedSegmentIndex = 1
        }else{
            soundSet.selectedSegmentIndex = 0
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
