//
//  ViewController.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {
    
    private let contactsVC: ContactsViewController = ContactsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactManager.shared.fetchContacts() // TODO: Move to contactsVC, and implement load view
        
        // set nav bar to be solid
        self.navigationBar.isTranslucent = false
        
        // set initial root vc
        self.pushViewController(self.contactsVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

