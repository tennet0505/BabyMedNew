//
//  NewIllnesViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


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
    var illname = ""
    var date = ""
    var simptom = ""
    var treatment = ""
    var editValue = 0
    var idIll = ""
    var uidUser = ""
    var image = ""
    var newIll = IllModel(idIll: "",
                          simptoms: "",
                          treatment: "",
                          illName: "",
                          DateIll: "",
                          fotoRecept: "")
  
    
    
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
       
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ref = Database.database().reference()
        
        print(uidUser)

        nameIllTextField.text = illname
        dateTextField.text = date
        simptomsTextView.text = simptom
        treatmentTextView.text = treatment
      //  getImage(imageName: image)
        
        DatePicker()
        
        
    }

    @IBAction func saveButton(_ sender: UIButton) {
       
        addNewIll()

                navigationController?.popViewController(animated: true)

     
    }
    
    func addNewIll() {
          print(uidUser)
        
        if let nameIll = nameIllTextField.text,
            let dayIll = dateTextField.text,
            let simptoms = simptomsTextView.text,
            let treatment = treatmentTextView.text
        {
            let idIll = ref.child("Childs").child(uidUser).child("Ills").childByAutoId().key
            let illNew : [String : Any] = ["idIll": idIll,
                                           "illName": nameIll,
                                           "DateIll": dayIll,
                                           "simptoms": simptoms,
                                           "fotoRecept": "foto test",//imageProfile(),
                                           "treatment": treatment]
            
            //let illnessDictionary = ["ill": illNew] as [String : Any]
            
            ref.child("Childs").child(uidUser).child("Ills").child("\(idIll)").setValue(illNew)
        }
        
    }
 
    @IBAction func buttonEdit(_ sender: UIButton) {
        
        let idIll = ref.child("Childs").child(uidUser).child("Ills").childByAutoId().key
        newIll.illName = nameIllTextField.text!
        newIll.DateIll = dateTextField.text!
        newIll.simptoms = simptomsTextView.text!
        newIll.treatment = treatmentTextView.text!
        newIll.idIll = idIll
        updatePersonalData(ill: newIll)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "DescriptionIllViewController") as! DescriptionIllViewController

        vc1.nameIll = nameIllTextField.text!
        vc1.date = dateTextField.text!
        vc1.simptoms = simptomsTextView.text!
        vc1.treatment = treatmentTextView.text!
       
        vc1.name = name
        vc1.bd = birthdate


        let illEdit = newIll
        delegate?.dataToNewIllness(illData: illEdit)
        navigationController?.popViewController(animated: true)
    }
    
    
    func updatePersonalData(ill: IllModel){
        
        let IllUpdate : [String : Any] = ["idIll": idIll,
                                          "simptoms": simptomsTextView.text,
                                          "treatment": treatmentTextView.text!,
                                          "illName": illname,
                                          "DateIll": dateTextField.text!,
                                          "fotoRecept": "foto test"//imageProfileUpdate(foto: imageRecept.image!)
        ]
        
       
       // let IllDictionary = ["ill": IllUpdate] as [AnyHashable : Any]
        print("idIll: \(idIll)")
       ref.child("Childs").child(uidUser).child("Ills").child("\(idIll)").updateChildValues(IllUpdate)

        
    }
    

    
    func loadIllness() {

//        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)

    }
    func DatePicker()  {
        picker.datePickerMode = .date
        
        let loc = Locale(identifier: "Ru_ru")
        self.picker.locale = loc
        
        var components = DateComponents()
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components , to: Date())
        picker.maximumDate = maxDate
        
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
        
        actionTap.addAction(UIAlertAction(title: "Фото альбом", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionTap.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionTap, animated: true, completion: nil)
        
    }
   
    func imageProfile() -> String{
        
        var data :NSData = NSData()
        if let image = imageRecept.image{
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        
        return base64String ?? "BabyMedLogo"
    }
    func imageProfileUpdate(foto: UIImage) -> String{
        
        var data :NSData = NSData()
        data = UIImageJPEGRepresentation(foto, 0.1)! as NSData
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        
        return base64String ?? "avatar_default"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let img = info[UIImagePickerControllerEditedImage] as? String
            
        {
            imageRecept.image = loadImageFromPath(path: img)
            
            
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let imageData: Data = UIImageJPEGRepresentation(img, 0.1)!
  
            let store = Storage.storage()
            let user = Auth.auth().currentUser
            if let user = user{
                print(idIll)
                let storeRef = store.reference().child("Childs").child(uidUser).child("Ills").child("\(idIll)").child("images/profile_photo.jpg")
                let _ = storeRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    guard let _ = metadata else {
                        print("error occurred: \(error.debugDescription)")
                        return
                    }
                    self.imageRecept.image = img
                }
                
            }

        }
        
        picker.dismiss(animated: true,completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path as String)
        
        if image == nil {
            return UIImage()
        } else{
            return image
        }
    }
    
   
    
    func getImage(imageName: String){
        
        var decodeImage = UIImage()
        if imageName != ""{
            let decode = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters)
            decodeImage = UIImage(data: decode as! Data)!
            imageRecept.image = decodeImage
        }else{
            imageRecept.image = UIImage(named: "BabyMedLogo")
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        //print("Path: \(documentsDirectory)")
        return documentsDirectory as NSString
    }
    
}


