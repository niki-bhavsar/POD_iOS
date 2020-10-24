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
    
    public static var listAddress = [[String:Any]]()
    
    public static var listSearchAddress = [[String:Any]]()
    
    static func GetAddressList(userID:String,vc:BookingAddressViewController){
        do{
            try
                vc.showSpinner()
            listAddress = [[String:Any]]()
            ApiManager.sharedInstance.requestGETURL(Constant.getAddreesByIDURL+""+userID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listAddress = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!
                    vc.tblAdd.reloadData()
                } else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblAdd?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
//    static func GetAddressAutoList(searchText:String,vc:AddAddressViewController){
//        DispatchQueue.global(qos: .background).async {
//          ApiManager.sharedInstance.requestGETURL(Constant.searchAddressURL+""+searchText, success: { (JSON) in
//                 if((JSON.dictionary?["IsSuccess"]) != false){
//                     listSearchAddress = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                 }
//                vc.tblArea?.reloadData()
//             },failure: {(error) in
//                 print(error)
//                vc.tblArea?.reloadData()
//          })
//            DispatchQueue.main.async {
//               vc.tblArea?.reloadData()
//            }
//        }
//        
//    }
    
    static func AddAddress(vc:AddAddressViewController,dicObj:[String:Any]!){
        do{
            
            try
               
            ApiManager.sharedInstance.requestPOSTURL(Constant.addAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    if let address : String = dicObj!["Address"] as? String{
                              let addArray : [String] = address.components(separatedBy: "--")
                              var strAddress = String()
                              if(addArray.count > 0){
                                  strAddress = addArray[0]
                              }
                              if(addArray.count == 2){
                                  strAddress = addArray[0]
                                  strAddress = "\(strAddress), \(addArray[1])"
                              }
                              
                              if(addArray.count == 3){
                                  strAddress = addArray[0]
                                  strAddress = "\(strAddress), \(addArray[1])"
                                  strAddress = "\(strAddress), \(addArray[2])"
                              }
                              Constant.OrderDic["ShootingAddress"] = strAddress
                          }
                    if let lat = dicObj["Lat"]{
                        Constant.OrderDic["ShootingLat"] = lat
                    }
                    if let lng = dicObj["Lng"]{
                        Constant.OrderDic["ShootingLng"] = lng
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MeetinPonitLocationViewController") as! MeetinPonitLocationViewController
                    vc.navigationController?.pushViewController(controller, animated: true)
                    
                } else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    }
                    vc.removeSpinner()
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner()
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
    
    static func DeleteAddress(vc:BookingAddressViewController, dicObj:[String:Any]!){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.deleteAddressById, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc)
                        AddressController.GetAddressList(userID:  dicObj!["CustomerId"] as! String, vc: vc)
                    } else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    }
                vc.removeSpinner()
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner()
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
    
    static func EditAddress(vc:AddAddressViewController,dicObj:[String:Any]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.editAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        if let Address = dicObj["Address"]{
                            Constant.OrderDic["ShootingAddress"] = Address
                        }
                        if let lat = dicObj["Lat"]{
                            Constant.OrderDic["ShootingLat"] = lat
                        }
                        if let lng = dicObj["Lng"]{
                            Constant.OrderDic["ShootingLng"] = lng 
                        }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MeetinPonitLocationViewController") as! MeetinPonitLocationViewController
                        vc.navigationController?.pushViewController(controller, animated: true)
                        
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                        
                        
                    }
                    vc.removeSpinner()
                }, failure: { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner()
                })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
}
