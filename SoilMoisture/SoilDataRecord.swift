//
//  SoilDataRecord.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class SoilDataRecord: NSObject, NSCoding {
    
    // UserMetadata Class Variables
    
    var userID = ""
    var OS = ""
    
    var siteName = ""
    var date:Date
    var moisture = ""
    
    override init() {
        
        self.date = Date.init()
    }
    
    init(recordSiteName: String, recordDate: Date, recordMoisture: String) {
        self.siteName = recordSiteName
        self.date = recordDate
        self.moisture = recordMoisture
    }
    
    required convenience init(coder decoder: NSCoder) {
        // Decode everything
        
        self.init()
        
        self.siteName = decoder.decodeObject(forKey: "name") as! String
        self.date = decoder.decodeObject(forKey: "date") as! Date
        self.moisture = decoder.decodeObject(forKey: "moisture") as! String
    }
    
    func encode(with coder: NSCoder) {
        // Encode everything
        coder.encode(self.siteName, forKey: "name")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.moisture, forKey: "moisture")
    }
    
}
