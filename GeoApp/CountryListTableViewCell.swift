//
//  CountryListTableViewCell.swift
//  GeoApp
//
//  Created by Sibin Baby on 24/06/2016.
//  Copyright © 2016 SibinBaby. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var continentNameLabel: UILabel!
    @IBOutlet var countryCodeView: UIView!
    @IBOutlet var countryCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
