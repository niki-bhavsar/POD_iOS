//
//  AddressController.swift
//  POD
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class AddressController: NSObject {
    public static var listAddress:[[String:Any]]?
    public static var listSearchAddress:[[String:Any]]?
    static func GetAddressList(userID:String,vc:BookingAddressViewController){
        do{
            try
                vc.showSpinner(onView: vc.view)
            listAddress = []; ApiManager.sharedInstance.requestGETURL(Constant.getAddreesByIDURL+""+userID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listAddress = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    vc.tblAdd.reloadData()
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblAdd?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func GetAddressAutoList(searchText:String,vc:AddAddressViewController){
        DispatchQueue.global(qos: .background).async {
          ApiManager.sharedInstance.requestGETURL(Constant.searchAddressURL+""+searchText, success: { (JSON) in
                 if((JSON.dictionary?["IsSuccess"]) != false){
                     listSearchAddress = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                 }
                vc.tblArea?.reloadData()
             },failure: {(error) in
                 print(error)
                vc.tblArea?.reloadData()
          })
            DispatchQueue.main.async {
               vc.tblArea?.reloadData()
            }
        }
        
    }
    
    static func AddAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestPOSTURL(Constant.addAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        if let Address = dicObj["Address"]{
                                                    Constant.OrderDic!["ShootingAddress"] = Address as AnyObject
                                               }
                                               if let lat = dicObj["Lat"]{
                                                    Constant.OrderDic!["ShootingLat"] = lat as AnyObject
                                               }
                                               if let lng = dicObj["Lng"]{
                                                    Constant.OrderDic!["ShootingLng"] = lng as AnyObject
                                               }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MeetinPonitLocationViewController") as! MeetinPonitLocationViewController
                        vc.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                        
                        
                    }
                    vc.removeSpinner(onView: vc.view)
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner(onView: vc.view)
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner(onView: vc.view)
        }
    }
    
    static func DeleteAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestPOSTURL(Constant.deleteAddressById, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc)
                        AddressController.GetAddressList(userID:  dicObj!["CustomerId"] as! String, vc: vc as! BookingAddressViewController)
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                        
                        
                    }
                    vc.removeSpinner(onView: vc.view)
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner(onView: vc.view)
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner(onView: vc.view)
        }
    }
    
    static func EditAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestPOSTURL(Constant.editAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        if let Address = dicObj["Address"]{
                             Constant.OrderDic!["ShootingAddress"] = Address as AnyObject
                        }
                        if let lat = dicObj["Lat"]{
                             Constant.OrderDic!["ShootingLat"] = lat as AnyObject
                        }
                        if let lng = dicObj["Lng"]{
                             Constant.OrderDic!["ShootingLng"] = lng as AnyObject
                        }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MeetinPonitLocationViewController") as! MeetinPonitLocationViewController
                        vc.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                        
                        
                    }
                    vc.removeSpinner(onView: vc.view)
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner(onView: vc.view)
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner(onView: vc.view)
        }
    }
}
