//
//  PersonalViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class PersonalViewController: UIViewController {

    let realm = try! Realm()
    var childsArray : Results<ChildModel>!

    var name = ""
    var bd = ""
    var gen = ""
    var weight = ""
    var blood = ""
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    var indexPath = IndexPath()
    
    @IBOutlet weak var tableView: UITableView!
    
    var illArray : Results<IllModel>!
    
    var selectedChild : ChildModel? {
        didSet{
            loadIllness()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        selectedChild = childsArray[indexPath.row]
        print(indexPath)
        
    }
 
    func loadChildsData() {
        
        childsArray = realm.objects(ChildModel.self)
        
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ToIllness",
        
            let vc = segue.destination as? IllnessTableViewController{

            let index = indexPath

            vc.selectedChild = childsArray?[index.row]
        }
        if segue.identifier == "ToNewIllness",
            
            let vc = segue.destination as? NewIllnesViewController{
            
            let index = indexPath
            
            vc.selectedChild = childsArray?[index.row]
        }
        
        if segue.identifier == "toDescriptionIll",
            let vc = segue.destination as? DescriptionIllViewController{
            
            let child = selectedChild
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let ill = illArray[indexPath.row]
                vc.simptoms = ill.simptoms
                vc.treatment = ill.treatment
                vc.nameIll = ill.illName
                vc.date = ill.DateIll
                vc.name = (child?.name)!
                vc.bd = (child?.birthDate)!
                vc.ill = ill
            }
        }
        if segue.identifier == "toPersonalForEdit",
            let vc = segue.destination as? NewChildViewController{
            
           

           // if let indexPath = tableView.indexPathForSelectedRow{
             let child = childsArray[indexPath.row]
                
                vc.name = child.name
                vc.bd =  child.birthDate
                vc.gen = child.gender
                vc.weight = child.weight
                vc.blood = child.blood
                vc.idChild = child.id
                vc.editValue = 1
            }
       // }
    }
    func loadIllness() {
        
        illArray = selectedChild?.ills.sorted(byKeyPath: "illName", ascending: true)
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
    

}
extension PersonalViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return illArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
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
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toDescriptionIll", sender: self)
        
        
    }
    
  
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Deleted")
            
            if let item = illArray?[indexPath.row]{
                
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
    
}
