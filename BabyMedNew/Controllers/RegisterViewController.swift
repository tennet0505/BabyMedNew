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


class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonRegistration: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmPassTextField.delegate = self
        passwordTextField.delegate = self
        mailTextField.delegate = self
        

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
    func textFieldShouldBeginEditing (_ textField: UITextField) -> Bool {
        
        textField.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.5294117647, blue: 0.007843137255, alpha: 1)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.tintColor = #colorLiteral(red: 0.9647058824, green: 0.5294117647, blue: 0.007843137255, alpha: 1)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.tintColor = #colorLiteral(red: 0.9647058824, green: 0.5294117647, blue: 0.007843137255, alpha: 1)
    }
   
    

}
