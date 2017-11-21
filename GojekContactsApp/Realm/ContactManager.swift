//
//  ContactManager.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import Foundation
import RealmSwift

class ContactManager {
    // singleton
    static let shared: ContactManager = ContactManager()
    
    private let realm: Realm
    
    init() {
        // TODO: error handling in case realm error
        self.realm = try! Realm()
        
        // this function is called on app load to allow realm to edit the realm file even when the app is backgrounded
        // this is because in IOS 8 and above when a device is locked all files in the app are encrypted using NSFileProtection
        
        // Get our Realm file's parent directory
        let folderPath = realm.configuration.fileURL!.deletingLastPathComponent().path
        // Disable file protection for this directory
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none],
                                               ofItemAtPath: folderPath)
        
        // Use the default directory, but replace the filename
        let realmFileName = "AppData"
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(realmFileName).realm")
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    // grabs all contacts from the gojek API
    //    public func fetchContacts() -> [Contact] {
    //
    //    }
    
    // returns all contact from realm
    public func contacts() -> [Contact] {
        return Array(self.realm.objects(Contact.self))
    }
    
    // saves a new contact into realm, returns true if successful
    public func saveNewContact(contact: Contact) -> Bool {
        var isSuccess: Bool = false
        do {
            try realm.write {
                realm.add(contact)
                isSuccess = true
            }
        } catch let error as NSError {
            print("saveNewContact in Contact Manager failed: \(error)")
        }
        
        return isSuccess
    }
}

