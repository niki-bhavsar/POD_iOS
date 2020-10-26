//
//  ReferralCell.swift
//  POD
//
//  Created by CrossGrids on 24/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ReferralCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
