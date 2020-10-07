//
//  ChatRightCell.swift
//  POD
//
//  Created by Apple on 03/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Kingfisher

class ChatRightCell: UITableViewCell {

    @IBOutlet var lblTitle:UILabel!
     @IBOutlet var lblMSg:UILabel!
     @IBOutlet var imgUser:UIImageView!
    
    let account = AccountManager.instance().activeAccount! //Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func SetData(dic:[String: Any]){
        lblTitle.text = "You"
        lblMSg.text = dic["Message"] as? String
        
        
        if let url  = URL(string: account.profileImage) {
                      imgUser.kf.indicatorType = .activity
                      
                      imgUser.kf.setImage(
                          with: url,
                          placeholder: UIImage.init(named: "user"),
                          options: nil)
                      imgUser.layer.cornerRadius = imgUser.frame.width / 2
                 
                  }
             imgUser.clipsToBounds = true
        
        
        
//        let imageUrl:NSURL = NSURL(string: account.profileImage)!
//        if(imageUrl.absoluteString?.count != 0){
//            DispatchQueue.global(qos: .default).async {
//
//                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
//                DispatchQueue.main.async {
//                    let image = UIImage(data: imageData as Data)
//                    self.imgUser.image = image
//                    self.imgUser.contentMode = UIView.ContentMode.scaleAspectFit
//
//                }
//            }
//        }
        
        
    }

}
