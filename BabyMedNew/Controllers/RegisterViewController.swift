//
//  RegisterViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 07.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonRegistration: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buttonRegister(_ sender: UIButton) {
        
        SVProgressHUD.show()
        if passwordTextField.text != "" && passwordTextField.text != "" && confirmPassTextField.text != ""{
            if passwordTextField.text == confirmPassTextField.text{
                Auth.auth().createUser(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        print("Registration successful")
                        SVProgressHUD.dismiss()
                        
                        self.performSegue(withIdentifier: "goToBabyMed", sender: self)
                    }
                }
                
            }else{
                let alert = UIAlertController(title: "Внимание!", message: "Не правильно введен пароль", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .cancel, handler:nil)
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }
            
        }else{
            let alert = UIAlertController(title: "Внимание!", message: "Заполните все поля!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .cancel, handler:nil)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
            SVProgressHUD.dismiss()
            
        }
    }
    
   
    

}
