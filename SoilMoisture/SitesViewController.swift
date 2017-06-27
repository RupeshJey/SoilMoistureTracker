//
//  SitesViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SitesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sitesTableView: UITableView! // Table to display sites
    
    let sitesID = "sitesList"                       // Constant to retrieve sites
    var sitesArray:[Any]?                           // Array of sites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sites from saved data
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Reload table when user reappears after adding a site
        
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
        sitesTableView.reloadData()
        UIView.transition(with: self.view,
                                  duration: 0.15,
                                  options: [.curveEaseInOut, .transitionCrossDissolve],
                                  animations: { () -> Void in
                                    self.sitesTableView.reloadRows(at: self.sitesTableView.indexPathsForVisibleRows!, with: .none)
        }, completion: nil)
    }
    
    // Bring up controller to add site
    
    @IBAction func AddSite(_ sender: Any) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSiteViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    // Only one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows as number of sites
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sitesArray?.count)!
    }
    
    // Fill in parameters for each site
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteTableViewCell", for: indexPath) as! SiteTableViewCell
        
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![indexPath.row] as! Data) as! Site
        cell.siteName.text = siteData.siteName
        cell.siteImage.image = siteData.siteImage
        cell.siteDescription.text = siteData.siteDescription
        cell.siteSoilType.text = siteData.soilTypeString
        print("name: ", siteData.siteName)
        cell.selectionStyle = .none
        
        return cell
    }
    
    // Enable editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle a deletion event
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Remove the data from array and update tableview
            
            sitesArray?.remove(at: indexPath.row)
            UserDefaults.standard.set(sitesArray, forKey: sitesID)
            UIView.transition(with: self.view,
                              duration: 0.15,
                              options: [.curveEaseInOut, .transitionCrossDissolve],
                              animations: { () -> Void in
                                self.sitesTableView.reloadData()
            }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
