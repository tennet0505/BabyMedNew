//
//  ChildsTableViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class ChildsTableViewController: UITableViewController {

    let realm = try! Realm()
    var childsArray : Results<ChildModel>!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadChildsData()
     
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChildTableViewCell
        
        cell?.labelName.text = childsArray?[indexPath.row].name ?? "No Child added"
        cell?.labelAge.text = childsArray?[indexPath.row].birthDate
        
        
        
        return cell!
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        performSegue(withIdentifier: "ToPersonal", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let vc = segue.destination as! PersonalViewController

        if let indexPath = tableView.indexPathForSelectedRow{

            let child = childsArray[indexPath.row]
            
            vc.name = child.name
            vc.bd = child.birthDate
            vc.blood = child.blood
            vc.weight = child.weight
            vc.gen = child.gender
            vc.indexPath = indexPath
            
           // vc.selectedCategory = childsArray?[indexPath.row]
        }
      
        
    }
    
    
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
    
    
  

   

}
