//
//  NewChildViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift
import AVKit

class NewChildViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    var childsArray : Results<ChildModel>!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var BirthDayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bloodTextField: UILabel!
    let picker = UIDatePicker()
    var birthDayString = ""
    @IBOutlet weak var imageTakeFoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        birthDatePicker()
        
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
//        self.tableView.reloadData()
    }
    
    
    func birthDatePicker()  {
        picker.datePickerMode = .date
        
        let loc = Locale(identifier: "Ru_ru")
        self.picker.locale = loc
        
        var components = DateComponents()
        components.year = -70
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        
        components.year = -17
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        
        picker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed));
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        BirthDayTextField.inputAccessoryView = toolbar
        BirthDayTextField.inputView = picker
        
    }
    @objc func donePressed(){
        let dateFormater = DateFormatter()
        let dateFormater1 = DateFormatter()
        dateFormater.dateFormat = "dd MMMM yyyy"///////////change date format
        dateFormater.locale = Locale(identifier: "RU_ru")
        BirthDayTextField.text = dateFormater.string(from: picker.date)
        
        dateFormater1.dateFormat = "yyyy.MM.dd"///////////change date format
        
        birthDayString = dateFormater1.string(from: picker.date)
        
        self.view.endEditing(true)
    
        }
    
    @objc func cancelDatePicker(){
        
        self.view.endEditing(true)
      
    }
    
    @IBAction func sexChoiceButton(_ sender: UIButton) {
        
        let sexChoiceAlert = UIAlertController()
        
        let action1 = UIAlertAction(title: "Male", style: .default, handler: { (action) in
            
            
            self.genderTextField.text = "Male"
            if self.genderTextField.text == "Male"{
              //  self.sexTextString = "Male"
            }
            
        })
        
        
        let action2 = UIAlertAction(title: "Female", style: .default, handler: { action in
            self.genderTextField.text = "Female"
            if self.genderTextField.text == "Female"{
             //   self.sexTextString = "Female"
            }
        
        })
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sexChoiceAlert.addAction(action1)
        sexChoiceAlert.addAction(action2)
        sexChoiceAlert.addAction(action3)
        
        
        self.present(sexChoiceAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonTakeFoto(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionTap = UIAlertController(title: "Фото", message: "Выберите источник:", preferredStyle: .actionSheet)
        
        actionTap.addAction(UIAlertAction(title: "Камера", style: .default, handler: {(action:UIAlertAction) in
            
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                DispatchQueue.main.async {
                    
                    if granted == true
                    {
                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                            
                            imagePickerController.sourceType = .camera
                            self.present(imagePickerController, animated: true, completion: nil)
                        }else{
                            print("Camera not work")
                        }
                    }else{
                        let alert = UIAlertController(title: "Attention!", message: "AccessToCamera", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.openURL(settingsURL)
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                    
                }})
            
        }))
       
        actionTap.addAction(UIAlertAction(title: "FotoGallery", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionTap.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionTap, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imageTakeFoto.image = img
            
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageTakeFoto.image = img
        }
        
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
