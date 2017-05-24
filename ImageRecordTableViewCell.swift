//
//  ImageRecordTableViewCell.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 5/9/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit

class ImageRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var ImageLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
