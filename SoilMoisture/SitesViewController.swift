//
//  SitesViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SitesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let sitesID = "sitesList"
    var sitesArray:[Any]?
    
    @IBOutlet weak var sitesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (UserDefaults.standard.array(forKey: sitesID) == nil) {
            UserDefaults.standard.set([], forKey: sitesID)
        }
        
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
        //print("count: ", sitesArray?.count)
        sitesTableView.reloadData()
        UIView.transition(with: self.view,
                                  duration: 0.15,
                                  options: [.curveEaseInOut, .transitionCrossDissolve],
                                  animations: { () -> Void in
                                    self.sitesTableView.reloadRows(at: self.sitesTableView.indexPathsForVisibleRows!, with: .none)
        }, completion: nil)
    }
    
    @IBAction func AddSite(_ sender: Any) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSiteViewController")
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (sitesArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteTableViewCell", for: indexPath) as! SiteTableViewCell
        
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![indexPath.row] as! Data) as! Site
        cell.siteName.text = siteData.siteName
        cell.siteImage.image = siteData.siteImage
        cell.siteDescription.text = siteData.siteDescription
        cell.siteSoilType.text = siteData.soilTypeString
        print("name: ", siteData.siteName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
