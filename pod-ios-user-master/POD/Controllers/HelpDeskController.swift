//
//  HelpDeskController.swift
//  POD
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class HelpDeskController: NSObject {
    
    public static var helpInfo:[String:Any]?
    
    static func Gethelpinfo(vc:HelpDeskViewController){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL(Constant.getHelpInfoURL, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    helpInfo = (JSON.dictionaryObject!["ResponseData"]) as? [String:Any];
                    vc.SetInfo(dic: helpInfo as [String : AnyObject]?)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
            }
        }
        
    }
    
    static func SendGeneralInquiry(vc:SendGeneralInquiry,dicObj:[String:AnyObject]){
        do{
            if(vc.txtMsg.text.count==0 || vc.txtMsg.text == "Enter Message" ){
                Helper.ShowAlertMessage(message:"Please enter inquiry message." , vc: vc)
                return;
            }
            vc.showSpinner()
            
            ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.sendGeneralInquiry, imageData: dicObj["Image"] as? Data, parameters: dicObj,imageParam:"Image", success: { (JSON) in
                let result = JSON.string?.parseJSONString!
                let msg =  result!["Message"]
                if(((result!["IsSuccess"]) as! Bool) != false){
                    
                    vc.txtMsg.text = "Enter Message";
                    vc.txtMsg.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
                    let callActionHandler = { () -> Void in
                        vc.navigationController?.popViewController(animated: true)
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg as! String , vc: vc,action:callActionHandler)
                }
                else{
                    Helper.ShowAlertMessage(message:msg as! String , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
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
