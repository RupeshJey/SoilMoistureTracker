//
//  SensorGetter.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 4/18/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

class SensorGetter {
    
    let sparkfunURL:String = "http://192.168.4.1/read"
    
    var adc = ""
    var resistance = ""
    var voltage = ""
    var temperature = ""
    
    func refresh() {
        
        parseData()
        
    }
    
    func parseData(){
        
        //TODO: implement a check to see if we are connected to sensor
        
        let url = URL(string: sparkfunURL) //url instantiation
        let data = try? Data(contentsOf: url!) //data instantiation
        var jsonResult: [String:AnyObject] = [:] //declare json variable
        
        do {
            
            print("Data: ", String(describing: data))
            
            if(data != nil) {
                
                //parse json data
                jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                
                
                //if values are not nil, set respective values
                if let adcValue = jsonResult["adcValue"] {
                    print(adcValue.stringValue)
                    adc = adcValue.stringValue
                }
                
                if let resistanceValue = jsonResult["resistance"] {
                    print(resistanceValue.stringValue)
                    resistance = resistanceValue.stringValue
                }
                if let voltageValue = jsonResult["voltage"] {
                    print(voltageValue.stringValue)
                    voltage = voltageValue.stringValue
                }
                
                if let temperatureValue = jsonResult["temperature"] {
                    print(temperatureValue.stringValue)
                    temperature = temperatureValue.stringValue
                }
                
                
            }else{
                print("No Data Recieved")
            }
            
        }catch let error as NSError {
            print(error)
        }
        
    }
    
}
