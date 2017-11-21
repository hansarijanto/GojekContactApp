//
//  ContactManager.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContactManagerDelegate: class {
    func didDownloadContacts() // called when the manager has completed downloading all the contacts and has saved them to Realm
}

class ContactManager {
    // singleton
    static let shared: ContactManager = ContactManager()
    
    // constants
    static private let gojekBaseUrl: String             = "http://gojek-contacts-app.herokuapp.com"
    static private let gojekContactExtensionUrl: String = "/contacts.json"
    static private let didDownloadKey                   = "didDownloadGojekContactsKey"
    
    private var isFetchingData: Bool = false
    
    public weak var delegate: ContactManagerDelegate? = nil
    
    init() {
        // TODO: error handling in case realm error
        let realm: Realm = try! Realm()
        
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
    public func fetchContacts() {
        
        // prevent fetching contacts if we have already downloaded gojek contacts, or if we're currently fetching data
        if self.didDownloadGojekContacts() || self.isFetchingData {
            return
        }
        
        self.isFetchingData = true
        weak var weakSelf   = self
        
        // call gojek api
        let url = ContactManager.gojekBaseUrl + ContactManager.gojekContactExtensionUrl
        HTTPManager.shared.get(urlString: url, completionBlock: {(data: Data) -> Void in
            if let strongSelf = weakSelf {
                var dataArr: [[String: Any]] = [[String: Any]]()
                
                // format contacts data to json
                do {
                    dataArr = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                } catch {
                    print(error.localizedDescription)
                }
                
                // loop through json array of contacts data
                for personData in dataArr {
                    if let firstName  = personData["first_name"] as? String, let lastName = personData["last_name"] as? String, var imgUrl = personData["profile_pic"] as? String, let isFavorite = personData["favorite"] as? Bool, let apiId = personData["id"] as? Int {

                        // completing the url for missing images
                        if imgUrl == "/images/missing.png" {
                            imgUrl = ContactManager.gojekBaseUrl + imgUrl
                        }
                        
                        // added new contact to realm
                        if !ContactManager.shared.saveNewContact(firstName: firstName, lastName: lastName, isFavorite: isFavorite, imgUrl: imgUrl, apiId: apiId) {
                            print("Failed to save contact after download to realm with id: \(apiId)")
                        }
                    }
                }
                
                UserDefaults.standard.set(true, forKey: ContactManager.didDownloadKey)
                strongSelf.isFetchingData = false
                self.delegate?.didDownloadContacts() // callback for delegate
            }
        })
    }
    
    // returns all contact from realm
    public func contacts() -> [Contact] {
        let realm: Realm = try! Realm()
        return Array(realm.objects(Contact.self))
    }
    
    // saves a new contact into realm, returns true if successful
    public func saveNewContact(firstName: String, lastName: String, isFavorite: Bool, imgUrl: String, apiId: Int) -> Bool {
        var isSuccess: Bool = false
        let realm: Realm = try! Realm()
        do {
            try realm.write {
                let contact = Contact()
                contact.firstName  = firstName
                contact.lastName   = lastName
                contact.isFavorite = isFavorite
                contact.imgUrl     = imgUrl
                contact.apiId      = apiId
                realm.add(contact)
                isSuccess = true
            }
        } catch let error as NSError {
            print("saveNewContact in Contact Manager failed: \(error)")
        }
        
        return isSuccess
    }
    
    public func didDownloadGojekContacts() -> Bool {
        return UserDefaults.standard.bool(forKey: ContactManager.didDownloadKey)
    }
}

