//
//  HTTPManager.swift
//  GojekContactsApp
//
//  Created by Hans Arijanto on 11/21/17.
//  Copyright © 2017 Hans Arijanto. All rights reserved.
//

import Foundation

// Singleton used to execute HTTP request and return it's response
// currently just support GET request and simply returns the content
// without error codes or messages, returns nil in case of error

class HTTPManager {
    
    private init() { }
    
    // MARK: Shared Instance
    static let shared: HTTPManager = HTTPManager()
    
    // get request, run synchronously for threading simplicity
    public func get(urlString: String, completionBlock: ((String) -> Void)?) {
        
        let url = URL(string: urlString)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        completionBlock?(stringData)
                    }
                }
            })
            task.resume()
        }
    }
}
