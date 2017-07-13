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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 15
        bgView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
