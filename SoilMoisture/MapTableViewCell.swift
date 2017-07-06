//
//  MapTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 7/1/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView:MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
