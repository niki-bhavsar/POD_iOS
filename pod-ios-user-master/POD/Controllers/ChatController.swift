//
//  ChatController.swift
//  POD
//
//  Created by Apple on 04/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ChatController: NSObject {
    public static var listChat:[[String:Any]]?
    public static var listAdminChat:[[String:Any]]?
    
    static func GetChatMessage(vc:ChatViewController,senderID:String,receiverID:String,OrderID:String){
        do{
            try
                listChat = [[String:Any]]()
            //vc.tblChat?.reloadData()
            vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL("\(Constant.getMessageURL)\(senderID)/\(receiverID)/\(OrderID)", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listChat = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]]
                    
                    listChat = listChat!.sorted { personSort(p1:$0 as [String : AnyObject], p2:$1 as [String : AnyObject]) }
//                    print(listChat as Any)
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblChat?.reloadData()
                vc.refreshControl.endRefreshing()
                DispatchQueue.main.async {
                    if(self.listChat!.count != 0){
                        let indexPath = IndexPath(row: self.listChat!.count-1, section: 0)
                        vc.tblChat?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
            
        }
        
    }
    
    static func GetAdminChatMessage(vc:AdminChatViewController,senderID:String,receiverID:String){
        do{
            try
                //listAdminChat = [[String:Any]]()
                //vc.tblChat?.reloadData()
                vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL("\(Constant.GetdminMessageURL)/\(senderID)/\(receiverID)", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listAdminChat = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    listAdminChat = listAdminChat!.sorted { personSort(p1:$0 as [String : AnyObject], p2:$1 as [String : AnyObject]) }
//                    print(listAdminChat as Any)
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblChat?.reloadData()
                vc.refreshControl.endRefreshing()
                DispatchQueue.main.async {
                    if(self.listAdminChat != nil){
                        if(self.listAdminChat!.count != 0){
                            let indexPath = IndexPath(row: self.listAdminChat!.count-1, section: 0)
                            vc.tblChat?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
            
        }
        
    }
    
    static func GetChatMessageWithoutLoadder(vc:ChatViewController,senderID:String,receiverID:String,OrderID:String){
        do{
            try
                // listChat = [[String:Any]]()
                //vc.tblChat?.reloadData()
                // vc.showSpinner(onView: vc.view)
                ApiManager.sharedInstance.requestGETURL("\(Constant.getMessageURL)\(senderID)/\(receiverID)/\(OrderID)", success: { (JSON) in
                    let msg =  JSON.dictionary?["Message"]
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        listChat = [[String:Any]]()
                        listChat = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                        listChat = listChat!.sorted { personSort(p1:$0 as [String : AnyObject], p2:$1 as [String : AnyObject]) }
//                        print(listChat as Any)
                    }
                    else{
                        //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    }
                    vc.removeSpinner()
                    vc.tblChat?.reloadData()
                    vc.refreshControl.endRefreshing()
                    DispatchQueue.main.async {
                        if(self.listChat!.count != 0){
                            let indexPath = IndexPath(row: self.listChat!.count-1, section: 0)
                            vc.tblChat?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        }
                    }
                }) { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner ()
                    vc.refreshControl.endRefreshing()
            }
            
        }
        
    }
    
    static func personSort(p1:[String:Any], p2:[String:Any]) -> Bool {
        let s1 = (p1["Id"] as! String)
        let s2 = (p2["Id"] as! String)
        return s1 < s2
    }
    
    static func SendMessage(vc:ChatViewController,dicObj:[String:Any]){
        do{
            vc.showSpinner()
            
            ApiManager.sharedInstance.requestPOSTURL(Constant.SendMessageURL,  params: dicObj, success: { (JSON) in
                
                let msg =  (JSON.dictionary?["Message"])
                if((JSON.dictionary?["IsSuccess"]) != false){
                    self.GetChatMessage(vc: vc, senderID: (dicObj["Sender"] as! String), receiverID: (dicObj["Receiver"] as! String),OrderID: (dicObj["orderId"] as! String))
                }
                else{
                    Helper.ShowAlertMessage(message:(msg?.rawString())! , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
            }, failure:{ (Error) in
                Helper.ShowAlertMessage(message:Error.localizedDescription , vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
            })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
    
    static func SendAdminMessage(vc:AdminChatViewController,dicObj:[String:Any]){
        do{
            vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.SendAdminMessageURL,  params: dicObj, success: { (JSON) in
                
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    self.GetAdminChatMessage(vc: vc, senderID: (dicObj["Sender"] as! String), receiverID: (dicObj["Receiver"] as! String))
                }
                else{
                    Helper.ShowAlertMessage(message:(msg as? String)! , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
            }, failure:{ (Error) in
                Helper.ShowAlertMessage(message:Error.localizedDescription , vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
            })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
}
