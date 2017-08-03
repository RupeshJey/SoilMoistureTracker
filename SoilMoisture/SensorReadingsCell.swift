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
    //@IBOutlet weak var WaterBar: UIView!
    
    // Moisture Views
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var waveWater: UIView!
    @IBOutlet weak var barWater: UIView!
    
    // Resistance Views
    @IBOutlet weak var resistanceLabel: UILabel!
    
    // Temperature Views
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureCelsiusLabel: UILabel!
    @IBOutlet weak var temperatureBar:UIView!
    
    // Date Views
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let cornerRadius:CGFloat = 10.0         // Corner radius
    var temperature:Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        MoistureView.layer.cornerRadius = cornerRadius
        TemperatureView.layer.cornerRadius = cornerRadius
        ResistanceView.layer.cornerRadius = cornerRadius
        DateView.layer.cornerRadius = cornerRadius
        
        
        //UIView.animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
        
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
