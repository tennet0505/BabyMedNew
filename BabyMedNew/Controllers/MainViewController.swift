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
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("error problem with sign out")
        }
    }
    
    

}
