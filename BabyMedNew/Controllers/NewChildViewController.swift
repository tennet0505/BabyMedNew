//
//  NewChildViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseStorage
import RealmSwift

protocol NewChildDataProtocol {
    func newDataChild(childEdit: ChildModel, indexPath: IndexPath?)
}
class NewChildViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var bloodTypeArray = ["Выберите группу крови:","Группа I+","Группа I-","Группа II+","Группа II-","Группа III+","Группа III-","Группа IV+","Группа IV-"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypeArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodTextField.text = bloodTypeArray[row]
    }
    
    
    let realm = try! Realm()
    var ref: DatabaseReference!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var BirthDayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bloodTextField: UITextField!
    
    let pickerView = UIPickerView()
    let picker = UIDatePicker()
    var birthDayString = ""
    var idChild = NSUUID().uuidString
    var editValue = 0
    var indexPath = IndexPath()
    @IBOutlet weak var imageTakeFoto: UIImageView!
    
    var delegate: NewChildDataProtocol?
    var illarray = [IllModel]()
    var childPerson: ChildModel = ChildModel(id: "",
                                             name: "",
                                             birthDate: "",
                                             gender: "",
                                             bloodType: "",
                                             image: "",
                                             weight: "",
                                             userId: "")
    @IBOutlet weak var buttonSave: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        bloodTextField.inputView = pickerView
        nameTextField.delegate = self
        BirthDayTextField.delegate = self
        genderTextField.delegate = self
        weightTextField.delegate = self
        bloodTextField.delegate = self
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ref = Database.database().reference()
        
        nameTextField.text = childPerson.name
        BirthDayTextField.text = childPerson.birthDate
        genderTextField.text = childPerson.gender
        weightTextField.text = childPerson.weight
        bloodTextField.text = childPerson.bloodType
        imageTakeFoto.image =  getImage(imageName: childPerson.image)
        buttonSave.isEnabled = true
        birthDatePicker()
        
    }
    
    func addChild() {
        
        if let name = nameTextField.text,
            let birthDay = BirthDayTextField.text,
            let gender = genderTextField.text,
            let weight = weightTextField.text,
            let bloodType = bloodTextField.text,
            let userId = Auth.auth().currentUser?.uid
        {
            let id = ref.child("children").childByAutoId().key
            let childNew : [String : Any] = ["id": id,
                                             "name": name,
                                             "birthDate": birthDay,
                                             "gender": gender,
                                             "weight": weight,
                                             "bloodType": bloodType,
                                             "image": imageProfile(),
                                             "userId": userId,
                                             "illnessList": []]
            
            ref.child("children").child("\(id)").setValue(childNew)
            
            //            let childNewRealm = ChildRealm()
            //            childNewRealm.name = name
            //            childNewRealm.birthDate = birthDay
            //            childNewRealm.blood = blood
            //            childNewRealm.gender = gender
            //            childNewRealm.weight = weight
            //            childNewRealm.userEmail = userEmail!
            //            addChildToRealm(child: childNewRealm)
            
        }
    }
    func addChildToRealm(child: ChildRealm) {
        do{
            try realm.write {
                realm.add(child)
            }
        }catch{
            print("Error save child!!!")
        }
    }
    
    @IBAction func SaveData(_ sender: UIButton) {
        
        if editValue == 0{
            addChild()
        }else{
            let userId = Auth.auth().currentUser?.uid
            let childUpdate : [String : Any] = ["id": idChild,
                                                "name": nameTextField.text!,
                                                "birthDate": BirthDayTextField.text!,
                                                "gender": genderTextField.text!,
                                                "weight": weightTextField.text!,
                                                "blood": bloodTextField.text!,
                                                "image": imageProfileUpdate(foto: imageTakeFoto.image!),
                                                "userId": userId as! String,
                                                "ills": []]
            
            ref.child("children").child("\(idChild)").updateChildValues(childUpdate)
            childPerson = ChildModel(id: idChild,
                                     name: nameTextField.text!,
                                     birthDate: BirthDayTextField.text!,
                                     gender: genderTextField.text!,
                                     bloodType: bloodTextField.text!,
                                     image:  imageProfileUpdate(foto: imageTakeFoto.image!),
                                     weight: weightTextField.text!,
                                     userId:  userId)
        }
        
        let newChild = childPerson
        delegate?.newDataChild(childEdit: newChild, indexPath: nil)
        
        nameTextField.text = ""
        BirthDayTextField.text = ""
        genderTextField.text = ""
        weightTextField.text = ""
        bloodTextField.text = ""
        buttonSave.isEnabled = false
        
        navigationController?.popViewController(animated: true)
    }
    
    func birthDatePicker()  {
        picker.datePickerMode = .date
        let loc = Locale(identifier: "Ru_ru")
        self.picker.locale = loc
        var components = DateComponents()
        components.year = -70
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components , to: Date())
        picker.maximumDate = maxDate
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
        let action1 = UIAlertAction(title: "Мальчик", style: .default, handler: { (action) in
            self.genderTextField.text = "Мальчик"
            if self.genderTextField.text == "Male"{
            }
        })
        
        let action2 = UIAlertAction(title: "Девочка", style: .default, handler: { action in
            self.genderTextField.text = "Девочка"
            if self.genderTextField.text == "Female"{
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
            imageTakeFoto.image = loadImageFromPath(path: img)
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageTakeFoto.image = img////////////////
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imageProfile() -> String{
        
        var data :NSData = NSData()
        if let image = imageTakeFoto.image{
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        
        return base64String ?? "avatar_default"
    }
    func imageProfileUpdate(foto: UIImage) -> String{
        
        var data :NSData = NSData()
        data = UIImageJPEGRepresentation(foto, 0.1)! as NSData
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        
        return base64String ?? "avatar_default"
    }
    
    func getImage(imageName: String) -> UIImage{
        
        var decodeImage = UIImage()
        if  let decode  = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters){
            decodeImage = UIImage(data: decode as Data) ?? UIImage(named: "avatar_default")!
        }
        return decodeImage
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageTakeFoto.layer.cornerRadius  = imageTakeFoto.frame.size.width/2
        imageTakeFoto.layer.masksToBounds = true
    }
    
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
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


