//
//  OrderCellTableViewCell.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet var viewBG:UIView?
    @IBOutlet var lblOrderNo:UILabel?
    @IBOutlet var lblOrderDate:UILabel?
    @IBOutlet var lblOrderTimeUILabel:UILabel?
    @IBOutlet var lblOrderPayment:UILabel?
    @IBOutlet var lblStatus:UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBG?.layer.cornerRadius = 10;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
