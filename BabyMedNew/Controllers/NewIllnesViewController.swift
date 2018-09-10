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
import SVProgressHUD



protocol IllnessProtocol {
    func dataToNewIllness(illData: IllModel)
}

class NewIllnesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imageRecept: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var nameIllTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
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
    var idIllness = ""
    var id = ""
    var image = ""
    var illWeight = Int()
    var imgReceptPath = String()
    var downloadURL = ""
    var newIll = IllModel(idIll: "",
                          symptoms: "",
                          treatment: "",
                          illName: "",
                          DateIll: "",
                          fotoRecept: "",
                          illnessWeight: nil)
    var newIll1 = IllModel(idIll: "",
                          symptoms: "",
                          treatment: "",
                          illName: "",
                          DateIll: "",
                          fotoRecept: "",
                          illnessWeight: nil)
    
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
        nameIllTextField.text = illname
        dateTextField.text = date
        simptomsTextView.text = simptom
        treatmentTextView.text = treatment
        weightTextField.delegate = self
        if let kg: Int = illWeight
        {
            weightTextField.text = "\(kg)"
        }
        refreshProfileImage()
        DatePicker()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        addNewIll()
        navigationController?.popViewController(animated: true)
        
    }
    
    func addNewIll() {
        print(id)
        
        if let nameIll = nameIllTextField.text,
            let dayIll = dateTextField.text,
            let simptoms = simptomsTextView.text,
            let treatment = treatmentTextView.text,
            let illnessWeight = weightTextField.text
        {
            let idIll = ref.child("children").child(id).child("illnessList").childByAutoId().key
            let illNew : [String : Any] = ["idIll": idIll,
                                           "name": nameIll,
                                           "date": dayIll,
                                           "symptoms": simptoms,
                                           "treatmentPhotoUri": downloadURL,
                                           "treatment": treatment,
                                           "illnessWeight": Int(illnessWeight) as Any]
            
            ref.child("children").child(id).child("illnessList").child("\(idIll)").setValue(illNew)
        }
    }
    
    @IBAction func buttonEdit(_ sender: UIButton) {
      
        let idIll = ref.child("children").child(id).child("illnessList").childByAutoId().key
        newIll.illName = nameIllTextField.text!
        newIll.DateIll = dateTextField.text!
        newIll.symptoms = simptomsTextView.text!
        newIll.treatment = treatmentTextView.text!
        newIll.illnessWeight = Int(weightTextField.text!)
        //newIll.fotoRecept = downloadURL
        newIll.idIll = idIll
        updatePersonalData(ill: newIll)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "DescriptionIllViewController") as! DescriptionIllViewController
        
        vc1.nameIll = nameIllTextField.text!
        vc1.date = dateTextField.text!
        vc1.simptoms = simptomsTextView.text!
        vc1.treatment = treatmentTextView.text!
        if let weight = Int(weightTextField.text!){
            vc1.illWeight = weight
            
        } //////////////////
        vc1.name = name
        vc1.bd = birthdate
       
        newIll1.illName = nameIllTextField.text!
        newIll1.DateIll = dateTextField.text!
        newIll1.symptoms = simptomsTextView.text!
        newIll1.treatment = treatmentTextView.text!
        newIll1.illnessWeight = Int(weightTextField.text!)
        newIll1.fotoRecept = downloadURL
        let illEdit = newIll1
        delegate?.dataToNewIllness(illData: illEdit)
        navigationController?.popViewController(animated: true)
    }
    
    
    func updatePersonalData(ill: IllModel){
        
        let IllUpdate : [String : Any] = ["idIll": idIllness,
                                          "symptoms": simptomsTextView.text,
                                          "treatment": treatmentTextView.text!,
                                          "name": illname,
                                          "date": dateTextField.text!,
                                          "treatmentPhotoUri": downloadURL,
                                          "illnessWeight": Int(weightTextField.text!) as Any]
        
        ref.child("children").child(id).child("illnessList").child("\(idIllness)").updateChildValues(IllUpdate)
        if downloadURL != "" {
        ref.child("children").child(id).child("illnessList").child("\(idIllness)").updateChildValues(["treatmentPhotoUri": downloadURL])
        }
    }
    
    func loadIllness() {
        
        //        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)
        
    }
    func DatePicker()  {
        picker.datePickerMode = .date
        
//        let loc = Locale(identifier: "Ru_ru")
//        self.picker.locale = loc
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
//        dateFormater.locale = Locale(identifier: "RU_ru")
        dateTextField.text = dateFormater.string(from: picker.date)
        dateFormater1.dateFormat = "yyyy.MM.dd"///////////change date format
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        
        self.view.endEditing(true)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        
        return true
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
                                UIApplication.shared.canOpenURL(settingsURL)
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
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var imgFromPicker = info[UIImagePickerControllerOriginalImage]
        var fileUrl1 = info[UIImagePickerControllerImageURL]
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imgFromPicker = info[UIImagePickerControllerOriginalImage] as? UIImage
            imageRecept.image = imgFromPicker as? UIImage
            UIImageWriteToSavedPhotosAlbum(imageRecept.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            fileUrl1 = info[UIImagePickerControllerImageURL] as? NSURL
            
            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
            fileUrl1 = docDir.appendingPathComponent("\(imageUniqueName).png");
        }
        else{
            (UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
            
            imgFromPicker = info[UIImagePickerControllerOriginalImage] as? UIImage
            
        }
        
        let alertController = UIAlertController(title: "load foto...", message: " ", preferredStyle: .alert)
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        
        if let fileUrl = fileUrl1 as? URL
        {
            imgReceptPath = "\(fileUrl.lastPathComponent)"
        }
        
        print(imgReceptPath)
        if let img1 = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            
            var imageData = Data()
            imageData = UIImageJPEGRepresentation(img1, 0.1)!
            imageRecept.image = img1
            let store = Storage.storage()
            let storeRef = store.reference().child("images/\(imgReceptPath)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storeRef.putData(imageData as Data, metadata: metaData){ metadata,error in
                //                let size = metadata?.size
                // You can also access to download URL after upload.
                
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    
                    storeRef.downloadURL { (url, error) in
                        DispatchQueue.main.async {
                            if  let URLdownload = url {
                                self.downloadURL = URLdownload.absoluteString
                                alertController.dismiss(animated: true, completion: nil)
                                print(self.downloadURL)
                            }
                        }
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
        self.present(alertController, animated: false, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
   
    func refreshProfileImage(){
        
        if imgReceptPath == "null" || imgReceptPath == ""{
            imageRecept.image = UIImage(named: "avatar_default")
        }else{
            DispatchQueue.main.async {
                let store = Storage.storage()
                let storeRef = store.reference(forURL: self.imgReceptPath)
                
                storeRef.downloadURL { url, error in
                    if let error = error {
                        
                        print("error: \(error)")
                    } else {
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                
                                self.imageRecept.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}


