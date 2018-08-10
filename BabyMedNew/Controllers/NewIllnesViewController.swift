//
//  NewIllnesViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift
import AVKit
import FirebaseDatabase
import FirebaseAuth


protocol IllnessProtocol {
    func dataToNewIllness(illData: IllModel)
}

class NewIllnesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imageRecept: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var nameIllTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    let picker = UIDatePicker()
    
    var delegate: IllnessProtocol?
    var name = ""
    var birthdate = ""
    var ill = ""
    var date = ""
    var simptom = ""
    var treatment = ""
    var editValue = 0
    var idIll = NSUUID().uuidString
  //  var illUserID = ""
    var uidUser = ""
  //  let newIll = IllModel()
//    let realm = try! Realm()
//    var illArray : Results<IllModel>?
    
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
            nameIllTextField.isEnabled = true
            dateTextField.isEnabled = true
            nameIllTextField.alpha = 1
            dateTextField.alpha = 1
        }else{
            buttonEdit.isHidden = false
            buttonSave.isHidden = true
            nameIllTextField.isEnabled = false
            dateTextField.isEnabled = false
            nameIllTextField.alpha = 0.5
            dateTextField.alpha = 0.5
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
        
        print(uidUser)

        nameIllTextField.text = ill
        dateTextField.text = date
        simptomsTextView.text = simptom
        treatmentTextView.text = treatment
        
        DatePicker()
        
        
    }

    @IBAction func saveButton(_ sender: UIButton) {
       
        addNewIll()
//        do{
//            try self.realm.write {
//                
//                newIll.illName = nameIllTextField.text!
//                newIll.DateIll = dateTextField.text!
//                newIll.simptoms = simptomsTextView.text!
//                newIll.treatment = treatmentTextView.text!
//                selectedChild?.ills.append(newIll)
//                
//                
//                nameIllTextField.text = ""
//                simptomsTextView.text = ""
//                treatmentTextView.text = ""
//
                navigationController?.popViewController(animated: true)
//            }
//            
//        }catch{
//            print("Error new Category")
//            
//        }
//        saveImage(imageName: "\(newIll.illName)+\(newIll.DateIll)")

     
    }
    
    func addNewIll() {
          print(uidUser)
        
        if let nameIll = nameIllTextField.text,
            let dayIll = dateTextField.text,
            let simptoms = simptomsTextView.text,
            let treatment = treatmentTextView.text{
            
            let illNew : [String : String] = ["illName": nameIll,
                                              "DateIll": dayIll,
                                              "simptoms": simptoms,
                                              "treatment": treatment]
            
      //      ref.child("Childs").child("ill").setValue(illNew)  //.childByAutoId().child("Ills").setValue(illNew)
            ref.child("Childs").child(uidUser).child("Ills").childByAutoId().setValue(illNew) //updateChildValues(illNew)
        }
       
    }
 
    @IBAction func buttonEdit(_ sender: UIButton) {
//        let newIll = IllModel()
        
//        newIll.illName = nameIllTextField.text!
//        newIll.DateIll = dateTextField.text!
//        newIll.simptoms = simptomsTextView.text!
//        newIll.treatment = treatmentTextView.text!
//        newIll.id = idIll
//        updatePerdonalData(ill: newIll)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc1 = storyboard.instantiateViewController(withIdentifier: "DescriptionIllViewController") as! DescriptionIllViewController
//
//        vc1.nameIll = nameIllTextField.text!
//        vc1.date = dateTextField.text!
//        vc1.simptoms = simptomsTextView.text!
//        vc1.treatment = treatmentTextView.text!
//       // navigationController?.popViewController(animated: true)
//     //   navigationController?.pushViewController(vc1, animated: false)
//        vc1.name = name
//        vc1.bd = birthdate
//        saveImage(imageName: "\(newIll.illName)+\(newIll.DateIll)")
//
//        let illEdit = newIll
//        delegate?.dataToNewIllness(illData: illEdit)
        navigationController?.popViewController(animated: true)
    }
    
    
    func updatePerdonalData(ill: IllModel){
        
//        try! realm.write {
//            realm.add(ill, update: true)
//        }
        
        
    }
    

    
    func loadIllness() {

//        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)

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
    @IBAction func buttonFoto(_ sender: UIButton) {
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
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path as String)
        
        if image == nil {
            return UIImage()
        } else{
            return image
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let img = info[UIImagePickerControllerEditedImage] as? String
            
        {
            imageRecept.image = loadImageFromPath(path: img)
            
            
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageRecept.image = img
        }
        
        picker.dismiss(animated: true,completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
   
    
    func saveImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        
        if let image = imageRecept.image{
            let data = UIImageJPEGRepresentation(image, 0.1)
            fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
            
        }
    }
    
    func getImage(imageName: String){
        
        
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            imageRecept.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("Panic! No Image!")
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        //print("Path: \(documentsDirectory)")
        return documentsDirectory as NSString
    }
    
}


