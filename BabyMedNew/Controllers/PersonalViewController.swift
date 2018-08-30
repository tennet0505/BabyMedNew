//
//  PersonalViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct IllModel {
    
    var idIll = ""
    var symptoms = ""
    var treatment = ""
    var illName = ""
    var DateIll = ""
    var fotoRecept = ""
    var illnessWeight = ""
    
    
    //    val name : String,
    //    val symptoms : String,
    //    val treatment : String,
    //    val treatmentPhotoUri : String?,
    //    val date : String,
    //    val illnessWeight : Int)
    
    init(idIll: String?, symptoms: String?, treatment: String?, illName: String?,  DateIll: String?, fotoRecept: String?, illnessWeight: String?) {
        self.idIll = idIll!
        self.symptoms = symptoms!
        self.treatment = treatment!
        self.illName = illName!
        self.DateIll = DateIll!
        self.fotoRecept = fotoRecept!
        self.illnessWeight = illnessWeight!
    }
}

class PersonalViewController: UIViewController, NewChildDataProtocol {
    
    var ref: DatabaseReference?
    var name = ""
    var bd = ""
    var gen = ""
    var weight = 0
    var blood = ""
    var uid = ""
    var userId = ""
    var imageFoto = ""
    var illsArray = [IllModel]()
    var child = [ChildModel]()
    var imgProfilePath = ""
    var firebaseImagePath = ""
    var childPerson: ChildModel = ChildModel(id: "",
                                             name: "",
                                             birthDate: "",
                                             gender: "",
                                             bloodType: "",
                                             image: "",
                                             weight: 0,
                                             userId: "")
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var fotoImage: UIImageView!
    var indexPath = IndexPath()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshProfileImage()
      //  getImage(imageName: childPerson.image)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIllness()
        nameLabel.text = name
        birthDayLabel.text = bd
        genderLabel.text = gen
        weightLabel.text = "\(weight)кг"
        bloodLabel.text = blood
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        if segue.identifier == "ToIllness",
        //            let vc = segue.destination as? IllnessTableViewController{
        //            let index = indexPath
        //        }
        
        if segue.identifier == "ToNewIllness",
            
            let vc = segue.destination as? NewIllnesViewController{
            vc.id = uid
            //            let index = indexPath
        }
        
        if segue.identifier == "toDescriptionIll",
            let vc = segue.destination as? DescriptionIllViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let ill = illsArray[indexPath.row]
                vc.simptoms = ill.symptoms
                vc.treatment = ill.treatment
                vc.nameIll = ill.illName
                vc.date = ill.DateIll
                vc.name = name
                vc.imagePath = ill.fotoRecept 
                vc.bd = bd
                vc.id = uid
                vc.illWeight = ill.illnessWeight
                vc.idIll = ill.idIll
            }
        }
        if segue.identifier == "toPersonalForEdit",
            
            let vc = segue.destination as? NewChildViewController{
            let child = self.childPerson
            vc.childPerson = child
            vc.idChild = childPerson.id
            vc.editValue = 1
            vc.delegate = self
            vc.indexPath = indexPath 
        }
    }
    func newDataChild(childEdit: ChildModel, indexPath: IndexPath?) {
        childPerson = childEdit
        nameLabel.text = childPerson.name
        birthDayLabel.text = childPerson.birthDate
        genderLabel.text = childPerson.gender
        weightLabel.text = "\(childPerson.weight)"
        bloodLabel.text = childPerson.bloodType
      //  getImage(imageName: childPerson.image)
    }
    
    func loadIllness() {
        
        ref = Database.database().reference()
        ref?.child("children").child(uid).child("IllnessList").observe(.childAdded, with: { snapshot  in
            
            if let getData = snapshot.value as? [String:Any] {
                
                if
                    let idIll = getData["idIll"],
                    let illName = getData["name"],
                    let DateIll = getData["date"],
                    let symptoms = getData["symptoms"],
                    let treatment = getData["treatment"],
                    let fotoRecept = getData["treatmentPhotoUri"],
                    let illnessWeight = getData["illnessWeight"]
                {
                    let illmodel = IllModel(idIll: idIll as? String,
                                            symptoms: symptoms as? String,
                                            treatment: treatment as? String,
                                            illName: illName as? String,
                                            DateIll: DateIll as? String,
                                            fotoRecept: fotoRecept as? String,
                                            illnessWeight: illnessWeight as? String
                    )
                    self.illsArray.insert(illmodel, at: 0)
                }
                self.tableView.reloadData()
            }
        })
        tableView.reloadData()
    }
    
  
    @IBAction func newIllButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ToNewIllness", sender: self)
    }
    
    @IBAction func buttonEdit(_ sender: Any) {
        performSegue(withIdentifier: "toPersonalForEdit", sender: self)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        fotoImage.layer.cornerRadius  = fotoImage.frame.size.width/2
        fotoImage.layer.masksToBounds = true
    }
    
}
extension PersonalViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return illsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let ill = illsArray[indexPath.row]
        cell.textLabel?.text = ill.illName
        cell.detailTextLabel?.text = ill.DateIll
        
        return cell
    }
    
    //MARK TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDescriptionIll", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            ref = Database.database().reference()
            let id = illsArray[indexPath.row].idIll
            let imgPath = illsArray[indexPath.row].fotoRecept
            
            ref?.child("children").child(uid).child("IllnessList").child("\(id)").removeValue()
            illsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if imgPath != ""{
                let storage = Storage.storage()
                let url = storage.reference(forURL: imgPath)
                url.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Success delete")
                    }
                }
                
            }
            
        }
    }
    func refreshProfileImage(){
        if childPerson.image == ""{
            fotoImage.image = UIImage(named: "avatar_default")
        }else{
            let store = Storage.storage()
            let storeRef = store.reference(forURL: childPerson.image)
            
            storeRef.downloadURL { url, error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            self.fotoImage.image = image
                        }
                    }
                }
            }
        }
    }
}
