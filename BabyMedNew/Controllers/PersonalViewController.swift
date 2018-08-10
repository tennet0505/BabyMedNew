//
//  PersonalViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth
import Firebase

class PersonalViewController: UIViewController, NewChildDataProtocol {
   
    

//    let realm = try! Realm()
//    var childsArray : Results<ChildModel>!
    var ref: DatabaseReference?
    var children = [ChildModel]()
    var name = ""
    var bd = ""
    var gen = ""
    var weight = ""
    var blood = ""
    var uidUser = ""
    var userEmail = ""
    var illsArray = [ChildModel]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    
    @IBOutlet weak var fotoImage: UIImageView!
    var indexPath = IndexPath()
    
    @IBOutlet weak var tableView: UITableView!
    
//    var illArray : Results<IllModel>!
    
    var selectedChild : ChildModel? {
        didSet{
            loadIllness()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadChildsData()
        loadIllness()
        getImage(imageName: "\(name)+\(bd)")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChildsData()
        nameLabel.text = name
        birthDayLabel.text = bd
        genderLabel.text = gen
        weightLabel.text = weight
        bloodLabel.text = blood
//        selectedChild = children[indexPath.row]
        print(indexPath)
        
    }

   
 
    func loadChildsData() {
        
//        childsArray = realm.objects(ChildModel.self)
        
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ToIllness",
        
            let vc = segue.destination as? IllnessTableViewController{

            let index = indexPath

     //       vc.selectedChild = children?[index.row]
        }
        if segue.identifier == "ToNewIllness",
            
            let vc = segue.destination as? NewIllnesViewController{
            vc.uidUser = uidUser
//            print(uidUser)
            let index = indexPath
            
     //       vc.selectedChild = children?[index.row]
        }
        
        if segue.identifier == "toDescriptionIll",
            let vc = segue.destination as? DescriptionIllViewController{
            
            let child = selectedChild
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
//                let ill = illArray[indexPath.row]
//                vc.simptoms = ill.simptoms
//                vc.treatment = ill.treatment
//                vc.nameIll = ill.illName
//                vc.date = ill.DateIll
//                vc.name = (child?.name)!
//                vc.bd = (child?.birthDate)!
//                vc.ill = ill
            }
        }
        if segue.identifier == "toPersonalForEdit",
            let vc = segue.destination as? NewChildViewController{
            
            
            
            let child = children[indexPath.row]
            
            vc.name = child.name
            vc.bd =  child.birthDate
            vc.gen = child.gender
            vc.weight = child.weight
            vc.blood = child.blood
//            vc.idChild = child.id
            vc.editValue = 1
            vc.delegate = self
        }
    }
    
    func newDataChild(childEdit: ChildModel) {
//        child = childEdit
//        nameLabel.text = child.name
//        birthDayLabel.text = child.birthDate
//        genderLabel.text = child.gender
//        weightLabel.text = child.weight
//        bloodLabel.text = child.blood
        
        
    }
    func loadIllness() {
            
            ref = Database.database().reference()
            print(uidUser)
        ref?.child("Childs").child(uidUser).observe(.childAdded, with: { snapshot  in
            
            print(snapshot)
            if let value = snapshot.value as? ChildModel{
            print(value)
            self.illsArray.append(value)
                print(self.illsArray)}
            //                for item in snapshot.children{
            //                    let data = item as! DataSnapshot
            //
            //                    let child = data.value as! ChildModel
            
            
//                    if let id = child["userID"],
//                        let name = child["childName"],
//                        let birthDay = child["birthDay"],
//                        let blood = child["blood"],
//                        let weight = child["weight"],
//                        let userEmail = child["userEmail"],
//                        let gender = child["gender"]
//                    {
//                        let ill = child["ills"]
//                        let idString = id
//                        //                print(idString)
////                        self.illsArray.insert(ChildModel(Id: idString as? String,
////                                                          name: name as? String,
////                                                          birthDate: birthDay as? String,
////                                                          gender: gender as? String,
////                                                          blood: blood as? String,
////                                                          weight: weight as? String,
////                                                          userEmail: userEmail as? String,
////                                                          ill: ill as? [IllModel]), at: 0)
////
//
//                        self.tableView.reloadData()
                    
                    print(self.illsArray)
//                }
            
            })
        //        childsArray = realm.objects(ChildModel.self)
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
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            fotoImage.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("Panic! No Image!")
        }
    }
    
   
}
extension PersonalViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1//illArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        if let ill = illArray?[indexPath.row]{
//            cell.textLabel?.text = ill.illName
//            cell.detailTextLabel?.text = ill.DateIll
//
//        }else{
//            cell.textLabel?.text = "No ills Added"
//        }
        return cell
    }
    
    //MARK TableView Delegate methods
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toDescriptionIll", sender: self)
        
        
    }
    
  
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
//            if let item = illArray?[indexPath.row]{
//
//                do{
//                    try realm.write {
//                        realm.delete(item)
//                    }
//
//                }catch{
//                    print("Error")
//                }
//            }
            
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
