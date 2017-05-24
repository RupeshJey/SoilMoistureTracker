//
//  InitialMetadaViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
//import SQLite

class InitialMetadaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*let id = Expression<Int64>("id")
    let date = Expression<String>("date")
    let userID = Expression<String>("userID")
    let soilType = Expression<String>("soilType")
    let siteID = Expression<String>("siteID")
    let resistivity = Expression<String>("resistivity")
    let moisture = Expression<String>("moisture")
    let weather = Expression<String>("weather")
    let coordinates = Expression<Double>("coordinates")
    let OS = Expression<String>("OS")
    let image = Expression<String>("image")
    let notes = Expression<String>("notes")*/
    
    let openedKeyID = "openedBefore"
    let userMetadataID = "userMetadata"
    
    var UID = ""
    
    @IBOutlet weak var MetadataTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        
        for view in self.MetadataTable.subviews {
            if view.tag == 7 {
                UID = (view as! TextInputTableViewCell).textField.text!
                
                print("UserID: ", UID)
            }
        }
        
        let UM:UserMetadata = UserMetadata.init(UID: UID, deviceOS: UIDevice.current.systemVersion)
        
        print("UserID: ", UM.userID)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: UM)
        UserDefaults.standard.set(data, forKey: userMetadataID)
        
        UserDefaults.standard.set(true, forKey: openedKeyID)
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //homeworkIDArray = NSMutableArray(array: homeworkDict.allKeys)
        
        return 2//homeworkDict.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //NSLog("ADD ONE!")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! TextInputTableViewCell
        
        
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Username"
            cell.tag = 7
        case 1:
            cell.textField.placeholder = "Password"
            cell.textField.isSecureTextEntry = true
        default:
            cell.textField.placeholder = "Password"
            cell.textField.isSecureTextEntry = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        NSLog("Pushed!")
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "User Information"
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        NSLog("HEY IM DONE")
        
        if indexPath?.row == 0 {
            UID = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
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
