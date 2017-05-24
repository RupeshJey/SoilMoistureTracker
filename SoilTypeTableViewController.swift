//
//  SoilTypeTableViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/23/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SoilTypeTableViewController: UITableViewController {

    var soilTypes = ["Clay (Heavy)", "Silty Clay", "Clay", "Silty Clay Loam", "Clay Loam", "Silt", "Silt Loam", "Sandy Clay", "Loam", "Sandy Clay Loam", "Sandy Loam", "Loamy Sand", "Sand"]
    
    var selectedRow:NSInteger = -1
    
    var selectedString:String?
    
    let sitesID = "sitesList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //self.navigationController?.navigationBar.topItem?.title = selectedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.title = selectedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return soilTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soilCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = soilTypes[indexPath.row]
        
        if soilTypes[indexPath.row] != selectedString! {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .checkmark
            //self.navigationController?.popViewController(animated: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedString = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        //print(selectedString)
        UserDefaults.standard.setValue(selectedString, forKey: "tempSoilType")
        //self.navigationController?.navigationBar.topItem?.title = selectedString
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
