//
//  ObservationsTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/1/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class ObservationsTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var PhotoView: UIView!
    @IBOutlet weak var SiteView: UIView!
    @IBOutlet weak var NotesView: UIView!
    
    @IBOutlet weak var NotesField: UITextView!
    //@IBOutlet weak var SiteButton: UIButton!
    
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    
    let cornerRadius:CGFloat = 10.0         // Corner radius
    let borderWidth:CGFloat = 1.5           // Border width
    
    let sitesID = "sitesList"               // Constant to retrieve sites
    var sitesArray:[Any]?                   // Array of sites
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        PhotoView.layer.cornerRadius = cornerRadius
        SiteView.layer.cornerRadius = cornerRadius
        NotesView.layer.cornerRadius = cornerRadius
        PhotoView.addSubview(photo)
        
        photo.layer.cornerRadius = cornerRadius
        photo.clipsToBounds = true
        
        //SiteView.backgroundColor = UIColor.white
        //NotesView.backgroundColor = UIColor.white
        
        SiteView.layer.borderWidth = borderWidth
        NotesView.layer.borderWidth = borderWidth
        
        SiteView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:228/255.0, alpha: 1).cgColor
        NotesView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:228/255.0, alpha: 1).cgColor
        
        sitesArray = UserDefaults.standard.array(forKey: sitesID)
        
        //SiteButton.layer.cornerRadius = cornerRadius
        
        NotesField.centerVertically()
        NotesField.delegate = self
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Notes"
        placeholderLabel.font = UIFont.systemFont(ofSize: (NotesField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        NotesField.backgroundColor = UIColor.clear
        NotesView.addSubview(placeholderLabel)
        NotesView.bringSubview(toFront: NotesField)
        placeholderLabel.frame.origin = CGPoint(x: 60, y: 43)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !NotesField.text.isEmpty
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sitesArray!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let siteData = NSKeyedUnarchiver.unarchiveObject(with: sitesArray![row] as! Data) as! Site
        return siteData.siteName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func adjustContentSize(tv: UITextView){
        let deadSpace = tv.bounds.size.height - tv.contentSize.height
        let inset = max(0, deadSpace/2.0)
        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustContentSize(tv: textView)
        
        if !textView.text.isEmpty {
            placeholderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("shiftTable"), object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

