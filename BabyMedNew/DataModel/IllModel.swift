//
//  IllModel.swift
//  BabyMedNew
//
//  Created by Oleg Ten on 7/3/18.
//  Copyright © 2018 Oleg Ten. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class IllChild {
    var illUserID = ChildModel(Id: "")
    var id = NSUUID().uuidString
    var simptoms : String!
    var treatment : String!
    var illName : String!
    var DateIll : String!
    var ref: FirebaseApp?
    
    init(snapshot: DataSnapshot){
//        self.simptoms = snapshot.value["simptoms"] as! String
//        self.treatment = snapshot.value["treatment"] as! String
//        self.illName = snapshot.value["illName"] as! String
//        self.DateIll = snapshot.value["DateIll"] as! String
        
    }
}
