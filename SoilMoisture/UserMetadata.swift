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
    var userID = "",
        OS = ""
    
    override init() {
    }
    
    // Initialization of parameters
    init(UID: String, deviceOS: String) {
        userID = UID
        OS = deviceOS
    }
    
    // Decode everything
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.userID = decoder.decodeObject(forKey: "userID") as! String
        self.OS = decoder.decodeObject(forKey: "OS") as! String
    }
    
    // Encode everything
    func encode(with coder: NSCoder) {
        coder.encode(self.userID, forKey: "userID")
        coder.encode(self.OS, forKey: "OS")
    }
}
