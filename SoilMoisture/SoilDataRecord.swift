//
//  SoilDataRecord.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class SoilDataRecord: NSObject, NSCoding {
    
    // SoilDataRecord Class Variables
    var userID = "",
        OS = "",
        siteName = "",
        date:Date,
        moisture = ""
    
    // Blank initialization
    override init() {
        self.date = Date.init()
    }
    
    // Initialization with parameter
    init(recordSiteName: String, recordDate: Date, recordMoisture: String) {
        self.siteName = recordSiteName
        self.date = recordDate
        self.moisture = recordMoisture
    }
    
    // Decode everything
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.siteName = decoder.decodeObject(forKey: "name") as! String
        self.date = decoder.decodeObject(forKey: "date") as! Date
        self.moisture = decoder.decodeObject(forKey: "moisture") as! String
    }
    
    // Encode everything
    func encode(with coder: NSCoder) {
        coder.encode(self.siteName, forKey: "name")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.moisture, forKey: "moisture")
    }
    
}
