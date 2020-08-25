//
//  InqueryController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class InqueryController: NSObject {
    public static var listCategory:[[String:Any]]?
    public static var listSubCategory:[[String:Any]]?
    public static var listCity:[[String:Any]]?
    public static var listLocations:[[String:Any]]?
    public static var listINquiry:[[String:Any]]?
    public static var listFAQ:[[String:Any]]?
    
    static func GetCategory(vc:InqueryCategoryViewController){
        do{
            try
                listCategory = [[String:Any]]()
                vc.categoryCollection?.reloadData()
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL(Constant.ParentCategoryUrl, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.listCategory = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!;
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
    
    static func GetSubCategoryById(categoryID:String,vc:InquerySubCategoryViewController){
        do{
            try
                listSubCategory = [[String:Any]]()
                               vc.subCategoryCollection?.reloadData()
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL(Constant.SubCategoryByIdUrl+categoryID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.listSubCategory = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!;
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
    
    
    static func GetCity(vc:InqueryDetailSubmitViewConroller){
        do{
            try
                listCity = [[String:Any]]()
                
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL(Constant.getCityListURL, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.removeSpinner(onView: vc.view)
                    listCity = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    if(listCity != nil){
                        if(listCity!.count>0){
                            InqueryController.GetLocation(cityID: listCity![0]["id"] as! String, vc: vc)
                            vc.txtCity.text = listCity![0]["name"] as! String
                        }
                    }
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner(onView: vc.view)
                }
                
               
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
            }
        }
    }
    
    static func GetLocation(cityID:String,vc:InqueryDetailSubmitViewConroller){
        do{
            try
                listLocations = [[String:Any]]()
                
                vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL("\(Constant.getLocatonListURL)/\(cityID)/4", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listLocations = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listLocations)
                    if(listLocations != nil){
                        if(listLocations!.count>0){
                           
                            vc.txtLocation.text = listLocations![0]["name"] as! String
                        }
                    }
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.pickerView.reloadAllComponents();
                vc.removeSpinner(onView: vc.view)
               
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
            }
        }
    }
    
    static func SubmitQuery(vc:UIViewController,orderInfo:[String:AnyObject]){
        do{
              vc.showSpinner(onView: vc.view)
             ApiManager.sharedInstance.requestPOSTURL(Constant.orderIssueURL, params: orderInfo, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        let callActionHandler = { () -> Void in
                                              vc.navigationController?.popViewController(animated: true)
                                           }
                        Helper.ShowAlertMessageWithHandlesr(message:msg!.description , vc: vc,action:callActionHandler)
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                }, failure: { (Error) in
                    vc.removeSpinner(onView: vc.view)
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                })
            
        }
        catch let _{
            vc.removeSpinner(onView: vc.view)
        }
        
    }
    
    static func SubmitInquiryy(vc:InqueryDetailSubmitViewConroller,orderInfo:[String:AnyObject]){
        
        do{
              vc.showSpinner(onView: vc.view)
             ApiManager.sharedInstance.requestPOSTURL(Constant.inquirySubmitURL, params: orderInfo, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]
                    if((JSON.dictionary?["IsSuccess"]) != false){
                       
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "InquiryDetailInfoPopupViewcontroller") as! InquiryDetailInfoPopupViewcontroller
                        let p = Double(Constant.SelectedCategory!["Price"] as! String)!
                        let h = Double(orderInfo["ShootingHours"]! as! String)!
                        let price = (p*h)
                        
                        controller.hours = "As per submitted inquiry amount of \(Int(h).description) hours session will be"
                        controller.charge = "The submitted shooting session charge per hrs is \(Constant.SelectedCategory!["Price"] as! String)"
                        controller.amount = "\(price.description)"
                        controller.vc = vc;
                        controller.modalPresentationStyle = .overCurrentContext
                        controller.modalTransitionStyle = .crossDissolve
                        vc.infoPopup = controller;
                        //let nav = UINavigationController.init(rootViewController: controller)
                        //nav.isNavigationBarHidden = true;
                        controller.view.frame = vc.view.bounds
                        vc.view.addSubview(controller.view)
                        vc.present(controller, animated: true, completion: nil)
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                }, failure: { (Error) in
                    vc.removeSpinner(onView: vc.view)
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                })
            
        }
        catch let _{
            vc.removeSpinner(onView: vc.view)
        }
        
    }
    
    static func GetAllInquiry(userId:String,vc:MyInquiryViewController){
        do{
            try
                listINquiry = [[String:Any]]()
                vc.tblInquiry?.reloadData()
                vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.getBookingInquiryURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listINquiry = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listINquiry as Any)
                    
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblInquiry?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func GetFAQ(userId:String,vc:FAQViewController){
        do{
            try
                listFAQ = [[String:Any]]()
                vc.tblFAQ?.reloadData()
                vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.getFAQURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listFAQ = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listFAQ as Any)
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblFAQ?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func DeleteInquiry(userId:String,notificationID:String,vc:MyInquiryViewController){
        do{
            try
            vc.tblInquiry?.reloadData()
            vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.deleteInquiry+userId+"/"+notificationID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    InqueryController.GetAllInquiry(userId:userId , vc: vc)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblInquiry?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func DeleteAllInquiries(userId:String,vc:MyInquiryViewController){
        do{
            try
            vc.tblInquiry?.reloadData()
            vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.deleteAllInquiry+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    InqueryController.GetAllInquiry(userId:userId , vc: vc)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblInquiry?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
}
