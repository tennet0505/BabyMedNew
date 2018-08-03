//
//  ChildModel.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import Foundation
import RealmSwift

class ChildModel: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var birthDate = ""
    @objc dynamic var gender = ""
    @objc dynamic var blood = ""
    @objc dynamic var weight = ""
    @objc dynamic var image = String()
    
    override static func primaryKey() -> String? {
        return "id"
    }
   
    let ills = List<IllModel>()
    
    
}

