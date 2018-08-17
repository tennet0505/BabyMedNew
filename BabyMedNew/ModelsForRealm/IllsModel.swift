//
//  IllsModel.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 17.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import Foundation
import RealmSwift

class IllsRealm: Object {
   
    
    @objc dynamic var idIll : String = ""
    @objc dynamic var simptoms : String = ""
    @objc dynamic var treatment : String = ""
    @objc dynamic var illName : String = ""
    @objc dynamic var DateIll : String = ""
    @objc dynamic var fotoRecept : String = ""
    
    var parentChild = LinkingObjects(fromType: ChildRealm.self, property: "ills")
}
