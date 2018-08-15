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
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var name = ""
    var bd = ""
    var nameIll = ""
    var date = ""
    var simptoms = ""
    var treatment = ""
    var image = "BabyMedLogo"
    var uidUser = ""
    var idIll = ""
    
    var ill = IllModel(idIll: "",
                       simptoms: "",
                       treatment: "",
                       illName: "",
                       DateIll: "",
                       fotoRecept: "")
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = name
        birthDayLabel.text = bd
      //  getImage(imageName: image)
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
       // getImage(imageName: image)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toIllForEdit",
            let vc = segue.destination as? NewIllnesViewController{
            vc.image = image
            vc.simptom = simptoms
            vc.treatment = treatment
            vc.illname = nameIll
            vc.date = date
            vc.editValue = 1
            vc.uidUser = uidUser
            vc.name = name
            vc.birthdate = bd
            vc.idIll = idIll
            vc.delegate = self
            
        }
        
        if segue.identifier == "toImageZoom",
            let vc = segue.destination as? ImageZoomViewController{
            vc.imageString = image
            vc.idIll = idIll
            vc.uidUser = uidUser
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
        simptomsTextView.text = ill.simptoms
        treatmentTextView.text = ill.treatment
    }
    
    func refreshProfileImage(){
       
        let store = Storage.storage()
        let storeRef = store.reference().child("Childs").child(uidUser).child("Ills").child("\(idIll)/images/profile_photo.jpg")
        print(storeRef)
        storeRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                self.imageRecept.image = image
            }
        }
    }
    @IBAction func buttonZoom(_ sender: UIButton) {
        performSegue(withIdentifier: "toImageZoom", sender: self)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageRecept
    }
}
