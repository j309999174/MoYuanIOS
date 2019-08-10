//
//  SousuoViewController.swift
//  BeiBeiWu
//
//  Created by 江东 on 2019/7/30.
//  Copyright © 2019 江东. All rights reserved.
//

import UIKit

class SousuoViewController: UIViewController {
    var userGenderString = "不限"
    var userPropertyString = "不限"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func userGender(_ sender: UISegmentedControl) {
        userGenderString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    
    @IBAction func userProperty(_ sender: UISegmentedControl) {
        userPropertyString = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBOutlet weak var userAge: UITextField!
    
    @IBOutlet weak var userRegion: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SousuoResultStoryBoard") as! SousuoResultViewController
        vc.type = "condition"
        vc.userAge = userAge.text ?? ""
        vc.userRegion = userRegion.text ?? ""
        vc.userGender = userGenderString
        vc.userProperty = userPropertyString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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


extension SousuoViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SousuoResultStoryBoard") as! SousuoResultViewController
        vc.type = "direct"
        vc.nameOrPhone = searchBar.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
