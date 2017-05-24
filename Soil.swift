//
//  SoilType.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 4/25/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class Soil:NSObject, NSCoding {
    
    enum type {
        case heavyClay
        case siltyClay
        case clay
        case siltyClayLoam
        case clayLoam
        case silt
        case siltLoam
        case sandyClay
        case loam
        case sandyClayLoam
        case sandyLoam
        case loamySand
        case sand
        case none
        //static var count: Int { return Test.FOUR.hashValue + 1}
    }
    
    var soilType = type.none
    
    override init() {
        
        
    }
    
    init(withType:type) {
        soilType = withType
    }
    
    required convenience init(coder decoder: NSCoder) {
        // Decode everything
        self.init()
        self.soilType = decoder.decodeObject(forKey: "type") as! type
    }
    
    func encode(with coder: NSCoder) {
        // Encode everything
        coder.encode(self.soilType, forKey: "type")
    }
}
