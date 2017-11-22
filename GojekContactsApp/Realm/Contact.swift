//
//  Contact.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import Foundation
import RealmSwift

// Realm supports the following property types: Bool, Int, Int8, Int16, Int32, Int64, Double, Float, String, Date, and Data
// String, Date, and Data properties can be declared as optional or required (non-optional) using standard Swift syntax. Optional numeric types are declared using the RealmOptional type
// let age = RealmOptional<Int>()

class Contact: Object {
    @objc private(set) dynamic var id : String = UUID().uuidString
    @objc dynamic var apiId           : Int    = -1 // -1 is invalid means locally made
    
    @objc dynamic var firstName     : String? = nil
    @objc dynamic var lastName      : String? = nil
    @objc dynamic var email         : String? = nil
    @objc dynamic var mobile        : String? = nil
    @objc dynamic var imageFileName : String? = nil
    @objc dynamic var isFavorite    : Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
