//
//  SiteInfoTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SiteInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var siteNameLabel: UILabel!
    
    @IBOutlet weak var soilTypeLabel: UILabel!
    @IBOutlet weak var siteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 15
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.init(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).cgColor
        
        siteImageView.layer.cornerRadius = 40
        siteImageView.layer.borderWidth = 0.5
        siteImageView.layer.borderColor = UIColor.init(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
