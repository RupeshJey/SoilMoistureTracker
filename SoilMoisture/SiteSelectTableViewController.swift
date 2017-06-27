//
//  SiteSelectTableViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/24/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SiteSelectTableViewController: UITableViewController {

    let sitesID = "sitesList"   // Constant to retrieve sites
    var sitesArray:[Any]?       // Sites array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure array is not nil
        if (UserDefaults.standard.array(forKey: sitesID) == nil) {
            UserDefaults.standard.set([], forKey: sitesID)
        }
        
        // Load sites from save
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
        
        // Set row heights
        self.tableView.rowHeight = 135
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cancel
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    // One section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows as number of sites
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sitesArray?.count)!
    }

    // Return cell with site properties
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteTableViewCell", for: indexPath) as! SiteTableViewCell
        
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![indexPath.row] as! Data) as! Site
        cell.siteName.text = siteData.siteName
        cell.siteImage.image = siteData.siteImage
        cell.siteDescription.text = siteData.siteDescription
        cell.siteSoilType.text = siteData.soilTypeString
        
        return cell
    }
    
    // Set site upon selection and return
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![indexPath.row] as! Data) as! Site
        UserDefaults.standard.set(siteData.siteName, forKey: "tempSiteName")
        self.dismiss(animated: true, completion: nil)
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
