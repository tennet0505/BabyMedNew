//
//  ChildsTableViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import Firebase

struct ChildModel{
    
    var Id = ""
    var name = ""
    var birthDate = ""
    var gender = ""
    var blood = ""
    var weight = ""
    var image = String()
    var userEmail = ""
    var ills = [IllModel]()
    
    init(Id: String?, name: String?, birthDate: String?,  gender: String?, blood: String?, image: String?, weight: String?, userEmail: String?) {
        self.Id = Id!
        self.name = name!
        self.birthDate = birthDate!
        self.gender = gender!
        self.blood = blood!
        self.image = image!
        self.weight = weight!
        self.userEmail = userEmail!
       // self.ills = ills!
    }
    init(Id: String?) {
        self.Id = Id!
    }
   
    init(ill: [IllModel]?) {
        self.ills = ill!
    }
    
}


class ChildsTableViewController: UITableViewController {

    var ref: DatabaseReference?

    var ArrayChild =  [DataSnapshot]()
    var childArray = [ChildModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadChildsData()

    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childArray.count//childsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
        
        cell?.labelName.text = childArray[indexPath.row].name
        cell?.labelAge.text = childArray[indexPath.row].birthDate
        cell?.imageFoto.image = getImage(imageName: childArray[indexPath.row].image)
        
        return cell!
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let child = childArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonalViewController") as! PersonalViewController
        
        vc.name = child.name
        vc.bd = child.birthDate
        vc.blood = child.blood
        vc.weight = child.weight
        vc.gen = child.gender
        vc.indexPath = indexPath
        vc.imageFoto = child.image
        vc.uidUser = child.Id
        vc.userEmail = child.userEmail
        vc.childPerson = child
    
     //   present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)

        
     //   performSegue(withIdentifier: "ToPersonal", sender: self)

    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let vc = segue.destination as! PersonalViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow{
//
//            let child = childsArray[indexPath.row]
//
//            vc.name = child.name
//            vc.bd = child.birthDate
//            vc.blood = child.blood
//            vc.weight = child.weight
//            vc.gen = child.gender
//            vc.indexPath = indexPath
//
//           // vc.selectedCategory = childsArray?[indexPath.row]
//        }
//
//
//    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        if editingStyle == .delete {
            print("Deleted")
      
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    func loadChildsData() {
        
        ref = Database.database().reference()
        ref?.child("Childs").observe(.childAdded, with: { snapshot  in
            
            for item in snapshot.children{
                let data = item as! DataSnapshot
               
                let child = data.value as! [String : Any]
                
             if
                let name = child["name"],
                let birthDay = child["birthDate"],
                let blood = child["blood"],
                let weight = child["weight"],
                let userEmail = child["userEmail"],
                let image = child["image"],
                let gender = child["gender"],
                let idString =  child["Id"]
                {
                
                 
                self.childArray.insert(ChildModel(Id: idString as? String,
                                                  name: name as? String,
                                                  birthDate: birthDay as? String,
                                                  gender: gender as? String,
                                                  blood: blood as? String,
                                                  image: image as? String,
                                                  weight: weight as? String,
                                                  userEmail: userEmail as? String), at: 0)

              
            self.tableView.reloadData()
                }
            }
        })
        
        tableView.reloadData()
        
    }

    func getImage(imageName: String) -> UIImage{
        
        var decodeImage = UIImage()
        if  let decode  = NSData(base64Encoded: imageName, options: .ignoreUnknownCharacters){
            decodeImage = UIImage(data: decode as Data) ?? UIImage(named: "avatar_default")!
        }
        return decodeImage
    }

}
