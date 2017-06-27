//
//  SoilTypeTableViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/23/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SoilTypeTableViewController: UITableViewController {

    // Array of soil types
    var soilTypes =
        ["Clay (Heavy)",
        "Silty Clay",
        "Clay",
        "Silty Clay Loam",
        "Clay Loam",
        "Silt",
        "Silt Loam",
        "Sandy Clay",
        "Loam",
        "Sandy Clay Loam",
        "Sandy Loam",
        "Loamy Sand",
        "Sand"]
    
    
    var selectedRow:NSInteger = -1, // Index of selected row
        selectedString:String?      // String variable of selected row
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Tableview Methods

    // 1 section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows as number soil types
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soilTypes.count
    }

    // Return cell with name of soil
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soilCell", for: indexPath)

        cell.textLabel?.text = soilTypes[indexPath.row]
        
        if soilTypes[indexPath.row] != selectedString! {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // Set soil type upon selection 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedString = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        UserDefaults.standard.setValue(selectedString, forKey: "tempSoilType")
        tableView.reloadData()
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
