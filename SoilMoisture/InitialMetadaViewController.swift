//
//  InitialMetadaViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class InitialMetadaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MetadataTable: UITableView!  // Metadata Table
    
    let openedKeyID = "openedBefore",   // Constant to check if app has been opened
        userMetadataID = "userMetadata" // Constant to retrieve user metadata
    
    let sitesID = "sitesList"               // Constant to retrieve sites
    
    var UID = ""    // User UID
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Save when done and go back to tab controller
    @IBAction func done(_ sender: Any) {
        
        for view in self.MetadataTable.subviews {
            if view.tag == 7 {
                UID = (view as! TextInputTableViewCell).textField.text!
            }
        }
        
        let UM:UserMetadata = UserMetadata.init(UID: UID, deviceOS: UIDevice.current.systemVersion),
            data = NSKeyedArchiver.archivedData(withRootObject: UM)
        
        UserDefaults.standard.set(data, forKey: userMetadataID)
        
        UserDefaults.standard.set(true, forKey: openedKeyID)
        UserDefaults.standard.set([], forKey: sitesID)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: TableView Delegate Methods
    
    // One section
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return 1
    }
    
    // Rows as necessary
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // UID and passwords for now
        return 2
    }
    
    // Fill out cell as needed for input parameters
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    // Save UID
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if indexPath?.row == 0 {
            UID = (tableView.cellForRow(at: indexPath!)?.textLabel?.text)!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
