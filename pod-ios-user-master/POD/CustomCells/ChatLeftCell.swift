//
//  ChatLeftCell.swift
//  POD
//
//  Created by Apple on 03/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ChatLeftCell: UITableViewCell {

    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblMSg:UILabel!
    @IBOutlet var imgUser:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func SetData(dic:[String: Any],title:String = "Photographer"){
        lblTitle.text = title;
        lblMSg.text = dic["Message"] as! String;
    }

}
