//
//  CategoryCollectionCellCollectionViewCell.swift
//  POD
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol CategoryActionButtonDelegate{
    func InfoTapped(at index:IndexPath)
}
class CategoryCollectionCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var img:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    var delegate:CategoryActionButtonDelegate!
    var indexPath:IndexPath!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func SetData(dic:[String:Any]){
        let imageUrl:URL = URL(string: dic["Image"] as! String)!
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let imageData:NSData? = NSData(contentsOf: imageUrl) ?? nil
             DispatchQueue.main.async {
                if(imageData != nil){
                    let image = UIImage(data: imageData as! Data)
                 self.img.image = image
                 self.img.contentMode = UIView.ContentMode.scaleAspectFill
                }
                self.activityIndicator.stopAnimating()
             }
         }
        self.lblTitle.text = dic["Title"] as! String
    }
    
    @IBAction func InfoButtonTapped(_ sender: UIButton) {
     self.delegate.InfoTapped(at: indexPath)
    }
    
}
