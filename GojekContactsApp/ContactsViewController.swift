//
//  ContactsViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/22/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    private let navBarTitle       : String = "Contacts"     // bar title (Contacts)
    private let backgroundColor   : UIColor = UIColor.white // background color (white)
    
    // contacts/table data
    // the table view data assumes the following, contactsDict is pre sorted
    // contact section represent the title of the tbale sections
    // the contactsDict are keyed by it's prespective elements of contactsSection (alphabets in this instance)
    private(set) var contactsDict     : [String: [Contact]]  = [String: [Contact]]() // key is alphabet, value are contacts associated to tht alphabet
    private(set) var contactsSections : [String] = [String]()
    
    // table view
    private let tableView : UITableView = UITableView()
    
    // sizes
    public let rowHeight : CGFloat = 64.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup contacts data
        self.contactsDict     = ContactManager.shared.contactsSorted()
        self.contactsSections = ContactManager.alphabet
        
        // set initialized params
        self.title = self.navBarTitle
        self.view.backgroundColor = self.backgroundColor
        
        self.tableView.register(ContactTableCellView.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.backgroundColor
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
}

// MARK: Table View Extension
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableCellView
        let alphabet = self.contactsSections[indexPath.section]
        

        if let contacts = self.contactsDict[alphabet] {
            let contact = contacts[indexPath.row]
            
            // load product image
            if let contactImage = ContactManager.shared.loadContactImage(contact: contact) {
                cell.contactImageView.image     = contactImage
            }
            
            cell.favoriteImageView.isHidden = !contact.isFavorite
            cell.nameTitleLabel.text = "\(contact.firstName!) \(contact.lastName!)"
        }
        
        return cell
    }
    
    // MARK: Table View Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let alphabet = self.contactsSections[section]
        if let contacts = self.contactsDict[alphabet] {
            return contacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactsSections[section]
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

