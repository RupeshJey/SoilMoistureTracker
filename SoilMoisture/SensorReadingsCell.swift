//
//  SensorReadingsCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 6/30/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class SensorReadingsCell: UITableViewCell {

    @IBOutlet weak var MoistureView: UIView!
    @IBOutlet weak var ResistanceView: UIView!
    @IBOutlet weak var TemperatureView: UIView!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var WaterBar: UIView!
    
    // Moisture Views
    @IBOutlet weak var moistureLabel: UILabel!
    
    // Resistance Views
    @IBOutlet weak var resistanceLabel: UILabel!
    
    // Temperature Views
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // Date Views
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let cornerRadius:CGFloat = 10.0         // Corner radius
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        MoistureView.layer.cornerRadius = cornerRadius
        TemperatureView.layer.cornerRadius = cornerRadius
        ResistanceView.layer.cornerRadius = cornerRadius
        DateView.layer.cornerRadius = cornerRadius
        
        //WaterBar.layer.cornerRadius = cornerRadius
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: WaterBar.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        WaterBar.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
