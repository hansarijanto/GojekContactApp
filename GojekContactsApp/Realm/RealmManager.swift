//
//  RealmManager.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    // singleton
    static let shared: RealmManager = RealmManager()
    
    private let realm: Realm
    
    init() {
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
}
