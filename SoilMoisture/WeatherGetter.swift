//
//  WeatherGetter.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 4/11/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherGetter {
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "98dac3eea27f038e4cb0490a770f7ce4"
    
    private var delegate: WeatherGetterDelegate
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeather(city: String) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL.init(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                print("Data:\n\(data!)")
                let dataString = String(data: data!, encoding:.utf8)
                //print(dataString)
                
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    //let weather = Weather(weatherData: weatherData)
                    
                    let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
                    let mainDict = weatherData["main"] as! [String: AnyObject]
                    var temp = mainDict["temp"] as! Double
                    temp = (temp - 273.15) * 1.8 + 32
                    //print("Weather: \(temp)")
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    //self.delegate.didGetWeather(weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    //self.delegate.didNotGetWeather(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
    func getWeather(latitude:String, longitude:String) {
        
        var temp:Double = 0
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL.init(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")
        
        
        
        let dataTask = session.dataTask(with: weatherRequestURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                //print("Data:\n\(data!)")
                let dataString = String(data: data!, encoding:.utf8)
                print(dataString)
                
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    // let weather = Weather(weatherData: weatherData)
                    
                    let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
                    let mainDict = weatherData["main"] as! [String: AnyObject]
                    temp = mainDict["temp"] as! Double
                    temp = (temp - 273.15) * 1.8 + 32
                    print("Weather: \(temp)")
                    
                    let weather = Weather(weatherData: weatherData)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather: weather)
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    //self.delegate.didGetWeather(weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    //self.delegate.didNotGetWeather(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
}
