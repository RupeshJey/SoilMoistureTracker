//
//  SitesInfoViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SitesInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SiteInfoTableViewCellDelegate {

    @IBOutlet weak var navBar: UINavigationBar!     // Navigation Bar
    @IBOutlet weak var sitesTable: UITableView!     // TableView
    
    let sitesID = "sitesList"                       // Constant to retrieve sites
    var sitesArray:[Any]?                           // Array of sites
    
    var rowHeight:Double? = 141,
        selectedRowHeight:Double? = 830,
        selectedRowIndex:IndexPath?,
        images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
        
        loadImages()
    }

    override func viewDidAppear(_ animated: Bool) {
        sitesTable.beginUpdates()
        sitesTable.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages() {
        for site in sitesArray! {
            let siteData = NSKeyedUnarchiver.unarchiveObject(with: site as! Data) as! Site
            images.append(resizeImage(image: siteData.siteImage!, newWidth: 200)!)
            
        }
    }
    
    @IBAction func AddSite(_ sender: Any) {
        
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addSiteVC") //as! NewSiteViewController
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
        
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
        
        return (sitesArray?.count)!
    }
    
    // Set the cell for each row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Switch depending on row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "siteInfo", for: indexPath) as! SiteInfoTableViewCell
        /*switch indexPath.row % 4 {
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
        
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![indexPath.row] as! Data) as! Site
        cell.siteNameLabel.text = siteData.siteName
        cell.soilTypeLabel.text = siteData.soilTypeString
        cell.siteImageView.image = images[indexPath.row]
        cell.setup(delegate: self)
        //cell.topLine.alpha = 0.0
        //if indexPath == selectedRowIndex {
        //    cell.topLine.alpha = 1.0
        //}
        */
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func graphSelectionDone() {
        
        
        self.view.endEditing(true)
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
