//
//  MyOrderController.swift
//  POD
//
//  Created by Apple on 18/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class MyOrderController: NSObject {
    
    public static var listOrders:[[String:Any]]?
    public static var listTempOrders:[[String:Any]]?
    public static var listOrderDetails:[[String:Any]]?
    public static var listNotification:[[String:Any]]?
    static func GetOrders(userId:String,vc:MyOrderViewController){
        do{
            try
            
            vc.tblOrder?.reloadData()
            vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestGETURL(Constant.getOrdersbyIDURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                listOrders = [[String:Any]]()
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listOrders = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listOrders as Any)
                    self.FilterData(index: 1);
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func FilterData(index:Int){
        if(index == 1){
            listTempOrders = listOrders?.filter{($0["Status"] as! String) == "1"}
        }
        else{
            listTempOrders = listOrders?.filter{($0["Status"] as! String) == "2" || ($0["Status"] as! String) == "4" || ($0["Status"] as! String) == "5" || ($0["Status"] as! String) == "6"}
        }
    }
    
    static func GetOrderByorderId(orderId:String,vc:OrderDetailViewController){
        do{
            try
                listOrderDetails = [[String:Any]]()
                vc.tblOrderDetails?.reloadData()
                vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestGETURL(Constant.getOrdersbyOrderIDURL+orderId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                listOrderDetails = [[String:Any]]()
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let dicObjOrder = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:AnyObject]]);
//                    print(dicObjOrder)
                    listOrderDetails = dicObjOrder;
                    vc.tblOrderDetails.reloadData()
                    
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
                
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func GetTransportationCharges(lat:String,lng:String,vc:PaymentDetailViewController){
        do{
            try
                vc.showSpinner(onView: vc.view)
            
            var dicObj = [String:AnyObject]()
            dicObj["DestLat"] = lat as AnyObject;
            dicObj["DestLng"] = lng as AnyObject;
            ApiManager.sharedInstance.requestPOSTURL(Constant.getTrasportationChargeURL,params: dicObj, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let dicObjOrder = ((JSON.dictionaryObject!["ResponseData"]) as? [String:Any]);
                    if let transportation = dicObjOrder?["TransportationCharge"] as? NSNumber {
                        Constant.TrasportationCharges = Double(truncating: transportation)
                    }
                    else if let transportation = dicObjOrder?["TransportationCharge"] as? String {
                        Constant.TrasportationCharges = Double(transportation)!
                    }
                    vc.lblVisitingCost.text = Constant.TrasportationCharges.description;
                    let p = Double(Constant.SelectedCategory!["Price"] as! String)!
                    let h = Double(Constant.OrderDic!["ShootingHours"]! as! String)!
                    let price = (p*h)
                    let gst = ((price*18)/100)
                    let total = (Double(vc.lblVisitingCost.text!)! + Double(price)+gst)
                    
                    vc.lblShootCost.text = price.description
                    vc.lblTotal.text = String(format: "%.2f", total);
                    Constant.OrderDic!["GST"] = gst as AnyObject;
                    Constant.OrderDic!["Transportation"] = vc.lblVisitingCost.text as AnyObject
                    Constant.OrderDic!["SubTotal"] = vc.lblShootCost.text as AnyObject
                    Constant.OrderDic!["Total"] = vc.lblTotal.text as AnyObject
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
            }
        }
    }
    
    
    static func CreateOrder(vc:PaymentDetailViewController,orderInfo:[String:AnyObject]){
        do{
            vc.showSpinner(onView: vc.view)
            
            ApiManager.sharedInstance.requestPOSTURL(Constant.CreateOrderURL, params: orderInfo, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                        vc.navigationController!.popToRootViewController(animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name("closePopup"), object: nil)
                    }
                    
                    Helper.ShowAlertMessageWithHandlesr(message:"Your order has been placed successfully but still in the Queue to confirm, you will be notified on confirmation",title:"Your booking has been placed successfully." ,vc: vc,action:callActionHandler)
                    
                }
                else{
                    Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    static func ExtendOrder(vc:ExtendViewController,orderInfo:[String:AnyObject]){
        do{
            vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestPOSTURL(Constant.extendOrderRequestURL, params: orderInfo, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                    MyOrderController.GetOrderByorderId(orderId:orderInfo["ExtOrderId"] as! String , vc: vc.vc!)
                        vc.dismiss(animated: true, completion: nil  )
                        
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg!.description , vc: vc,action:callActionHandler)
                    
                }
                else{
                    Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    
    
    
    
    
    static func GetNotificatins(userId:String,vc:MyNotificationViewController){
        do{
            try
                listNotification = [[String:Any]]()
            vc.tblOrder?.reloadData()
            vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.getNotificationbyIDURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listNotification = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listNotification as Any)
                    
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func DeleteNotificatins(userId:String,notificationID:String,vc:MyNotificationViewController){
        do{
            try
            vc.tblOrder?.reloadData()
            vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.deleteNotificationbyIDURL+notificationID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    if(listNotification != nil){
                        listNotification?.removeAll();
                    }
                    //MyOrderController.GetNotificatins(userId:userId , vc: vc)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func DeleteAllNotificatins(userId:String,vc:MyNotificationViewController){
        do{
            try
            vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestGETURL(Constant.deleteAllNotification+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    MyOrderController.GetNotificatins(userId:userId , vc: vc)
                }
                else{
                Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner(onView: vc.view)
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
                
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner(onView: vc.view)
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    
    static func photographOrderPayment(vc:SendPaymentViewController,orderInfo:[String:AnyObject]){
        do{
            vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestPOSTURL(Constant.photographOrderPaymentURL, params: orderInfo, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                        
                        vc.popPushToVC(ofKind:  ContainerViewController.self, pushController: vc)
                        
                    }
                Helper.ShowAlertMessageWithHandlesr(message:"Your request has been send successfully ,You will notify soon.",title:"" ,vc: vc,action:callActionHandler)
                }
                else{
                    Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    
    static func ExtendedOrderPayment(vc:ExtendOrderPaymentViewController,orderInfo:[String:AnyObject]){
           do{
               vc.showSpinner(onView: vc.view)
               ApiManager.sharedInstance.requestPOSTURL(Constant.extendOrderPaymentURL, params: orderInfo, success: {
                   (JSON) in
                   let msg =  JSON.dictionary?["Message"]
                   if((JSON.dictionary?["IsSuccess"]) != false){
                       let callActionHandler = { () -> Void in
                        vc.navigationController?.popViewController(animated: true);
                       }
                   Helper.ShowAlertMessageWithHandlesr(message:"Your request has been send successfully ,You will notify soon.",title:"" ,vc: vc,action:callActionHandler)
                   }
                   else{
                       Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    static func ExtendedRemainPhotoGrapherOrderPayment(vc:ExtendPhotographerPaymentViewController,orderInfo:[String:AnyObject]){
           do{
               vc.showSpinner(onView: vc.view)
               ApiManager.sharedInstance.requestPOSTURL(Constant.PASOrderPaymentdURL, params: orderInfo, success: {
                   (JSON) in
                   let msg =  JSON.dictionary?["Message"]
                   if((JSON.dictionary?["IsSuccess"]) != false){
                       let callActionHandler = { () -> Void in
                           vc.navigationController?.popViewController(animated: true);
                        
                    }
                   Helper.ShowAlertMessageWithHandlesr(message:"Payment has been done successfully.",title:"" ,vc: vc,action:callActionHandler)
                   }
                   else{
                       Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    static func ExtendedRemainPhotoGrapherOrderPayment(vc:SendPaymentViewController,orderInfo:[String:AnyObject]){
        do{
            vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestPOSTURL(Constant.PASOrderPaymentdURL, params: orderInfo, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                        vc.navigationController?.popViewController(animated: true);
                    }
                Helper.ShowAlertMessageWithHandlesr(message:"Payment has been done successfully.",title:"" ,vc: vc,action:callActionHandler)
                }
                else{
                    Helper.ShowAlertMessage(message: msg!.description, vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
    
    
}
