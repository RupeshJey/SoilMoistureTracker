//
//  SiteTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var siteImage: UIImageView!
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var siteDescription: UILabel!
    @IBOutlet weak var siteSoilType: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
