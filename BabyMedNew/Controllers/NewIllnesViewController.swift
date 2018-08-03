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
    
    @IBOutlet weak var buttonEdit: UIButton!
    
    @IBOutlet weak var buttonAllIllness: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var nameIllTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    let picker = UIDatePicker()
    
    var name = ""
    var birthdate = ""
    var ill = ""
    var date = ""
    var simptom = ""
    var treatment = ""
    var editValue = 0
    var idIll = NSUUID().uuidString
    
    let realm = try! Realm()
    var illArray : Results<IllModel>?
    
    var selectedChild : ChildModel?
    {
        didSet{
            loadIllness()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if editValue == 0{
            buttonEdit.isHidden = true
            buttonSave.isHidden = false
            buttonAllIllness.isHidden = false
        }else{
            buttonEdit.isHidden = false
            buttonSave.isHidden = true
            buttonAllIllness.isHidden = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameIllTextField.text = ill
        dateTextField.text = date
        simptomsTextView.text = simptom
        treatmentTextView.text = treatment
        
        DatePicker()
        
        
    }

    @IBAction func saveButton(_ sender: UIButton) {
        let newIll = IllModel()
        
        do{
            try self.realm.write {
                
                newIll.illName = nameIllTextField.text!
                newIll.DateIll = dateTextField.text!
                newIll.simptoms = simptomsTextView.text!
                newIll.treatment = treatmentTextView.text!
                selectedChild?.ills.append(newIll)
                
                nameIllTextField.text = ""
                simptomsTextView.text = ""
                treatmentTextView.text = ""
                
                navigationController?.popViewController(animated: true)
            }
            
        }catch{
            print("Error new Category")
            
        }
    }
    
    @IBAction func buttonEdit(_ sender: UIButton) {
        let newIll = IllModel()
        
        newIll.illName = nameIllTextField.text!
        newIll.DateIll = dateTextField.text!
        newIll.simptoms = simptomsTextView.text!
        newIll.treatment = treatmentTextView.text!
        newIll.id = idIll
        updatePerdonalData(ill: newIll)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "DescriptionIllViewController") as! DescriptionIllViewController
        vc1.nameIll = nameIllTextField.text!
        vc1.date = dateTextField.text!
        vc1.simptoms = simptomsTextView.text!
        vc1.treatment = treatmentTextView.text!
        navigationController?.pushViewController(vc1, animated: false)
        vc1.name = name
        vc1.bd = birthdate
    }
    
    
    func updatePerdonalData(ill: IllModel){
        
        try! realm.write {
            realm.add(ill, update: true)
        }
        
        
    }
    

    
    func loadIllness() {

        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)

    }
    func DatePicker()  {
        picker.datePickerMode = .date
        
        let loc = Locale(identifier: "Ru_ru")
        self.picker.locale = loc
        
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
