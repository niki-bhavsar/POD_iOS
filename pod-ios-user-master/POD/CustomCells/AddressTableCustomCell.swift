//
//  AddressTableCustomCell.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

//protocol ActionButtonDelegate{
//    func EditTapped(at index:IndexPath)
//    func DeleteTapped(at index:IndexPath)
//}

class AddressTableCustomCell: UITableViewCell {
    @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    var indexPath:IndexPath!
//    var delegate:ActionButtonDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(dict : [String : Any]){
        //        lblAddress?.text = add
        
        if let address : String = dict["Address"] as? String{
            let addArray : [String] = address.components(separatedBy: "--")
            if(addArray.count > 0){
                lblAddress.text = addArray[0]
            }
            if(addArray.count == 2){
                lblAddress.text = addArray[0]
                lblAddress.text = "\(lblAddress.text ?? ""), \(addArray[1])"
            }
            
            if(addArray.count == 3){
                lblAddress.text = addArray[0]
                lblAddress.text = "\(lblAddress.text ?? ""), \(addArray[1])"
                lblAddress.text = "\(lblAddress.text ?? ""), \(addArray[2])"
            }
        }
        
        if let addressIcon = dict["Title"]{
            if((addressIcon as! String) == "Home"){
                imgType?.image = UIImage.init(named: "HomeAddICon")
            } else if((addressIcon as! String) == "Work"){
                imgType?.image = UIImage.init(named: "OfficeAddIcon")
            } else if((addressIcon as! String) != "Work" && (addressIcon as! String) != "Home"){
                imgType?.image = UIImage.init(named: "LocationAddIcon")
            }
        }
    }
    
    //    @IBAction func EditButtonTapped(_ sender: UIButton) {
    //        self.delegate.EditTapped(at: indexPath)
    //       }
    //
    //    @IBAction func DeleteButtonTapped(_ sender: UIButton) {
    //        self.delegate.DeleteTapped(at: indexPath)
    //    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
