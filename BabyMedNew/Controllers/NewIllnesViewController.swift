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
    
    let picker = UIDatePicker()
    
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

        DatePicker()
        
        
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
        
        navigationController?.popViewController(animated: true)
        
    }
    

    
    func loadIllness() {

        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)

    }
    func DatePicker()  {
        picker.datePickerMode = .date
        
        let loc = Locale(identifier: "Ru_ru")
        self.picker.locale = loc
        
//        var components = DateComponents()
//        components.year = -70
//        let minDate = Calendar.current.date(byAdding: components, to: Date())
//
//        components.year = -17
//        let maxDate = Calendar.current.date(byAdding: components, to: Date())
//        
//        picker.minimumDate = minDate
//        picker.maximumDate = maxDate
//
//        picker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed));
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = picker
        
    }
    @objc func donePressed(){
        let dateFormater = DateFormatter()
        let dateFormater1 = DateFormatter()
        dateFormater.dateFormat = "dd MMMM yyyy"///////////change date format
        dateFormater.locale = Locale(identifier: "RU_ru")
        dateTextField.text = dateFormater.string(from: picker.date)
        
        dateFormater1.dateFormat = "yyyy.MM.dd"///////////change date format
        
       // birthDayString = dateFormater1.string(from: picker.date)
        
        self.view.endEditing(true)
        
    }
    
    @objc func cancelDatePicker(){
        
        self.view.endEditing(true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
}
