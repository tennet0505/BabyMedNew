//
//  NewChildViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class NewChildViewController: UIViewController {
    
    let realm = try! Realm()
    var childsArray : Results<ChildModel>!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var BirthDayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bloodTextField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    @IBAction func SaveData(_ sender: UIButton) {
      
        let child = ChildModel()
        
        child.name = nameTextField.text!
        child.birthDate = BirthDayTextField.text!
        child.gender = genderTextField.text!
        child.weight = weightTextField.text!
        child.blood = bloodTextField.text!
        
        self.saveCategory(child: child)
       
    }
    
    func saveCategory(child: ChildModel) {
        
        do{
            try realm.write {
                realm.add(child)
            }
            
        }catch{
            print("error saving \(error)")
        }
      //  self.tableView.reloadData()
    }
   
    
   

}
