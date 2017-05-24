//
//  Site.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/2/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation
import UIKit

class Site: NSObject, NSCoding {
    
    var siteName = ""
    var siteDescription = ""
    var siteImage:UIImage?
    var soilType:Soil?
    
    var soilTypeString:String?
    
    override init() {
        
    }
    
    init(name: String, description: String, image: UIImage, type: String) {
        siteName = name
        siteDescription = description
        siteImage = image
        soilTypeString = type
    }
    
    required convenience init(coder decoder: NSCoder) {
        // Decode everything
        self.init()
        self.siteName = decoder.decodeObject(forKey: "name") as! String
        self.siteDescription = decoder.decodeObject(forKey: "description") as! String
        self.siteImage = decoder.decodeObject(forKey: "image") as? UIImage
        self.soilType = decoder.decodeObject(forKey: "type") as? Soil
        self.soilTypeString = decoder.decodeObject(forKey: "typeString") as? String
    }
    
    func encode(with coder: NSCoder) {
        // Encode everything
        coder.encode(self.siteName, forKey: "name")
        coder.encode(self.siteDescription, forKey: "description")
        coder.encode(self.siteImage, forKey: "image")
        coder.encode(self.soilType, forKey: "type")
        coder.encode(self.soilTypeString, forKey: "typeString")
    }
    
}
