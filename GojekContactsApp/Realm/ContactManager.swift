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
    // TODO: Can make didDownloadContacts more descriptive by providing reason for failure
    func didDownloadContacts(success: Bool) // called when the manager has completed downloading all the contacts and has saved them to Realm
    func didStartDownload()                 // called when the manager has started downloading contacts
}

class ContactManager {
    // singleton
    static let shared: ContactManager = ContactManager()
    
    // constants
    static private let gojekBaseUrl: String             = "http://gojek-contacts-app.herokuapp.com"
    static private let gojekContactExtensionUrl: String = "/contacts.json"
    static private let didDownloadKey                   = "didDownloadGojekContactsKey"
    static public let alphabet: [String]                = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    
    private let contactImageFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // url of where we save contact images downloaded to
    private var isFetchingData: Bool  = false
    
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
        
        self.delegate?.didStartDownload()
        
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
                    
                    let contact = Contact()
                    
                    if let firstName = personData["first_name"] as? String {
                        contact.firstName  = firstName
                    }
                    
                    if let lastName = personData["last_name"] as? String {
                        contact.lastName  = lastName
                    }
                    
                    if let imgUrl = personData["profile_pic"] as? String {
                        // if url is missing then we set it to default
                        if imgUrl != "/images/missing.png" {
                            // download image
                            if let apiId = personData["id"] as? Int {
                                let filename = "\(apiId).png"
                                if self.downloadImage(stringUrl: imgUrl, filename: filename) {
                                    contact.imageFileName = filename
                                }
                            }
                        }
                    }
                    
                    if let isFavorite = personData["favorite"] as? Bool {
                        contact.isFavorite = isFavorite
                    }
                    
                    if let apiId = personData["id"] as? Int {
                        contact.apiId = apiId
                    }
                    
                    if let mobile = personData["mobile"] as? String {
                        contact.mobile = mobile
                    }
                    
                    if let email = personData["email"] as? String {
                        contact.email = email
                    }
                    
                    // added new contact to realm
                    if !self.saveNewContact(contact: contact) {
                        print("Failed to save contact after download to realm with id: \(contact.apiId)")
                    }
                    
                }
                
                UserDefaults.standard.set(true, forKey: ContactManager.didDownloadKey)
                strongSelf.isFetchingData = false
                self.delegate?.didDownloadContacts(success: true) // callback for delegate
            } else {
                self.delegate?.didDownloadContacts(success: false)
            }
        })
    }
    
    // donwload contact image to a designated
    public func downloadImage(stringUrl: String, filename: String) -> Bool {
        if let url = URL(string: stringUrl) {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data : data), let pngImageData = UIImagePNGRepresentation(image) {
                    let fileURL = self.contactImageFolderURL.appendingPathComponent(filename)
                    try pngImageData.write(to: fileURL, options: .atomic)
                }
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    // load contact image given a contact
    public func loadContactImage(contact: Contact) -> UIImage? {
        if let fn = contact.imageFileName {
            let filePath = self.contactImageFolderURL.appendingPathComponent(fn).path
            if FileManager.default.fileExists(atPath: filePath) {
                return UIImage(contentsOfFile: filePath)
            }
        }
        
        return nil
    }
    
    // returns all contact from realm
    public func contacts() -> [Contact] {
        let realm: Realm = try! Realm()
        return Array(realm.objects(Contact.self))
    }
    
    // returns all contacts that are either favorites or not favorites
    public func contacts(isFavorite: Bool) -> [Contact] {
        let realm: Realm = try! Realm()
        return Array(realm.objects(Contact.self).filter("isFavorite == \(isFavorite)"))
    }
    
    private func sortContactsArr(contacts: [Contact]) -> [Contact] {
        return contacts.sorted(by: {
            if $0.firstName == nil {
                return true
            } else if $1.firstName == nil {
                return false
            }
            
            return $0.firstName! < $1.firstName!
        })
    }
    
    private func filterContactsArrByAlphabet(contacts: [Contact], alphabet: String) -> [Contact] {
        return contacts.filter({
            if let fn = $0.firstName, let firstCharacter = fn.lowercased().first {
                if alphabet == "#" {
                    let sFC = String(firstCharacter)
                    return sFC == "#" || !ContactManager.alphabet.contains(sFC.uppercased())
                } else {
                    return firstCharacter == alphabet.lowercased().first
                }
            }
            
            if alphabet == "#" {
                return true
            }
            
            return false
        })
    }
    
    // returns all contacts sorted by first name and and favorites being first, key is alphabet
    public func contactsSorted() -> [String: [Contact]] {
        // key here is the associated alphabet and the contacts are all contacts sorted by first name (favorites have priority)
        var contactsDict: [String: [Contact]] = [String: [Contact]]()
        
        // query favorite and not favorite contacts from realm
        var favoriteContacts    = self.contacts(isFavorite: true)
        var notFavoriteContacts = self.contacts(isFavorite: false)
        
        // sort contacts by first name alphabetically
        favoriteContacts    = self.sortContactsArr(contacts: favoriteContacts)
        notFavoriteContacts = self.sortContactsArr(contacts: notFavoriteContacts)
        
        for key in ContactManager.alphabet {
            
            // filter contacts
            var filteredContacts: [Contact] = self.filterContactsArrByAlphabet(contacts: favoriteContacts, alphabet: key)
            
            // now append filtered nonFavorite contacts
            filteredContacts += self.filterContactsArrByAlphabet(contacts: notFavoriteContacts, alphabet: key)
            
            contactsDict[key] = filteredContacts
        }
        
        return contactsDict
    }
    
    // saves a new contact into realm, returns true if successful
    public func saveNewContact(contact: Contact) -> Bool {
        var isSuccess: Bool = false
        let realm: Realm = try! Realm()
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
    
    public func didDownloadGojekContacts() -> Bool {
        return UserDefaults.standard.bool(forKey: ContactManager.didDownloadKey)
    }
}

