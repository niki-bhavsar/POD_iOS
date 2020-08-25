//
//  CategoryController.swift
//  POD
//
//  Created by Apple on 05/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class CategoryController: NSObject {
    
    public static var listCategory:[[String:Any]]?
    public static var listSubCategory:[[String:Any]]?
    static func GetCategory(vc:SelectGategoryViewController){
        do{
            try
                listCategory = [[String:Any]]()
                vc.categoryCollection?.reloadData()
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL(Constant.ParentCategoryUrl, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.listCategory = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!;
//                    print( vc.listCategory as Any)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.categoryCollection?.reloadData()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
            }
            
        }
       
    }
    
    static func GetSubCategoryById(categoryID:String,vc:SelectSubCategoryViewController){
        do{
            try
                listSubCategory = [[String:Any]]()
                vc.subCategoryCollection?.reloadData()
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL(Constant.SubCategoryByIdUrl+categoryID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.listSubCategory = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!;
                    //print( vc.listSubCategory as Any)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.subCategoryCollection?.reloadData()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
            }
        }
        
    }
    
}
