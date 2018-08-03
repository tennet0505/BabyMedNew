//
//  DescriptionIllViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit
import RealmSwift

class DescriptionIllViewController: UIViewController {
    let realm = try! Realm()
    var childsArray : Results<ChildModel>!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var nameIllLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var simptomsTextView: UITextView!
    @IBOutlet weak var treatmentTextView: UITextView!
    
    var name = ""
    var bd = ""
    var nameIll = ""
    var date = ""
    var simptoms = ""
    var treatment = ""
    
    var ill = IllModel()
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = name
        birthDayLabel.text = bd
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        birthDayLabel.text = bd
        nameIllLabel.text = nameIll
        dateLabel.text = date
        simptomsTextView.text = simptoms
        treatmentTextView.text = treatment
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toIllForEdit",
            let vc = segue.destination as? NewIllnesViewController{
            
            vc.simptom = ill.simptoms
            vc.treatment = ill.treatment
            vc.ill = ill.illName
            vc.date = ill.DateIll
            vc.editValue = 1
            vc.idIll = ill.id
            vc.name = name
            vc.birthdate = date
            
        }
       
    }
    
    @IBAction func buttonEdit(_ sender: Any) {
        performSegue(withIdentifier: "toIllForEdit", sender: self)

    }
    
    

}
