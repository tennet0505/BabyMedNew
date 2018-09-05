//
//  DescriptionIllViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseStorage

class DescriptionIllViewController: UIViewController, IllnessProtocol, UIScrollViewDelegate  {
    
    //    let realm = try! Realm()
    //    var childsArray : Results<ChildModel>!
    
    @IBOutlet weak var imageRecept: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var nameIllLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ImageView: UIView!
    var name = ""
    var bd = ""
    var nameIll = ""
    var date = ""
    var simptoms = ""
    var treatment = ""
    var imagePath = ""
    var id = ""
    var idIllness = ""
    var illWeight: Int? = nil
    
    var ill = IllModel(idIll: "",
                       symptoms: "",
                       treatment: "",
                       illName: "",
                       DateIll: "",
                       fotoRecept: "",
                       illnessWeight: nil)
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = name
        birthDayLabel.text = bd
        hightConstraint.constant = 0
        refreshProfileImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        
        nameLabel.text = name
        birthDayLabel.text = bd
        nameIllLabel.text = nameIll
        dateLabel.text = date
        simptomsTextView.text = simptoms
        treatmentTextView.text = treatment
        if let weightString = illWeight{
            weightLabel.text = "\(String(describing: weightString))кг"
            
        }
        
        // getImage(imageName: image)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toIllForEdit",
            let vc = segue.destination as? NewIllnesViewController{
            vc.image = imagePath
            vc.simptom = simptoms
            vc.treatment = treatment
            vc.illname = nameIll
            vc.date = date
            vc.editValue = 1
            vc.id = id
            vc.name = name
            vc.birthdate = bd
            vc.idIllness = idIllness
            if let id = illWeight{
                vc.illWeight = id
            }
            vc.imgReceptPath = imagePath
            vc.delegate = self
        }
        
        if segue.identifier == "toImageZoom",
            let vc = segue.destination as? ImageZoomViewController{
            vc.imageString = imagePath
            vc.idIll = idIllness
            vc.id = id
        }
    }
    
    @IBAction func buttonEdit(_ sender: Any) {
        performSegue(withIdentifier: "toIllForEdit", sender: self)
        
        
    }
    
    func getImage(imageName: String){
        
        var decodeImage = UIImage()
        if imageName != ""{
            let decode = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters)
            decodeImage = UIImage(data: decode! as Data)!
            imageRecept.image = decodeImage
        }else{
            imageRecept.image = UIImage(named: "BabyMedLogo")
        }
    }
    
    func dataToNewIllness(illData: IllModel) {
        
        ill = illData
        nameIllLabel.text = ill.illName
        dateLabel.text = ill.DateIll
        simptomsTextView.text = ill.symptoms
        treatmentTextView.text = ill.treatment
        weightLabel.text = "\(ill.illnessWeight)"
    }
    
    func refreshProfileImage(){
            if imagePath == "null" || imagePath == ""{
                imageRecept.image = UIImage(named: "avatar_default")
            }else{
                 DispatchQueue.global().async {
                let store = Storage.storage()
                    let storeRef = store.reference(forURL: self.imagePath)
                
                storeRef.downloadURL { url, error in
                    if let error = error {
                         self.hightConstraint.constant = 0
                        print("error: \(error)")
                    } else {
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                self.hightConstraint.constant = 204
                                self.imageRecept.image = image
                            }
                        }
                    }
                }
            }
        }
    }
        
//        let store = Storage.storage()
//        let storeRef = store.reference().child("children").child(id).child("illnessList").child("\(idIll)/images/profile_photo.jpg")
//        print(storeRef)
//        storeRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//
//            } else {
//                self.hightConstraint.constant = 204
//                let image = UIImage(data: data!)
//                self.imageRecept.image = image
//            }
//        }
    
    @IBAction func buttonZoom(_ sender: UIButton) {
        performSegue(withIdentifier: "toImageZoom", sender: self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageRecept
    }
}
