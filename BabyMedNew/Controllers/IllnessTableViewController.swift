//
//  IllnessTableViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

struct IllModel {
    
    var illUserID = ChildModel(Id: "")
    var id = NSUUID().uuidString
    var simptoms = ""
    var treatment = ""
    var illName = ""
    var DateIll = ""
}

class IllnessTableViewController: UITableViewController {
   
   
    
//    let realm = try! Realm()
//    var illArray : Results<IllModel>!
    
    var selectedChild : ChildModel? {
        didSet{
            loadIllness()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
   
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        if let ill = illArray?[indexPath.row]{
//        cell.textLabel?.text = ill.illName
//        cell.detailTextLabel?.text = ill.DateIll
        
//        }else{
//            cell.textLabel?.text = "No ills Added"
//        }
        return cell
    }
    
    //MARK TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDescriptionIll", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDescriptionIll",
            let vc = segue.destination as? DescriptionIllViewController{
            
            
        let child = selectedChild
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
//            let ill = illArray[indexPath.row]
           
            
//            vc.simptoms = ill.simptoms
//            vc.treatment = ill.treatment
//            vc.nameIll = ill.illName
//            vc.date = ill.DateIll
//            vc.name = (child?.name)!
//            vc.bd = (child?.birthDate)!
//
            }
     
           
        }
        
        
    }
    
    
    func loadIllness() {
        
//        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)
        
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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


   

