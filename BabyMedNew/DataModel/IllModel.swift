//
//  IllModel.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import Foundation
import RealmSwift

class IllModel: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var simptoms = ""
    @objc dynamic var treatment = ""
    @objc dynamic var illName = ""
    @objc dynamic var DateIll = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var parentChild = LinkingObjects(fromType: ChildModel.self, property: "ills")
    
   
}
