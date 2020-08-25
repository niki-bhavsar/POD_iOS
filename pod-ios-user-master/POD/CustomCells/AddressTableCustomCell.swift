//
//  AddressTableCustomCell.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol ActionButtonDelegate{
    func EditTapped(at index:IndexPath)
    func DeleteTapped(at index:IndexPath)
}

class AddressTableCustomCell: UITableViewCell {

    @IBOutlet var lblAddress:UILabel?
    @IBOutlet var imgType:UIImageView?
    @IBOutlet var btnEdit:UIButton?
    @IBOutlet var btnDelete:UIButton?
    var indexPath:IndexPath!
     var delegate:ActionButtonDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetData(add:String,icon:String){
        lblAddress?.text = add;
        imgType?.image = UIImage.init(named: "icon")
    }
    
    @IBAction func EditButtonTapped(_ sender: UIButton) {
        self.delegate.EditTapped(at: indexPath)
       }
    
    @IBAction func DeleteButtonTapped(_ sender: UIButton) {
        self.delegate.DeleteTapped(at: indexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
