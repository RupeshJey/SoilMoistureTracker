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

import CoreBluetooth

class AddSoilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, WeatherGetterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NoteRecordTableViewCellDelegate, UIGestureRecognizerDelegate {
    
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
        recordsArray:[Any]?,                // Array of records
        coordinateRegion:MKCoordinateRegion?// Coordinates
    
    var pageOpened = false
    
    //@IBOutlet weak var Save: UIButton!          // Save Button
    @IBOutlet weak var DataTable: UITableView!  // Data Table
    @IBOutlet weak var BlurView: UIVisualEffectView!
    @IBOutlet weak var BluetoothView: UIView!
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNoteTap), name: Notification.Name("shiftTable"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //self.BlurView.isHidden = true
        self.BlurView.effect = UIBlurEffect(style: .regular)
        self.BluetoothView.alpha = 0.0
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
        
        // Bluetooth
        checkBluetooth()
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
    @IBAction func blur(_ sender: Any) {
        UIApplication.shared.open(URL(string:"App-Prefs:root=Bluetooth")!, options: [:], completionHandler: nil)
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    // Set the number of sections in the table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the number of rows
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    // Set the cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Switch depending on row
        
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
                cell.resistanceLabel.text = "\(String(format: "%0.1f",shortenedDouble)) kΩ"
                
            }
            else if resistance == " INF" {
                cell.resistanceLabel.text = "INF kΩ"
            }
            
            else {
                cell.resistanceLabel.text = invalid
            }
            
            // Temperature
            
            cell.temperatureLabel.text = temperature
            
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
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "observationsCell", for: indexPath) as! ObservationsTableViewCell
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            cell.PhotoView.addGestureRecognizer(gestureRecognizer)
            
            if image != nil {
                cell.photo.image = image
                cell.photo.layer.cornerRadius = 10.0
            }
            cell.NotesField.text = ""
            cell.placeholderLabel.isHidden = false
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 230)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapHeader", for: indexPath)
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 44)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 221)
            
            // Map setup
            coordinateRegion = MKCoordinateRegionMakeWithDistance((locManager.location?.coordinate)!,
                                                                      1000 * 2.0, 1000 * 2.0)
            cell.mapView.setRegion(coordinateRegion!, animated: false)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SensorReadingCell", for: indexPath)
            cell.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: 355)
            return cell
        }
    }
    
    // Present image selector to user
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Scroll notes to correct page
    func handleNoteTap() {
        DataTable.scrollToRow(at: IndexPath(row: 2, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
    
    // Set height for each row
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 44
        case 1:
            return 355
        case 2:
            return 44
        case 3:
            return 230
        case 4:
            return 44
        case 5:
            return 221
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
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // ---------------------------
    
    // MARK: Bluetooth Methods
    
    // ---------------------------
    
    // Check Bluetooth Connection
    
    func checkBluetooth() {
        
        //let btConnection = CBPer.init()
        print("Bluetooth:")
        print(nrfManagerInstance.connectionStatus)
        
        if nrfManagerInstance.connectionStatus != .connected {
            
            BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: 1000)
            
            UIView.animate(withDuration: 1.0, animations: {
                self.view.bringSubview(toFront: self.BlurView)
                self.view.bringSubview(toFront: self.BluetoothView)
            })
            
            if (!pageOpened) {
                UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations:
                    {
                        self.BluetoothView.alpha = 1.0
                        self.BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: 10 + self.view.frame.height/2)
                        
                }, completion:nil)
                pageOpened = true
            }
            
            else {
                self.BluetoothView.alpha = 1.0
                self.BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: 10 + self.view.frame.height/2)
            }
            
            //self.BluetoothView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
            
            BluetoothView.layer.cornerRadius = 15
            //BluetoothView.layer.borderWidth = 1.0
            //BluetoothView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
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

