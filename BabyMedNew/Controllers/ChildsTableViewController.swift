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

struct childStruct {
    let name: String!
    let birthDay: String!
    let blood: String!
    let weight: String!
    let gender: String!
}

class ChildsTableViewController: UITableViewController {

    let realm = try! Realm()
    var childsArray : Results<ChildModel>!
    //var ref: DatabaseReference?

    var ArrayChild =  [DataSnapshot]()
    var children = [childStruct]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadChildsData()

        //MARK FireBase
        
        let ref = Database.database().reference()
        ref.child("Childs").queryOrderedByKey().observe(.childAdded, with: { snapshot in
            
            let snapVal = snapshot.value as? [String : AnyObject] ?? [:]
            if  let name = snapVal["childName"],
                let birthDay = snapVal["birthDay"],
                let blood = snapVal["blood"],
                let weight = snapVal["weight"],
                let gender = snapVal["gender"]{
                
                self.children.insert(childStruct(name: name as! String, birthDay: birthDay as! String, blood: blood as! String, weight: weight as! String, gender: gender as! String), at: 0)
                print(self.children.count)
            }
            self.tableView.reloadData()

        })
        
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count//childsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
        if let imageName = childsArray?[indexPath.row].name, let imageBd = childsArray?[indexPath.row].birthDate{
            let imageAvatar =  getImage(imageName:"\(imageName)+\(imageBd)")
            print(imageAvatar)
            
            cell?.labelName.text = children[indexPath.row].name
            cell?.labelAge.text = children[indexPath.row].birthDay
//            cell?.labelName.text = childsArray?[indexPath.row].name ?? "No Child added"
//            cell?.labelAge.text = childsArray?[indexPath.row].birthDate
            cell?.imageFoto.image = imageAvatar
        
        }
        
        
        return cell!
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let child = childsArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonalViewController") as! PersonalViewController
        
        vc.name = child.name
        vc.bd = child.birthDate
        vc.blood = child.blood
        vc.weight = child.weight
        vc.gen = child.gender
        vc.indexPath = indexPath
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
           
            if let item = childsArray?[indexPath.row]{
                
                do{
                    try realm.write {
                        realm.delete(item)
                    }
                    
                }catch{
                    print("Error")
                }
            }
             
        }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    
    
    func loadChildsData() {
        
        childsArray = realm.objects(ChildModel.self)
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
