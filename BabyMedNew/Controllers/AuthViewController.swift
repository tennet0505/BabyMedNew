//
//  AuthViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 07.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class AuthViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
      @IBOutlet weak var buttonSignIn: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func buttonSignIn(_ sender: UIButton) {
      
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print("error log in")
            }else{
                SVProgressHUD.dismiss()
                print("logIn successful")
                let emailString = self.mailTextField.text!
                UserDefaults.standard.set(emailString, forKey: "email")
                
                self.performSegue(withIdentifier: "goToBabyMed", sender: self)
            }
        }
    }
    
    
}
