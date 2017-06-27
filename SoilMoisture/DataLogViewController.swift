//
//  DataLogViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class DataLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var soilRecord: UITableView! // Table of records
    
    let recordsID = "recordsID" // Constant to get records from save
    var recordsArray:[Any]?     // Records array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure array is not nil
        if (UserDefaults.standard.array(forKey: recordsID) == nil) {
            UserDefaults.standard.set([], forKey: recordsID)
        }
        
        // Load records into array
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
    }
    
    // Mark: Table View
    
    // One section
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return 1
    }
    
    // Number of rows as number of records
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recordsArray?.count)!
    }
    
    // Configure each cell with the properties of each record
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoilRecordTableViewCell", for: indexPath) as! SoilRecordTableViewCell
        
        let soilRecordData = NSKeyedUnarchiver.unarchiveObject(with: recordsArray![indexPath.row] as! Data) as! SoilDataRecord
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
        
        cell.dateLabel.text = formatter.string(from: soilRecordData.date)
        cell.moistureLabel.text = soilRecordData.moisture
        cell.siteNameLabel.text = soilRecordData.siteName
        
        return cell
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
