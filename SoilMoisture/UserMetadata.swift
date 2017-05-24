//
//  UserMetadata.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class UserMetadata: NSObject, NSCoding {
    
    // UserMetadata Class Variables
    
    var userID = ""
    var OS = ""
    
    
    override init() {
        // perform some default initialization here
        
    }
    
    init(UID: String, deviceOS: String) {
        // initialize with given parameters
        userID = UID
        OS = deviceOS
    }
    
    required convenience init(coder decoder: NSCoder) {
        // Decode everything
        self.init()
        self.userID = decoder.decodeObject(forKey: "userID") as! String
        self.OS = decoder.decodeObject(forKey: "OS") as! String
    }
    
    func encode(with coder: NSCoder) {
        // Encode everything
        coder.encode(self.userID, forKey: "userID")
        coder.encode(self.OS, forKey: "OS")
    }
}
