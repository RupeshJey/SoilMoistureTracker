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

class AddSoilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, WeatherGetterDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ObservationsTableViewCellDelegate {
    
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
        resist:Double = 0.0,                // Numberical resistance
        image:UIImage?,                     // Image
        imageBool:Bool = false,             // Boolean for image
        shouldRefreshSensor:Bool = true,    // Boolean whether to refresh sensor
        newPin = MKPointAnnotation(),       // Point for MapKit
        soilRecord:SoilDataRecord?,         // Individual Soil Record
        nrfManagerInstance:NRFManager!,     // Connector to Arduino
        recordsArray:[Any]?,                // Array of records
        moistureNumber:Double? = 0.0,
        timer: Timer?,                      // Timer
        map:MKMapView? = nil,
        coordinateRegion:MKCoordinateRegion?// Coordinates
    
    var pageOpened = false
    
    //@IBOutlet weak var Save: UIButton!          // Save Button
    @IBOutlet weak var DataTable: UITableView!  // Data Table
    @IBOutlet weak var BlurView: UIVisualEffectView!
    @IBOutlet weak var BluetoothView: UIView!
    @IBOutlet weak var BluetoothImage: UIImageView!
    @IBOutlet weak var BluetoothText: UILabel!
    @IBOutlet weak var SettingsButton:UIButton!
    
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
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //view.addGestureRecognizer(tapGesture)
        
        //self.BlurView.isHidden = true
        self.BlurView.effect = UIBlurEffect(style: .regular)
        self.BluetoothView.alpha = 0.0
        
        // Scheduling timer to call the bluetooth checker with the interval of 1 second
        startTimer()
        
        let image = UIImage(named: "bluetooth-symbol-silhouette_318-38721")!.withRenderingMode(.alwaysTemplate)
        
        BluetoothImage.image = image
        //self.BluetoothImage.alpha = 0.4
        self.BluetoothImage.tintColor = UIColor.init(red: 48.0/255.0, green: 132/255.0, blue: 244/255.0, alpha: 1.0)
        self.SettingsButton.isHidden = true
        
        // Map loading 
        coordinateRegion = MKCoordinateRegionMakeWithDistance((locManager.location?.coordinate)!, 1000 * 2.0, 1000 * 2.0)
        //
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
        
        // Animate the Bluetooth pulse
        animateBluetooth()
        
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
                //self.checkBluetooth()
        },
            onDisconnect: {
                print("Disconnected")
                //self.checkBluetooth()
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
                        // 611897 * resistance ^ -1.196
                        //var moistureValue = 80*2374.3 * pow(Double(self.resistance)! , -0.598)
                        
                        var moistureValue = 611897 * pow(Double(self.resistance)! , -1.196)
                        moistureValue = Double(round(1000*moistureValue)/1000)
                        
                        self.moistureNumber = moistureValue
                        
                        self.moisture = String(format: "%0.1f",moistureValue)
                        self.moisture.append("%")
                    }
                }
                
                else if string!.contains("T: ") {
                    let shortenedDouble = string!.substring(from: indexStartOfText)
                    if shortenedDouble != "-196.60" {
                        self.temp = Double(shortenedDouble)!
                        self.temperature =  String(format: "%0.1f",self.temp) + "℉"
                    }
                    else {
                        self.temperature = "Disconnected"
                    }
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
            
            // from to 22 to 157
            
            cell.moistureLabel.text = moisture
            cell.barWater.frame = CGRect.init(x: 0.5, y: 169 - (157-22) * (min(self.moistureNumber!, 100)/100), width: 154, height: 22 + (157-22) * (min(self.moistureNumber!, 100)/100))
            cell.waveWater.center = CGPoint.init(x: 90.5, y: 152.5 + (157-22) * (min(self.moistureNumber!, 100)/100))
            
            // Resistance
            
            if (resistance != invalid && resistance != " INF" && resistance != "") {
                let shortenedDouble = Double(resistance)!/1000
                self.resist = shortenedDouble
                cell.resistanceLabel.text = "\(String(format: "%0.1f",shortenedDouble)) kΩ"
                
            }
            else if resistance == " INF" {
                cell.resistanceLabel.text = "INF kΩ"
                self.resist = Double.greatestFiniteMagnitude
            }
            
            else {
                cell.resistanceLabel.text = invalid
                self.resist = 0
            }
            
            // Temperature
            
            cell.temperatureLabel.text = temperature
            cell.temperature = self.temp
            
            cell.temperatureCelsiusLabel.text = invalid
            
            if cell.temperatureLabel.text != invalid {
                cell.temperatureCelsiusLabel.text = String(format: "%0.1f" , (self.temp - 32)/1.8) + "℃"
                cell.temperatureBar.frame = CGRect.init(x: 136, y: 151 - max(0, 90 * (self.temp/100)), width: 6.5, height: max(0, 90 * (self.temp/100)))
            }
            
            else {
                cell.temperatureBar.frame = CGRect.init(x: 136, y: 151 - max(0, 90 * (self.temp/100)), width: 6.5, height: max(0, 90 * (self.temp/100)))
            }

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
            cell.setup(delegate: self)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            cell.PhotoView.addGestureRecognizer(gestureRecognizer)
            
            if image != nil {
                cell.photo.image = image
                cell.photo.layer.cornerRadius = 10.0
            }
            //cell.NotesField.text = ""
            //cell.placeholderLabel.isHidden = false
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
            //cell.mapView = map
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
        stopTimer()
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
    
    // Timer to refresh table
    func startTimer () {
        print("starting timer")
        shouldRefreshSensor = true
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AddSoilRecordViewController.checkBluetooth), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        print("stopping timer")
        shouldRefreshSensor = false
        timer?.invalidate()
        timer = nil
    }
    
    func didEndEditing() {
        startTimer()
    }
    
    // ---------------------------
    
    // MARK: Bluetooth Methods
    
    // ---------------------------
    
    // Check Bluetooth Connection
    
    func checkBluetooth() {
        
        //let btConnection = CBPer.init()
        //print("Bluetooth:")
        //print(nrfManagerInstance.connectionStatus)
        
        //let central = CBCentralManager.init()
        //central.delegate = self
        //print("state: %s", central.state.rawValue)
        
        if nrfManagerInstance.connectionStatus == .disconnected {
            
            BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: 1000)
            
            UIView.animate(withDuration: 1.0, animations: {
                //self.BlurView.alpha = 1.0
                self.view.bringSubview(toFront: self.BlurView)
                self.view.bringSubview(toFront: self.BluetoothView)
            })
            
            if (!pageOpened) {
                UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations:
                    {
                        self.BlurView.alpha = 1.0
                        self.BluetoothView.alpha = 1.0
                        self.BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2)
                        
                }, completion:nil)
                pageOpened = true
            }
            
            else {
                self.BlurView.alpha = 1.0
                self.BluetoothView.alpha = 1.0
                self.BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2)
            }
            
            BluetoothView.layer.cornerRadius = 15
            
            if nrfManagerInstance.bluetoothOn == true {
                self.BluetoothImage.tintColor = UIColor.init(red: 48.0/255.0, green: 132/255.0, blue: 244/255.0, alpha: 1.0)
                //self.BluetoothImage.alpha = 0.4
                UIView.animate(withDuration: 0.75, delay: 0.0, options:[UIViewAnimationOptions.repeat, UIViewAnimationOptions.curveEaseInOut, UIViewAnimationOptions.autoreverse], animations: {
                    
                    self.BluetoothImage.alpha = 0.4
                    
                }, completion:nil)
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options:[UIViewAnimationOptions.curveLinear], animations: {
                    
                    self.SettingsButton.isHidden = true
                    self.BluetoothText.center = CGPoint.init(x: 200, y: 95)
                    
                }, completion:nil)
                
                self.BluetoothText.text = "Scanning for Soil Moisture Sensor"
                measure()
            }
            
            else {
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options:[UIViewAnimationOptions.curveLinear], animations: {
                    
                    self.BluetoothText.center = CGPoint.init(x: 200, y: 75)
                    self.SettingsButton.isHidden = false
                    
                }, completion:nil)
                
                
                
                self.BluetoothImage.layer.removeAllAnimations()
                self.BluetoothImage.alpha = 1.0
                self.BluetoothImage.tintColor = UIColor.lightGray
                self.BluetoothText.text = "Please Turn on Bluetooth in iOS Settings"
            }
        }
        
        else if nrfManagerInstance.connectionStatus == .connected {
            
            UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations:
                {
                    self.BlurView.alpha = 0.0
                    self.BluetoothView.alpha = 0.0
                    self.BluetoothView.center = CGPoint.init(x: self.view.frame.width/2, y: 1000)
                    self.pageOpened = false
                    
            }, completion:{
                (result:Bool) in
                self.view.bringSubview(toFront: self.DataTable)
            })
        }
    }
    
    func animateBluetooth() {
        if nrfManagerInstance.connectionStatus == .disconnected && nrfManagerInstance.bluetoothOn == true {
            
            self.BluetoothImage.alpha = 1.0
            
            self.BluetoothImage.layer.removeAllAnimations()
            
            UIView.animate(withDuration: 0.75, delay: 0.0, options:[UIViewAnimationOptions.repeat, UIViewAnimationOptions.curveEaseInOut, UIViewAnimationOptions.autoreverse], animations: {
                
                self.BluetoothImage.alpha = 0.4
                
            }, completion:nil)
        }
    }
    
    @IBAction func bluetoothSettings(_ sender: Any) {
        UIApplication.shared.open(URL(string:"App-Prefs:root=Bluetooth")!, options: [:], completionHandler: nil)
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

