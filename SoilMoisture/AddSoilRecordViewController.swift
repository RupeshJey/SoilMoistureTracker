//
//  AddSoilRecordViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddSoilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, WeatherGetterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NoteRecordTableViewCellDelegate {
    
    // DECLARE VARIABLES
    
    let openedKeyID = "openedBefore",       // Constant
        userMetadataID = "userMetadata",    // Constant
        recordsID = "recordsID"             // Constant
    
    
    var invalid:String = "-------",         // Default invalid value for all strings
        date:String = "",                   // Date
        resistance:String = "",             // Sensor-measured resistance
        temperature:String = "",            // Sensor-measured temperature
        moisture:String = "",               // Sensor-measured moisture
        siteString = "",                    // Selected site string
        locManager = CLLocationManager(),   // Location Manager to get coordinates
        temp:Double = 0.0,                  // Numerical temperature
        image:UIImage?,                     // Image
        imageBool:Bool = false,             // Boolean for image
        shouldRefreshSensor:Bool = true,    // Boolean whether to refresh sensor
        newPin = MKPointAnnotation(),       // Point for MapKit
        soilRecord:SoilDataRecord?,         // Individual Soil Record
        nrfManagerInstance:NRFManager!,     // Connector to Arduino
        recordsArray:[Any]?                 // Array of records
    
    //@IBOutlet weak var Save: UIButton!          // Save Button
    @IBOutlet weak var DataTable: UITableView!  // Data Table
    @IBOutlet weak var template: UIImageView!
    
    // END VARIABLES
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default labels
        setupInvalids()
        
        // Set up the location manager
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startMonitoringSignificantLocationChanges()
        
        // Temporarily set temporary site string
        UserDefaults.standard.set(siteString, forKey: "tempSiteName")
        
        template.alpha = 0.15
        
    }

    // View did appear
    override func viewDidAppear(_ animated: Bool) {
        
        // Collect metadata if first load
        if !self.hasOpenedBefore() {self.getMetadata()}
        
        // Collect sensor data
        measure()
        
        // Get weather by passing coordinates
        let weather = WeatherGetter.init(delegate: self)
        weather.getWeather(latitude: String(locManager.location!.coordinate.latitude), longitude: String(locManager.location!.coordinate.longitude))
        
        // Update the temporary site string
        siteString = UserDefaults.standard.string(forKey: "tempSiteName")!
    }
    
    
    // Mark the main data fields as invalid (sensor hasn't collected yet)
    func setupInvalids() {
        date = invalid
        resistance = invalid
        temperature = invalid
        moisture = invalid
    }
    
    // Get metadata if necessary
    func getMetadata() {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialMetadaViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // Helper function to tell whether app has been opened before
    func hasOpenedBefore() -> Bool {
        return true//UserDefaults.standard.bool(forKey: openedKeyID)
    }
    
    // This function handles data collection from the sensor and error handling
    func measure() {
        
        if(!getArduinoData()) {
            let alert = UIAlertController(title: "Error", message: "Could not connect to Arduino. Please check the connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // This function gets valid sensor data
    func getArduinoData() -> Bool {
        
        nrfManagerInstance = NRFManager(
            onConnect: {
                print("Connected")
        },
            onDisconnect: {
                print("Disconnected")
        },
            onData: {
                (data:Data?, string:String?)->() in
                
                // Set date string
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
                self.date = formatter.string(from: Date())
                
                // Pick out the resistance and evaluate moisture
                let indexStartOfText = string!.index(string!.startIndex, offsetBy: 3)
                
                if string!.contains("R: ") {
                    self.resistance = string!.substring(from: indexStartOfText)
                    
                    if (Double(self.resistance) != nil) {
                        var moistureValue = 80*2374.3 * pow(Double(self.resistance)! , -0.598)
                        
                        moistureValue = Double(round(1000*moistureValue)/1000)
                        
                        self.moisture = String(format: "%0.1f",moistureValue)
                        self.moisture.append("%")
                    }
                }
                
                else if string!.contains("T: ") {
                    let shortenedDouble = string!.substring(from: indexStartOfText)
                    self.temperature =  String(format: "%0.1f",shortenedDouble)
                    //print(self.temperature)
                    /*if (Double(self.temperature) != nil) {
                        var moistureValue = 2374.3 * pow(Double(self.resistance)! , -0.598)
                        
                        moistureValue = Double(round(1000*moistureValue)/1000)
                        
                        self.moisture = String(moistureValue)
                        self.moisture.append(" %")
                    }*/
                    
                    /*self.resistance = string!.substring(from: indexStartOfText)
                    self.temperature = "20℃"
                    
                    if (Double(self.resistance) != nil) {
                        var moistureValue = 80*2374.3 * pow(Double(self.resistance)! , -0.598)
                        
                        moistureValue = Double(round(1000*moistureValue)/1000)
                        
                        self.moisture = String(moistureValue)
                        self.moisture.append(" %")
                    }*/
                }
                
                if (self.shouldRefreshSensor) {
                    self.DataTable.reloadData()
                }
        }
        )
        
        nrfManagerInstance.autoConnect = false
        nrfManagerInstance.connect("JPLSoil")
        
        return true
    }
    
    // Save record into user defaults
    @IBAction func save(_ sender: Any) {
        print("Saving!")
        
        // Save blank array if defaults is empty
        if (UserDefaults.standard.array(forKey: recordsID) == nil) {
            UserDefaults.standard.set([], forKey: recordsID)
        }
        
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
        soilRecord = SoilDataRecord.init(recordSiteName: self.siteString, recordDate:  Date.init(), recordMoisture: moisture)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.soilRecord!)
        recordsArray?.append(data)
        UserDefaults.standard.set(recordsArray, forKey: recordsID)
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    // Set the number of sections in the table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        /*tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 3 if the table is to be loaded with sensor data
        if (hasOpenedBefore()) {
            return 3
        }*/
        
        // 0 if metadata is to be collected first
        return 1
    }
    
    // Set the number of rows in each section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
        /*switch section {
        case 0:
            return 4
        case 1:
            return 3
        case 2:
            return 4
        default:
            return 0
        }*/
    }
    
    // Set the cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Switch depending on row
        
        /*switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addRecordCell", for: indexPath) as! AddRecordTableViewCell
            cell.selectionStyle = .none
            cell.detailTextLabel?.textColor = .black
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = date
                if date == invalid {cell.detailTextLabel?.textColor = .red}
            case 1:
                cell.textLabel?.text = "Resistance"
                cell.detailTextLabel?.text = resistance
                if resistance == invalid {cell.detailTextLabel?.textColor = .red}
            case 2:
                cell.textLabel?.text = "Temperature"
                cell.detailTextLabel?.text = temperature
                if temperature == invalid {cell.detailTextLabel?.textColor = .red}
            case 3:
                cell.textLabel?.text = "Moisture"
                cell.detailTextLabel?.text = moisture
                if moisture == invalid {cell.detailTextLabel?.textColor = .red}
            default:
                cell.textLabel?.text = "Date"
            }
            
            return cell
            
        case 1:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                cell.selectionStyle = .none
                cell.title.text = "Weather"
                cell.detail?.text = String("\(round(100*temp)/100) ℉")
                cell.detail?.text = String("\(round(100*self.temp)/100) ℉")
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "coordinateCell", for: indexPath) as! CoordinateTableViewCell
                cell.CoordinatesLabel.text = "(\(round(1000*locManager.location!.coordinate.latitude)/1000), \(round(1000*locManager.location!.coordinate.longitude)/1000))"
                cell.selectionStyle = .none
                let coordinateRegion = MKCoordinateRegionMakeWithDistance((locManager.location?.coordinate)!,
                                                                          1000 * 2.0, 1000 * 2.0)
                cell.mapView.setRegion(coordinateRegion, animated: true)
                newPin.coordinate = locManager.location!.coordinate
                cell.mapView.addAnnotation(newPin)
                cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 216)
                cell.mapView.layer.cornerRadius = 20.0
                
                return cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                
                cell.selectionStyle = .none
                cell.title.text = "OS"
                cell.detail?.text = "iOS \(UIDevice.current.systemVersion)"
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                
                cell.selectionStyle = .none
                cell.title.text = ""
                return cell
            }
            
        case 2:
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                cell.selectionStyle = .none
                cell.title.text = "User ID"
                let data = UserDefaults.standard.object(forKey: userMetadataID) as? NSData
                let metadata = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as! UserMetadata
                
                cell.detail.text = metadata.userID
                
                if (cell.detail.text == "") {
                    cell.detail.text = "----"
                    cell.detail.textColor = .red
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                cell.title.text = "Site"
                if siteString == "" {
                    cell.accessoryType = .disclosureIndicator
                }
                else {
                    cell.accessoryType = .none
                }
                cell.detail.text = siteString
                cell.isUserInteractionEnabled = true
                
                return cell
            case 2:
                
                if (image == nil) {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                    cell.title.text = "Image"
                    cell.isUserInteractionEnabled = true
                    
                    let imageView:UIImageView
                    imageView = UIImageView(image: #imageLiteral(resourceName: "Screenshot-50"))
                    
                    imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                    cell.accessoryView = imageView
                    
                    return cell
                }
                
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "imageRecordCell", for: indexPath) as! ImageRecordTableViewCell
                    print("Returning here")
                    cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 128)
                    cell.ImageView.image = self.image
                    
                    return cell
                }
                
            case 3:
                
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "noteRecordCell", for: indexPath) as! NoteRecordTableViewCell
                cell2.setup(delegate: self)
                return cell2
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
                cell.title.text = ""
                return cell
            }
            
        default:
            print("")
        }*/
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewHeader", for: indexPath)
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 44)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SensorReadingCell", for: indexPath) as! SensorReadingsCell
            
            // Soil Moisture
            
            cell.moistureLabel.text = moisture
            
            // Resistance
            
            if (resistance != invalid && resistance != " INF" && resistance != "") {
                let shortenedDouble = Double(resistance)!/1000
                cell.resistanceLabel.text = "\(String(format: "%0.1f",shortenedDouble)) kΩ"
                
            }
            else if resistance == " INF" {
                cell.resistanceLabel.text = "INF kΩ"
            }
            
            else {
                cell.resistanceLabel.text = invalid
            }
            
            // Temperature
            
            NSLog(temperature)
            cell.temperatureLabel.text = temperature //"\(String(format: "%0.1f", temperature))°"
            
            // Date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMMM d"
            cell.dateLabel.text = formatter.string(from: Date())
            formatter.dateFormat = "h:mm a"
            cell.timeLabel.text = formatter.string(from: Date())
            
            
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 355)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "observationsHeader", for: indexPath)
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 44)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SensorReadingCell", for: indexPath)
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 355)
            return cell
        }
    }
    
    // Handle tableview selections
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Switch depending on row
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 1:
                
                // Handle the site selection
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SiteSelectTableViewController")
                self.present(vc, animated: true, completion: nil)
            case 2:
                
                // Handle photo selection
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            
            default:
                print("")
            }
        default:
            print("")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }*/
    
    // Edit the name of the title in each section
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Sensor Readings: "
        case 1:
            return "App Collected Data"
        case 2:
            return "User Input"
        default:
            return ""
        }
    }*/
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return tableView.dequeueReusableCell(withIdentifier: "tableViewHeader")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    */
    
    // Set height for each row
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 44
        case 1:
            return 355
        default:
            return 44
        }
    }
    
    // Store the image from the image picker as the current image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            imageBool = true
            dismiss(animated: true, completion: nil)
            
            DataTable.reloadData()
        }
    }
    
    // If the weather getter comes back with data, set the temperature
    
    func didGetWeather(weather: Weather) {
        DispatchQueue.main.async() {
            self.temp = weather.tempFahrenheit
            self.DataTable.reloadData()
        }
    }
    
    // Print if there is an error with the weather getter
    
    func didNotGetWeather(error: NSError) {
        print("didNotGetWeather error: \(error)")
    }
    
    // Offset upon begin editing
    func didBeginEditing() {
        
        // Stop refreshing the sensor
        shouldRefreshSensor = false
        
        if (imageBool) {
            DataTable.setContentOffset(CGPoint.init(x: 0, y: 334), animated: true)
        }
        
        else {
            DataTable.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
        
        DataTable.allowsSelection = false
    }
    
    // Offset upon end editing and refresh
    func didEndEditing() {
        shouldRefreshSensor = true
        if (imageBool) {
            DataTable.setContentOffset(CGPoint(x: 0, y: 199), animated: true)
        }
        else {
            DataTable.setContentOffset(CGPoint(x: 0, y: 115), animated: true)
        }
        DataTable.allowsSelection = true
        measure()
    }
    
    // ---------------------------
    
    // MARK: Bluetooth Methods
    
    // ---------------------------
    
    // Can delete eventually if not sending any data to arduino
    
    func sendData()
    {
        // Example of sending data from phone to arduino
        let result = self.nrfManagerInstance.writeString("Hello, world!")
        print("result: %@", result)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
