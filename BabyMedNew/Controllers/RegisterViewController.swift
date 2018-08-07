//
//  RegisterViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 07.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var buttonRegistration: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buttonRegister(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("Registration successful")
//                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToBabyMed", sender: self)
            }
        }
        
    }
    
   
    

}
