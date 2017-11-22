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
    
    // contacts data
    private(set) var contactsDict     : [String: [Contact]]  = [String: [Contact]]()
    private(set) var contactsSections : [String] = [String]()
    
    // table view
    private let tableView : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup contacts data
        self.contactsDict     = ContactManager.shared.contactsSorted()
        self.contactsSections = ContactManager.alphabet
        
        // set initialized params
        self.title = self.navBarTitle
        self.view.backgroundColor = self.backgroundColor
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.backgroundColor
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
}

// MARK: Table View Extension
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let alphabet = self.contactsSections[indexPath.section]
        

        if let contacts = self.contactsDict[alphabet], let contact = contacts[indexPath.row] as? Contact {
            cell.textLabel?.text = contact.firstName
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

