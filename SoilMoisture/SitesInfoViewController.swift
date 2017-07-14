//
//  SitesInfoViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SitesInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var sitesTable: UITableView!
    
    var rowHeight:Double? = 141,
        selectedRowHeight:Double? = 483,
        selectedRowIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sitesTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ---------------------------
    
    // MARK: Table View Methods
    
    // ---------------------------
    
    // Set the number of sections in the table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the number of rows
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    // Set the cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Switch depending on row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteInfo", for: indexPath) as! SiteInfoTableViewCell
        switch indexPath.row % 4 {
        case 0:
            cell.bgView.backgroundColor = UIColor.init(red: 134/255.0, green: 198/255.0, blue: 181/255.0, alpha: 1.0)
        case 1:
            cell.bgView.backgroundColor = UIColor.init(red: 205/255.0, green: 80/255.0, blue: 84/255.0, alpha: 1.0)
        case 3:
            cell.bgView.backgroundColor = UIColor.init(red: 72/255.0, green: 84/255.0, blue: 121/255.0, alpha: 1.0)
        case 2:
            cell.bgView.backgroundColor = UIColor.init(red: 116/255.0, green: 90/255.0, blue: 134/255.0, alpha: 1.0)
        default:
            print("default")
        }
        return cell
    }
    
    // Row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == selectedRowIndex {
            return CGFloat(self.selectedRowHeight!)
        }
        
        return CGFloat(self.rowHeight!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected!")
        
        if selectedRowIndex == indexPath {
            selectedRowIndex = nil
            tableView.beginUpdates()
            tableView.endUpdates()
            return
        }
        
        selectedRowIndex = indexPath
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
