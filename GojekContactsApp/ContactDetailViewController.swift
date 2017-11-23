//
//  ContactDetailViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/23/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

enum ContactDetailViewControllerMode {
    case view
    case edit
}

class ContactDetailViewController: UIViewController {
    private(set) var mode: ContactDetailViewControllerMode = .view
    private(set) var contact: Contact
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
