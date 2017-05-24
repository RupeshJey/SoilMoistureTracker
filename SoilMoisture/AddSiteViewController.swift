//
//  AddSiteViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class AddSiteViewController: UITableViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    
    let sitesID = "sitesList"
        
        //
    
    //@IBOutlet weak var soilTypePicker: UIPickerView!
    
    @IBOutlet weak var soilTypeLabel: UILabel!
    
    
    @IBOutlet weak var siteImage: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    
    
    var image:UIImage?
    
    var site:Site?
    
    var soil:Soil?
    var soilType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        image = #imageLiteral(resourceName: "Sandbox-50.png")
        siteImage.frame = CGRect.init(x: 310, y: 40, width: 35, height: 35)
        siteImage.image = image
        
        if (UserDefaults.standard.string(forKey: "tempSoilType") == nil) {UserDefaults.standard.set("", forKey: "tempSoilType")}
        
        soilType = UserDefaults.standard.string(forKey: "tempSoilType")!
        
        soil = Soil.init()
        
        print(soil!.soilType)
    }

    override func viewWillAppear(_ animated: Bool) {
        //soilTypeLabel.text = soilType
        //print("Text: ", soilTypeLabel.text)
        
        soilTypeLabel.text = UserDefaults.standard.string(forKey: "tempSoilType")
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return soilTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return soilTypes[row]
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 2) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        if (indexPath.row == 3) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SoilTypeTableViewController") as! SoilTypeTableViewController
            vc.selectedString = soilTypeLabel.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        NSLog("\(info)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = image
            siteImage.frame = CGRect.init(x: 274, y: 8, width: 84, height: 112)
            siteImage.image = image
            dismiss(animated: true, completion: nil)
        }
        
    }
    
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
