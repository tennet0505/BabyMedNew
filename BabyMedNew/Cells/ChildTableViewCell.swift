//
//  ChildTableViewCell.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 02.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var imageFoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageFoto.layer.cornerRadius  = imageFoto.frame.size.width/2
        imageFoto.layer.masksToBounds = true
    }
}
