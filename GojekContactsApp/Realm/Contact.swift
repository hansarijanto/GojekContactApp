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
    @objc dynamic var firstName  : String = ""
    @objc dynamic var lastName   : String = ""
    @objc dynamic var email      : String = ""
    @objc dynamic var mobile     : String = ""
    @objc dynamic var imgUrl     : String = ""
    @objc dynamic var isFavorite : Bool = false
}
