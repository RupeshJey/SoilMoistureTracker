//
//  AddSiteViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class AddSiteViewController: UITableViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // Connections to storyboard
    @IBOutlet weak var  soilTypeLabel: UILabel!,        // Type of site
                        siteImage: UIImageView!,        // Image of site
                        nameField: UITextField!,        // Name of site
                        descriptionField: UITextField!  // Description of site
    
    let sitesID = "sitesList"   // Constant to retrieve sites
    
    // Variables
    var image:UIImage?, // Image variable
        site:Site?,     // Site type
        soil:Soil?,     // Soil object
        soilType = ""   // Soil type string
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set image to default photo
        image = #imageLiteral(resourceName: "Sandbox-50.png")
        
        // Size image view
        siteImage.frame = CGRect.init(x: 310, y: 40, width: 35, height: 35)
        siteImage.image = image
        
        // Temporary soil setting
        if (UserDefaults.standard.string(forKey: "tempSoilType") == nil) {UserDefaults.standard.set("", forKey: "tempSoilType")}
        
        // Default soil type
        soilType = UserDefaults.standard.string(forKey: "tempSoilType")!
        
        // Initialize soil
        soil = Soil.init()
    }

    // Update soil type text after returning to screen
    override func viewWillAppear(_ animated: Bool) {
        soilTypeLabel.text = UserDefaults.standard.string(forKey: "tempSoilType")
    }
    
    // Dismiss controller
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Save site
    @IBAction func save(_ sender: Any) {
        
        if (nameField.text == nil) {nameField.text = ""}
        if (descriptionField.text == nil) {descriptionField.text = ""}
        
        site = Site.init(name: nameField.text!, description: descriptionField.text!, image: self.image!, type: soilTypeLabel.text!)
        
        var sitesArray = UserDefaults.standard.array(forKey: sitesID)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.site!)
        sitesArray?.append(data)
        UserDefaults.standard.set(sitesArray, forKey: self.sitesID)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Trigger table selections
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Image picker
        if (indexPath.row == 2) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        // Soil selector
        if (indexPath.row == 3) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SoilTypeTableViewController") as! SoilTypeTableViewController
            vc.selectedString = soilTypeLabel.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Set image after selecting
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            siteImage.frame = CGRect.init(x: 274, y: 8, width: 84, height: 112)
            siteImage.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Return button resigns keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
