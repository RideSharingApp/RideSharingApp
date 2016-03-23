//
//  RideTableViewCell.swift
//  RideSharing
//
//  Created by Tarang khanna on 3/7/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var tolabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var starLabel: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
