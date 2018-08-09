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
    var ill = [IllModel]()
    
    init(Id: String?, name: String?, birthDate: String?,  gender: String?, blood: String?, weight: String?, ill: [IllModel]?) {
        self.Id = Id!
        self.name = name!
        self.birthDate = birthDate!
        self.gender = gender!
        self.blood = blood!
        self.weight = weight!
    //    self.ill = ill!
    }
    init(Id: String?) {
        self.Id = Id!
    }
   
    init(ill: [IllModel]?) {
        self.ill = ill!
    }
    
}


class ChildsTableViewController: UITableViewController {

//    let realm = try! Realm()
//    var childsArray : Results<ChildModel>!
    var ref: DatabaseReference?

    var ArrayChild =  [DataSnapshot]()
    var childArray = [ChildModel]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadChildsData()

        
        
        //MARK FireBase
        
      
        
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childArray.count//childsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
//        if let imageName = childsArray?[indexPath.row].name, let imageBd = childsArray?[indexPath.row].birthDate{
//            let imageAvatar =  getImage(imageName:"\(imageName)+\(imageBd)")
//            cell?.imageFoto.image = imageAvatar
//            print(imageAvatar)
//        }
            cell?.labelName.text = childArray[indexPath.row].name
            cell?.labelAge.text = childArray[indexPath.row].birthDate
//            cell?.labelName.text = childsArray?[indexPath.row].name ?? "No Child added"
//            cell?.labelAge.text = childsArray?[indexPath.row].birthDate
        
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
        vc.uidUser = child.Id
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
        
        if editingStyle == .delete {
            print("Deleted")
           
//            if let item = childsArray?[indexPath.row]{
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
    
    
    func loadChildsData() {
        
        ref = Database.database().reference()

        ref?.child("Childs").observe(.childAdded, with: { snapshot  in
            
            let snapVal = snapshot.value as! Dictionary<String, Any>
            print(snapVal)
          
            for item in snapshot.children{
                let data = item as! DataSnapshot
               
                let child = data.value as! [String : Any]
                
                print(child["userID"]) ////////////////////////////
                
             if let id = child["userID"],
                let name = child["childName"],
                let birthDay = child["birthDay"],
                let blood = child["blood"],
                let weight = child["weight"],
                let gender = child["gender"]
                {
                let ill = child["ills"]
                    let idString = id
                print(idString)
                self.childArray.insert(ChildModel(Id: idString as? String,
                                                  name: name as? String,
                                                  birthDate: birthDay as? String,
                                                  gender: gender as? String,
                                                  blood: blood as? String,
                                                  weight: weight as? String,
                                                  ill: ill as? [IllModel]), at: 0)

              
            self.tableView.reloadData()
                }
                print(self.childArray)
            }
        })
        //        childsArray = realm.objects(ChildModel.self)
        tableView.reloadData()
        
    }
func getImage(imageName: String) -> UIImage{
        var fotoImage = UIImage()
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            fotoImage = UIImage(contentsOfFile: imagePath)!
        }else{
            print("Panic! No Image!")
        }
        return fotoImage
    }
    

}
