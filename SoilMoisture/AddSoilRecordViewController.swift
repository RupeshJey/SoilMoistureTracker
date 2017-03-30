//
//  AddSoilRecordViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class AddSoilRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let openedKeyID = "openedBefore"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //createDBTest()
    }
    
    /*func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !self.hasOpenedBefore() {self.getMetadata()}
    }
    
    // Check whether the app has been opened before
    func getMetadata() {
        print("Getting metadata")
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialMetadaViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func hasOpenedBefore() -> Bool {return UserDefaults.standard.bool(forKey: openedKeyID)}
    
    // TODO: Connect this feature to Arduino sensor to get valid sensor data
    @IBAction func measure(_ sender: Any) {
        print("Measuring!")
    }
    
    // TODO: Pull up new page to finalize data point addition
    @IBAction func save(_ sender: Any) {
        print("Saving!")
    }
    
    // TODO: Discard the collected data
    @IBAction func discard(_ sender: Any) {
        print("Discarding!")
    }
    
    // Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRecordCell", for: indexPath) as! AddRecordTableViewCell
        
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            //let db = try Connection("\(path)/db.sqlite3")
            
            //let users = Table("users")
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Date"
                //cell.detailTextLabel?.text = try db.pluck(users)?[date]
            case 1:
                cell.textLabel?.text = "Resistance"
            //cell.detailTextLabel?.text = "15 k-Ohms"
            case 2:
                cell.textLabel?.text = "Temperature"
            //cell.detailTextLabel?.text = "5 ℃"
            case 3:
                cell.textLabel?.text = "Moisture"
            //cell.detailTextLabel?.text = "10 g/mL"
            default:
                cell.textLabel?.text = "Date"
            }
            
            //print(cell.frame.width)
        }
        catch {
            print("ERROR SOMEWHERE")
            cell.detailTextLabel?.text = "-------"
            cell.detailTextLabel?.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog("Pushed!")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Sensor Data"
        case 1:
            return ""
        default:
            return ""
        }
        
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
