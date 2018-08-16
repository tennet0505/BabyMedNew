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


class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
  
    @IBOutlet weak var viewOR: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.delegate = self
        self.mailTextField.delegate = self

        viewOR.layer.borderWidth = 1
        viewOR.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.4823529412, blue: 0.01176470588, alpha: 1)
        viewOR.layer.cornerRadius = 20
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    @IBAction func buttonSignIn(_ sender: UIButton) {
      
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
                if error != nil{
                    print("error log in")
                    let alert = UIAlertController(title: "Внимание!", message: "Не правильно введен пароль или E-mail", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .cancel, handler:nil)
                    alert.addAction(action1)
                    self.present(alert, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.dismiss()
                    print("logIn successful")
                    let emailString = self.mailTextField.text!
                    UserDefaults.standard.set(emailString, forKey: "email")
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToBabyMed", sender: self)
                }
            }
        
        
    }
    @IBAction func buttonRegister(_ sender: UIButton) {
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
