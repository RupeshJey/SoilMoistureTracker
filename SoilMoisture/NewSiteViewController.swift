//
//  NewSiteViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/18/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class NewSiteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //@IBOutlet weak var siteNameView: UIView!
    //@IBOutlet weak var soilTypeView: UIView!
    //@IBOutlet weak var sitePhotoView: UIView!
    //@IBOutlet weak var notesView: UIView!
    @IBOutlet weak var siteName: UITextField!
    @IBOutlet weak var soilTypes: UICollectionView!
    
    var selectedIndex = -1
    var selectedLocation:CGRect = CGRect.init()
    
    let borderWidth:CGFloat = 1.0
    
    let soilNames =
        [//"Clay (Heavy)",
         //"Silty Clay",
         "Clay",
         "Silty Clay Loam",
         "Clay Loam",
         "Silt",
         "Silt Loam",
         //"Sandy Clay",
         "Loam",
         "Sandy Clay Loam",
         "Sandy Loam",
         //"Loamy Sand",
         "Sand"]
    
    let colorArray = [#colorLiteral(red: 0.3713131547, green: 0.7777945399, blue: 0.7097390294, alpha: 1), #colorLiteral(red: 0.9231385589, green: 0.3095912635, blue: 0.3254902363, alpha: 1), #colorLiteral(red: 0.2526341081, green: 0.3262489438, blue: 0.482858479, alpha: 1), #colorLiteral(red: 0.4549019608, green: 0.3529411765, blue: 0.5254901961, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        soilTypes.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        siteName.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // Save
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    
    MARK: Collection View Methods
    
    */
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = soilTypes.dequeueReusableCell(withReuseIdentifier: "soilTypeCell", for: indexPath as IndexPath) as! SoilTypeCollectionViewCell
        
        cell.soilName.text = soilNames[indexPath.row]
        cell.soilName.numberOfLines = -1
        
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        if self.selectedIndex == -1 {
            cell.contentView.backgroundColor = UIColor.white
        }
            
        else {
            if self.selectedIndex == indexPath.row {
                //cell.contentView.backgroundColor = UIColor.blue
            }
                
            else {
                cell.contentView.backgroundColor = UIColor.white
            }
        }
        
        /*switch (indexPath.row / 4) % 4 {
        case 0:
            switch indexPath.row % 4
            {
            case 0:
                <#code#>
            case 0:
            case 0:
            case 0:
            default:
                <#code#>
            }
        case 1:
            
        case 2:
            
        case 3:
            
        default:
            <#code#>
        }*/
        
        if (indexPath.row / 4) % 4 == 0 {
            cell.contentView.backgroundColor = colorArray[indexPath.row % 4]
        }
        
        else {
            cell.contentView.backgroundColor = colorArray[3 - indexPath.row % 4]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Selected item")
        
        if selectedIndex == indexPath.row {
            selectedIndex = -1
            
            let cell:UICollectionViewCell = self.soilTypes.cellForItem(at: indexPath)!
            
            self.soilTypes.bringSubview(toFront: cell)
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                cell.frame.size.height = self.selectedLocation.size.height
                cell.frame.size.width = self.selectedLocation.size.width
                
                cell.frame.origin.x = self.selectedLocation.origin.x
                cell.frame.origin.y = self.selectedLocation.origin.y
                
                
            }, completion: nil)
            
            for view in self.soilTypes.subviews {
                if view != cell {
                    view.alpha = 1.0
                }
            }
        }
        
        else {
            
            let cell:UICollectionViewCell = self.soilTypes.cellForItem(at: indexPath)!
            
            selectedIndex = indexPath.row
            selectedLocation = cell.frame
            
            self.soilTypes.bringSubview(toFront: cell)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                cell.frame.size.height = 150
                cell.frame.size.width = 150
                
                cell.frame.origin.x = 0
                cell.frame.origin.y = 0
                
            }, completion: nil)
            
            for view in self.soilTypes.subviews {
                if view != cell {
                    view.alpha = 0.0
                }
            }
        }
    }
    
    //
    
    // Return button resigns keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
