//
//  DescriptionIllViewController.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit

class DescriptionIllViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = name
        birthDayLabel.text = bd
        nameIllLabel.text = nameIll
        dateLabel.text = date
        simptomsTextView.text = simptoms
        treatmentTextView.text = treatment
    }

}
