//
//  AuthViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 07.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
      @IBOutlet weak var buttonSignIn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func buttonSignIn(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print("error log in")
            }else{
        //        SVProgressHUD.dismiss()
                print("logIn successful")
                
                self.performSegue(withIdentifier: "goToBabyMed", sender: self)
            }
        }
    }
    
    
}
