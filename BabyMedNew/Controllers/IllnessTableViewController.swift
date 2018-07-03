//
//  IllnessTableViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class IllnessTableViewController: UITableViewController {

    
    let realm = try! Realm()
    var illArray : Results<IllModel>!
    
    var selectedChild : ChildModel? {
        didSet{
            loadIllness()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //    loadIllness()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return illArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let ill = illArray?[indexPath.row]{
        cell.textLabel?.text = ill.illName
        cell.detailTextLabel?.text = ill.DateIll
        
        }else{
            cell.textLabel?.text = "No ills Added"
        }
        return cell
    }
    
    //MARK TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let ill = illArray?[indexPath.row]{
//
//            do{
//                try realm.write {
//                    ill.done = !item.done
//                }
//
//            }catch{
//                print("Error")
//            }
//        }
//        tableView.reloadData()
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

   
 //   override func updateData(at IndexPath: IndexPath) {
//        if let item = todoItems?[IndexPath.row]{
//            
//            do{
//                try realm.write {
//                    realm.delete(item)
//                }
//                
//            }catch{
//                print("Error")
//            }
//        }
//        tableView.reloadData()
        
 //   }
    
    
    func loadIllness() {
        
        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)
        
        tableView.reloadData()
    }

}


   

