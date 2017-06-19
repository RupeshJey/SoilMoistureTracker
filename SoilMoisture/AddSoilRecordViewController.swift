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
    
    let openedKeyID = "openedBefore"
    let userMetadataID = "userMetadata"
    let recordsID = "recordsID"
    
    var recordsArray:[Any]?
    
    @IBOutlet weak var Save: UIButton!
    @IBOutlet weak var DataTable: UITableView!
    
    var nrfManagerInstance:NRFManager!
    
    var invalid:String = "-------"
    
    var date:String = ""
    var resistance:String = ""
    var temperature:String = ""
    var moisture:String = ""
    
    var temp:Double = 0.0
    
    var locManager = CLLocationManager()
    
    var image:UIImage?
    var imageBool:Bool = false
    
    var shouldRefreshSensor:Bool = true
    
    let newPin = MKPointAnnotation()
    
    var siteString = ""
    
    var soilRecord:SoilDataRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupInvalids()
        
        enableButtons(enabled: false)
        
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
        
        UserDefaults.standard.set("", forKey: "tempSiteName")
        

        //self.view.bringSubview(toFront: DataTable)
        
        DataTable.isUserInteractionEnabled = true
        DataTable.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !self.hasOpenedBefore() {self.getMetadata()}
        
        measure(0)
        
        let weather = WeatherGetter.init(delegate: self)
        weather.getWeather(latitude: String(locManager.location!.coordinate.latitude), longitude: String(locManager.location!.coordinate.longitude))
        
        siteString = UserDefaults.standard.string(forKey: "tempSiteName")!
    }
    
    // Make the main data fields as invalid (sensor hasn't collected)
    func setupInvalids() {
        date = invalid
        resistance = invalid
        temperature = invalid
        moisture = invalid
    }
    
    // Check whether the app has been opened before
    func getMetadata() {
        print("Getting metadata")
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialMetadaViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func hasOpenedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: openedKeyID)
    }
    
    // Enable/disable the buttons on the page
    
    func enableButtons(enabled:Bool) {
        if (enabled) {
            //Discard.isEnabled = true
            //Save.isEnabled = true
        }
        else {
            //Discard.isEnabled = false
            //Save.isEnabled = false
        }
    }
    
    // This function handles data collection from the sensor and error handling
    @IBAction func measure(_ sender: Any) {
        print("Measuring!")
        
        if(!getArduinoData()) {
            let alert = UIAlertController(title: "Error", message: "Could not connect to Arduino. Please check the connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // TODO: Connect this feature to Arduino sensor to get valid sensor data
    func getArduinoData() -> Bool {
        
        nrfManagerInstance = NRFManager(
            onConnect: {
                print("Connected")
                //self.sendData()
        },
            onDisconnect: {
                print("Disconnected")
        },
            onData: {
                (data:Data?, string:String?)->() in
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
                
                self.date = formatter.string(from: Date())
                
                //let dataString = String(describing: data)
                
                //print("Received data - String: \(string!) - Data: \(dataString)")
                
                //if
                
                let indexStartOfText = string!.index(string!.startIndex, offsetBy: 3)
                
                if string!.contains("A: ") {
                    //print(string!)
                }
                
                if string!.contains("V: ") {
                    //print(string!)
                }
                
                if string!.contains("R: ") {
                    self.resistance = string!.substring(from: indexStartOfText)
                    //self.temp = 20.0
                    self.temperature = "20℃"
                    
                    if (Double(self.resistance) != nil) {
                        var moistureValue = 80*2374.3 * pow(Double(self.resistance)! , -0.598)
                        
                        moistureValue = Double(round(1000*moistureValue)/1000)
                        
                        print("moisture value: ", moistureValue)
                        self.moisture = String(moistureValue)
                        self.moisture.append(" %")
                    }
                    
                    
                }
                
                if (self.shouldRefreshSensor) {
                    self.DataTable.reloadData()
                }
                
                self.enableButtons(enabled: true)
        }
        )
        
        nrfManagerInstance.autoConnect = false
        
        //nrfManagerInstance.verbose = true
        
        nrfManagerInstance.connect("JPLSoil")
        
        //nrfManager.connect("UART")
        
        
        /*let sensor = SensorGetter()
        
        sensor.parseData()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
        
        date = formatter.string(from: Date())
        resistance = sensor.resistance
        temperature = sensor.temperature*/
        
        return true
    }
    
    // Pull up new page to finalize data point addition
    @IBAction func save(_ sender: Any) {
        print("Saving!")
        
        if (UserDefaults.standard.array(forKey: recordsID) == nil) {
            UserDefaults.standard.set([], forKey: recordsID)
        }
        
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
        
        soilRecord = SoilDataRecord.init(recordSiteName: self.siteString, recordDate:  Date.init(), recordMoisture: moisture)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.soilRecord!)
        
        recordsArray?.append(data)
        
        UserDefaults.standard.set(recordsArray, forKey: recordsID)
        
        /*let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewRecordViewController") as! UINavigationController
        (nextVC.topViewController as! NewRecordViewController).setSensorData(sensorDate: date, sensorResistance: resistance, sensorTemperature: temperature, sensorMoisture: moisture)
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)*/
        
    }
    
    // Discard the collected data
    @IBAction func discard(_ sender: Any) {
        print("Discarding!")
        
        setupInvalids()
        enableButtons(enabled: false)
        
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if (hasOpenedBefore()) {
            return 3
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
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
        
        switch indexPath.section {
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
                //cell.mapView.layer.clipsToBounds = true
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newRecordCell", for: indexPath) as! NewRecordTableViewCell
            
            cell.selectionStyle = .none
            return cell
            
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
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRecordCell", for: indexPath) as! AddRecordTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 1:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SiteSelectTableViewController")
                self.present(vc, animated: true, completion: nil)
            case 2:
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 2 && indexPath.row == 2 && imageBool == true) {
            return 128;
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {
            return 216;
        }
        else {
            return 44;
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        NSLog("\(info)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            imageBool = true
            dismiss(animated: true, completion: nil)
            
            DataTable.reloadData()
        }
        
    }
    
    func didGetWeather(weather: Weather) {
        
        DispatchQueue.main.async() {
            self.temp = weather.tempFahrenheit
            self.DataTable.reloadData()
        }
        
    }
    
    func didNotGetWeather(error: NSError) {
        print("didNotGetWeather error: \(error)")
    }
    
    func didBeginEditing() {
        shouldRefreshSensor = false
        
        if (imageBool) {
            DataTable.setContentOffset(CGPoint.init(x: 0, y: 334), animated: true)
        }
        
        else {
            DataTable.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
        }
        
        
        DataTable.allowsSelection = false
    }
    
    func didEndEditing() {
        shouldRefreshSensor = true
        if (imageBool) {
            DataTable.setContentOffset(CGPoint(x: 0, y: 199), animated: true)
        }
            
        else {
            DataTable.setContentOffset(CGPoint(x: 0, y: 115), animated: true)
        }
        
        DataTable.allowsSelection = true
        
        measure(0)
    }
    
    // ---------------------------
    
    // MARK: Bluetooth Methods
    
    // ---------------------------
    
    func sendData()
    {
        let result = self.nrfManagerInstance.writeString("Hello, world!")
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
