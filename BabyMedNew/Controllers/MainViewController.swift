//
//  MainViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import Firebase


class MainViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    @IBAction func ButtonLogOut(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            let storyboard =  UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! LoginNavigationViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
        catch{
            print("error problem with sign out")
        }
    }
    
    

}
