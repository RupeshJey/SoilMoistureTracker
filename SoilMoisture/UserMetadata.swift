//
//  UserMetadata.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class UserMetadata: NSObject {
    
    // UserMetadata Class Variables
    
    var userID = ""
    var OS = ""
    
    // Storyboard Objects
    
    
    
    override init() {
        // perform some default initialization here
        
    }
    
    init(UID: String, deviceOS: String) {
        // initialize with given parameters
        userID = UID
        OS = deviceOS
    }
    
}
