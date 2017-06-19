//
//  DataLogViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class DataLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Storyboard Objects
    
    @IBOutlet weak var soilRecord: UITableView!
    
    let recordsID = "recordsID"
    
    var recordsArray:[Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (UserDefaults.standard.array(forKey: recordsID) == nil) {
            UserDefaults.standard.set([], forKey: recordsID)
        }
        
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
        
        self.soilRecord.reloadData()
    }

    @IBAction func addSoilRecord(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSoilRecordViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    // Mark: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //homeworkIDArray = NSMutableArray(array: homeworkDict.allKeys)
        
        return (recordsArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //NSLog("ADD ONE!")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoilRecordTableViewCell", for: indexPath) as! SoilRecordTableViewCell
        
        /*switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Username"
        case 1:
            cell.textField.placeholder = "Password"
            cell.textField.isSecureTextEntry = true
        default:
            cell.textField.placeholder = "Password"
            cell.textField.isSecureTextEntry = true
        }*/
        
        let soilRecordData = NSKeyedUnarchiver.unarchiveObject(with: recordsArray![indexPath.row] as! Data) as! SoilDataRecord
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, hh:mm a zz"
        
        cell.dateLabel.text = formatter.string(from: soilRecordData.date)
        cell.moistureLabel.text = soilRecordData.moisture
        cell.siteNameLabel.text = soilRecordData.siteName
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NSLog("Pushed!")
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
