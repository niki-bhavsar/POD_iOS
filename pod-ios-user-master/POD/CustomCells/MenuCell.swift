//
//  MenuCellTableViewCell.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet public var icon:UIImageView!
    @IBOutlet public var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetData(icon:String, name:String){
        
        self.icon.image = UIImage.init(named: icon)
        self.lblTitle.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
