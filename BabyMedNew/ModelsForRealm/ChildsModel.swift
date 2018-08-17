//
//  ChildsModel.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 17.08.2018.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import Foundation
import RealmSwift

class ChildRealm: Object {
   
    @objc dynamic var Id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var birthDate : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var blood : String = ""
    @objc dynamic var weight : String = ""
    @objc dynamic var image : String = ""
    @objc dynamic var userEmail : String = ""
    
    var ills = List<IllsRealm>()
}
