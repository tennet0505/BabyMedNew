//
//  NewIllnesViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class NewIllnesViewController: UIViewController {
    
    @IBOutlet weak var nameIllTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    
    let realm = try! Realm()
    var illArray : Results<IllModel>?
    
    var selectedChild : ChildModel?
    {
        didSet{
            loadIllness()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func saveButton(_ sender: UIButton) {
        
      //   let currentChild = self.selectedChild
            
            do{
                try self.realm.write {
                    
                    let newIll = IllModel()
                    
                    newIll.illName = nameIllTextField.text!
                    newIll.DateIll = dateTextField.text!
                    newIll.simptoms = simptomsTextView.text!
                    newIll.treatment = treatmentTextView.text!
                    
                    selectedChild?.ills.append(newIll)
                    
                }
                
            }catch{
                print("Error new Category")
                
            }
      // }
        
        nameIllTextField.text = ""
        simptomsTextView.text = ""
        treatmentTextView.text = ""
        
        
    }
    

    
    func loadIllness() {

        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)

    }
   
}
