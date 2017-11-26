//
//  DownloadContactsTest.swift
//  GojekContactsAppTests
//
//  Created by Hans Arijanto on 11/26/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import XCTest
@testable import GojekContactsApp

class ContactDownloadDelegate: ContactManagerDelegate {
    
    var asyncResult: Bool? = .none
    
    // Async test code needs to fulfill the XCTestExpecation used for the test
    // when all the async operations have been completed. For this reason we need
    // to store a reference to the expectation
    var asyncExpectation: XCTestExpectation?
    
    func didDownloadContacts() {
        guard let expectation = asyncExpectation else {
            XCTFail("contacts delegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        self.asyncResult = ContactManager.shared.contacts().count > 0
        expectation.fulfill()
    }
}


// This test requires an active internet connection
class ContactsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // test if http manager get func is working
    func testGetRequestAndInternet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        HTTPManager.shared.get(urlString: "http://www.google.com", completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    // test if gojek api available
    func testGojekAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        HTTPManager.shared.get(urlString: ContactManager.gojekUrl() , completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    // TODO: Currently passes when run alone, but fails when run as a whole.. (but chcked and results are still correct)
    // test api, realm persistence, and sorting contacts
    func testDownloadContacts() {
        
        // delete all contacts data in realm
        ContactManager.shared.deleteAllContacts()
        if ContactManager.shared.contacts().count > 0 {
            XCTFail("contacts not deleted for download test")
        }
        
        let delegate = ContactDownloadDelegate()
        ContactManager.shared.delegate = delegate
        
        let downloadExpectation = expectation(description: "contacts delegate calls the delegate as the result of an async method completion")
        delegate.asyncExpectation = downloadExpectation
        
        ContactManager.shared.fetchContacts()
        
        wait(for: [downloadExpectation], timeout: 60.0)
        waitForExpectations(timeout: 60.0, handler: { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let result = delegate.asyncResult else {
                XCTFail("Expected delegate to be called")
                return
            }
            
            XCTAssertTrue(result)
        })
    }
    
    // MARK: Functional test
    func testSortingContacts() {
        // test sorting contacts
        if ContactManager.shared.contacts().count <= 0 {
            XCTFail("0 contacts available for sorting test")
        }
        
        let contactsDict = ContactManager.shared.contactsSorted()
        
        for (alphabet, contacts) in contactsDict {
            if alphabet == "#" || contacts.count <= 0 {
                continue
            }
            
            for i in 0..<contacts.count - 1 {
                let j = i + 1
                let firstContact  = contacts[i]
                let secondContact = contacts[j]
                if firstContact.isFavorite == secondContact.isFavorite {
                    XCTAssertTrue(firstContact.firstName! <= secondContact.firstName!)
                }
            }
        }
    }
}


