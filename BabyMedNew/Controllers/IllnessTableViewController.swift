//
//  IllnessTableViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class IllnessTableViewController: UITableViewController {
   
    var ref: DatabaseReference?

  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadIllness()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
   
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
 
        return cell
    }
    
    //MARK TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDescriptionIll", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDescriptionIll",
            let _ = segue.destination as? DescriptionIllViewController{
        }
        
        
    }
    func loadIllness() {
        
        ref = Database.database().reference()
        
        ref?.child("Childs").child("ills").observe(.childAdded, with: { snapshot  in
            
            let snapVal = snapshot.value as! Dictionary<String, Any>
            print(snapVal)
            
            for item in snapshot.children{
                let data = item as! DataSnapshot
                
                let child = data.value as! [String : Any]
                
                print(child)

            }
        })
       
        tableView.reloadData()
        
    }
    
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")

            
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}


   

