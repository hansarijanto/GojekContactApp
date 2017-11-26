//
//  ContactDetailTest.swift
//  GojekContactsAppTests
//
//  Created by Hans Arijanto on 11/26/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import XCTest
@testable import GojekContactsApp

// testing functionality of contacts detail vc
class ContactDetailVCTest: XCTestCase {
    
    var contactDetailVC: ContactDetailViewController!
    
    override func setUp() {
        super.setUp()
        self.contactDetailVC = ContactDetailViewController(contact: self.dummyContact())
        let _ = contactDetailVC.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func dummyContact() -> Contact {
        let contact = Contact()
        contact.firstName  = "firstName"
        contact.lastName   = "lastName"
        contact.email      = "email"
        contact.mobile     = "+627383330003"
        contact.isFavorite = true
        
        return contact
    }
    
    func testFirstName() {
        let cell = self.contactDetailVC.tableView(self.contactDetailVC.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ContactDetailTableCellView
        let firstName = cell.contentField.text
        XCTAssert(self.contactDetailVC.contact.firstName == firstName)
    }
    
    func testLastName() {
        let cell = self.contactDetailVC.tableView(self.contactDetailVC.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as! ContactDetailTableCellView
        let lastName = cell.contentField.text
        XCTAssert(self.contactDetailVC.contact.lastName == lastName)
    }
    
    func testMobile() {
        let cell = self.contactDetailVC.tableView(self.contactDetailVC.tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as! ContactDetailTableCellView
        let mobile = cell.contentField.text
        XCTAssert(self.contactDetailVC.contact.mobile == mobile)
        XCTAssert(self.contactDetailVC.messageButton.isUserInteractionEnabled && !self.contactDetailVC.messageButton.isHidden)
        XCTAssert(self.contactDetailVC.callButton.isUserInteractionEnabled && !self.contactDetailVC.callButton.isHidden)
        
        self.contactDetailVC.contact.mobile = nil
        self.contactDetailVC.updateUIForMode()
        
        // TODO: better way to put in wait
        UIView.animate(withDuration: 3.0, animations: {
        }, completion: {(finished) in
            XCTAssert(!self.contactDetailVC.messageButton.isUserInteractionEnabled)
            XCTAssert(!self.contactDetailVC.callButton.isUserInteractionEnabled)
        })
    }
    
    func testEmail() {
        let cell = self.contactDetailVC.tableView(self.contactDetailVC.tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as! ContactDetailTableCellView
        let email = cell.contentField.text
        XCTAssert(self.contactDetailVC.contact.email == email)
        XCTAssert(self.contactDetailVC.emailButton.isUserInteractionEnabled && !self.contactDetailVC.emailButton.isHidden)
        
        self.contactDetailVC.contact.email = nil
        self.contactDetailVC.updateUIForMode()
        
        // TODO: better way to put in wait
        UIView.animate(withDuration: 3.0, animations: {
        }, completion: {(finished) in
            XCTAssert(!self.contactDetailVC.emailButton.isUserInteractionEnabled)
        })
    }
}

