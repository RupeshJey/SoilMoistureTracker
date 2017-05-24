//
//  NewRecordViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 4/4/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
import CoreLocation

class NewRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, WeatherGetterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var locManager = CLLocationManager()
    
    @IBOutlet weak var addTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var invalid:String = "-------"
    
    let userMetadataID = "userMetadata"
    var metadata:UserMetadata = UserMetadata()
    
    var date:String = ""
    var resistance:String = ""
    var soilTemperature:String = ""
    var moisture:String = ""
    
    var temp:Double = 0.0
    
    var imagePicker: UIImagePickerController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Core Location Manager asks for GPS location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startMonitoringSignificantLocationChanges()
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
        {
            print(locManager.location!)
            
        } else {
            //labelLatitude.text = "Location not authorized"
            //labelLongitude.text = "Location not authorized"
        }
        
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*let url = URL(string: "https://nytimes.com")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print(data)
        }
        
        task.resume()*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        
        // Save record in SoilDataRecord type
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func didGetWeather(weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async() {
            
            print("Actually GOT: \(weather.tempFahrenheit)")
            self.temp = weather.tempFahrenheit
            self.addTable.reloadData()
            //self.cityLabel.text = weather.city
            //self.weatherLabel.text = weather.weatherDescription
            //self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            //self.cloudCoverLabel.text = "\(weather.cloudCover)%"
            //self.windLabel.text = "\(weather.windSpeed) m/s"
            
            /*if let rain = weather.rainfallInLast3Hours {
                self.rainLabel.text = "\(rain) mm"
            }
            else {
                self.rainLabel.text = "None"
            }
            
            self.humidityLabel.text = "j\(weather.humidity)%"*/
        }
    }
    
    func didNotGetWeather(error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async() {
            //self.showSimpleAlert(title: "Can't get the weather",
                                 //message: "The weather service isn't responding.")
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
    // -----------------------
    
    // Mark: - Table View 
    
    // -----------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //NSLog("ADD ONE!")
        
        
        //let cell = UITableViewCell(style: UITableViewCellStyle., reuseIdentifier: "Cell")
        
        // Core Location Manager asks for GPS location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startMonitoringSignificantLocationChanges()
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
        {
            print(locManager.location!)
            
        } else {
            //labelLatitude.text = "Location not authorized"
            //labelLongitude.text = "Location not authorized"
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
        
        cell.isUserInteractionEnabled = false
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.title.text = "Date/Time"
                cell.detail?.text = date
            case 1:
                cell.title.text = "Reisistance"
                cell.detail?.text = resistance
            case 2:
                cell.title.text = "Temperature"
                cell.detail?.text = soilTemperature
            case 3:
                cell.title.text = "Moisture"
                cell.detail?.text = moisture
            default:
                cell.title.text = ""
            }
        case 1:
            switch indexPath.row {
            case 0:
                
                if (cell.detail?.text == "Detail" || cell.detail.text == "0.0 ℉")  {
                    cell.title.text = "Weather"
                    
                    let weather = WeatherGetter.init(delegate: self)
                    weather.getWeather(latitude: String(locManager.location!.coordinate.latitude), longitude: String(locManager.location!.coordinate.longitude))
                    cell.detail?.text = String("\(round(100*temp)/100) ℉")
                }
                
            case 1:
                cell.title.text = "Lat/Long"
                
                cell.detail?.text = "(\(round(1000*locManager.location!.coordinate.latitude)/1000), \(round(1000*locManager.location!.coordinate.longitude)/1000))"
                
                print("Latitude: ", locManager.location?.coordinate.latitude ?? "")
                print("Longitude: ", locManager.location?.coordinate.longitude ?? "")
                
            case 2:
                cell.title.text = "OS"
                cell.detail?.text = "iOS \(UIDevice.current.systemVersion)"
            default:
                cell.title.text = ""
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.title.text = "User ID"
                let data = UserDefaults.standard.object(forKey: userMetadataID) as? NSData
                metadata = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as! UserMetadata
                
                cell.detail.text = metadata.userID
            case 1:
                cell.title.text = "Site"
                cell.detail.text = ""
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.title.text = "Image"
                cell.isUserInteractionEnabled = true
            case 3:
                cell.title.text = "Notes"
            default:
                cell.title.text = ""
            }
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 1:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "soilTypeSelect")
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                
                present(imagePicker, animated: true, completion: nil)
                
            default:
                print("s")
            }
        default:
            print("H")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Sensor Data"
        case 1:
            return "App Collected Data"
        case 2:
            return "User Input"
        default:
            return ""
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setSensorData(sensorDate: String, sensorResistance: String, sensorTemperature: String, sensorMoisture: String) {
        date = sensorDate
        resistance = sensorResistance
        soilTemperature = sensorTemperature
        moisture = sensorMoisture
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
