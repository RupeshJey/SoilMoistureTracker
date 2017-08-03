//
//  SiteInfoTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

protocol SiteInfoTableViewCellDelegate {
    func graphSelectionDone()
}

class SiteInfoTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var siteNameLabel: UILabel!
    
    @IBOutlet weak var soilTypeLabel: UILabel!
    @IBOutlet weak var siteImageView: UIImageView!
    
    //@IBOutlet weak var topLine: UIView!
    
    @IBOutlet weak var graphSelector: UITextField!
    
    var graphPicker:UIPickerView? = UIPickerView.init()
    
    private var delegate: SiteInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 15
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.init(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).cgColor
        
        siteImageView.layer.cornerRadius = 40
        siteImageView.layer.borderWidth = 2
        siteImageView.layer.borderColor = UIColor.white.cgColor
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: siteImageView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 40, height: 40)).cgPath
        siteImageView.layer.mask = maskLayer
        
        //graphSelector.isUserInteractionEnabled = false
        graphPicker?.delegate = self
        
        
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        graphSelector.inputAccessoryView = toolBar
        
        
        
        graphSelector.inputView = graphPicker
        graphSelector.tintColor = UIColor.clear
        
    }
    
    func dismissPicker() {
        //self.graphSelector.resignFirstResponder()
        print("DONE!")
        self.delegate?.graphSelectionDone()
    }
    
    func setup(delegate: SiteInfoTableViewCellDelegate) {
        self.delegate = delegate
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Graph Type"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
