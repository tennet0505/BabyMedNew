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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        birthDayLabel.text = bd
        genderLabel.text = gen
        weightLabel.text = weight
        bloodLabel.text = blood
        
        print(indexPath)
        

        loadChildsData()
        
       
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
        
        
    }
    @IBAction func allIllnessButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ToIllness", sender: self)
    }
    
    @IBAction func newIllButton(_ sender: UIButton) {
         performSegue(withIdentifier: "ToNewIllness", sender: self)
    }
    

}
