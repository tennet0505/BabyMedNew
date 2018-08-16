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

struct IllModel {
    
    var idIll = ""
    var simptoms = ""
    var treatment = ""
    var illName = ""
    var DateIll = ""
    var fotoRecept = ""
    
    init(idIll: String?, simptoms: String?, treatment: String?, illName: String?,  DateIll: String?, fotoRecept: String?) {
        self.idIll = idIll!
        self.simptoms = simptoms!
        self.treatment = treatment!
        self.illName = illName!
        self.DateIll = DateIll!
        self.fotoRecept = fotoRecept!
        
    }
}

class PersonalViewController: UIViewController, NewChildDataProtocol {

    var ref: DatabaseReference?
    var name = ""
    var bd = ""
    var gen = ""
    var weight = ""
    var blood = ""
    var uidUser = ""
    var userEmail = ""
    var imageFoto = ""
    var illsArray = [IllModel]()
    var child = [ChildModel]()
    var childPerson: ChildModel = ChildModel(Id: "",
                                             name: "",
                                             birthDate: "",
                                             gender: "",
                                             blood: "",
                                             image: "",
                                             weight: "",
                                             userEmail: "")
    
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
        
      
        
        
        getImage(imageName: childPerson.image)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIllness()
        nameLabel.text = name
        birthDayLabel.text = bd
        genderLabel.text = gen
        weightLabel.text = weight
        bloodLabel.text = blood
        getImage(imageName: imageFoto)
 
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ToIllness",
        
            let vc = segue.destination as? IllnessTableViewController{

            let index = indexPath

        }
        if segue.identifier == "ToNewIllness",
            
            let vc = segue.destination as? NewIllnesViewController{
            vc.uidUser = uidUser
            let index = indexPath
        }
        
        if segue.identifier == "toDescriptionIll",
            let vc = segue.destination as? DescriptionIllViewController{
            
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let ill = illsArray[indexPath.row]
                vc.simptoms = ill.simptoms
                vc.treatment = ill.treatment
                vc.nameIll = ill.illName
                vc.date = ill.DateIll
                vc.name = name
                vc.image = ill.fotoRecept
                vc.bd = bd
                vc.uidUser = uidUser
                vc.idIll = ill.idIll

            }
        }
        if segue.identifier == "toPersonalForEdit",
          
            let vc = segue.destination as? NewChildViewController{
            let child = self.childPerson
            vc.childPerson = child
            vc.idChild = childPerson.Id
            vc.editValue = 1
            vc.delegate = self
        }
    }
    
    func newDataChild(childEdit: ChildModel) {
        childPerson = childEdit
        nameLabel.text = childPerson.name
        birthDayLabel.text = childPerson.birthDate
        genderLabel.text = childPerson.gender
        weightLabel.text = childPerson.weight
        bloodLabel.text = childPerson.blood
        getImage(imageName: childPerson.image)
        
    }
    func loadIllness() {
        
        ref = Database.database().reference()
        ref?.child("Childs").child(uidUser).child("Ills").observe(.childAdded, with: { snapshot  in
            
            if let getData = snapshot.value as? [String:Any] {
                
                if
                    let idIll = getData["idIll"],
                    let illName = getData["illName"],
                    let DateIll = getData["DateIll"],
                    let simptoms = getData["simptoms"],
                    let treatment = getData["treatment"],
                    let fotoRecept = getData["fotoRecept"]
                {
                    let illmodel = IllModel(idIll: idIll as? String,
                                            simptoms: simptoms as? String,
                                            treatment: treatment as? String,
                                            illName: illName as? String,
                                            DateIll: DateIll as? String,
                                            fotoRecept: fotoRecept as? String
                    )
                    
                    self.illsArray.insert(illmodel, at: 0)
                    
                }
                 self.tableView.reloadData()
            }
        })
        tableView.reloadData()
        
    }
    
    
    @IBAction func allIllnessButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ToIllness", sender: self)
    }
    
    @IBAction func newIllButton(_ sender: UIButton) {
         performSegue(withIdentifier: "ToNewIllness", sender: self)
    }
    
    @IBAction func buttonEdit(_ sender: Any) {
        performSegue(withIdentifier: "toPersonalForEdit", sender: self)
        
    }
   
    func getImage(imageName: String){
        let decode  = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters)
        let decodeImage = UIImage(data: decode! as Data)
        fotoImage.image = decodeImage
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
            
            ref?.child("Childs").child(uidUser).child("Ills").child("\(id)").removeValue()
            illsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
