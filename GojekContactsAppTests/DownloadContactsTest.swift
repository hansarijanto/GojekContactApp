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


class DownloadContactsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // delete all data in realm
        ContactManager.shared.deleteAllContacts()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetRequestAndInternet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        HTTPManager.shared.get(urlString: "http://www.google.com", completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    func testGojekAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        HTTPManager.shared.get(urlString: ContactManager.gojekUrl() , completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    func testDownloadContacts() {
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


