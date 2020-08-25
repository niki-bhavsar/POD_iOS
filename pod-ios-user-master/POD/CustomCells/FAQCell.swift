//
//  FAQCell.swift
//  POD
//
//  Created by Apple on 07/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    @IBOutlet var lblContent:UILabel!
    @IBOutlet var lblQ:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
