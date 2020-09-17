//
//  SignupController.swift
//  POD
//
//  Created by Apple on 11/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class SignupController: NSObject {
    
    static func GetOTP(vc:SignUpOTPViewController, dicObj : [String : Any]){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.getOTPURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    
    static func ReGetOTP(vc:SignUpOTPViewController, dicObj : [String : Any]){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.getResendURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    
static func UserRegistration(vc:SignUpOTPViewController, dicObj : [String : Any]){
    do{
        vc.showSpinner()
        
        ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.signUpUrl, imageData: dicObj["ProfileImage"] as? Data, parameters: dicObj, success: { (JSON) in
            let result = JSON.string?.parseJSONString!
            let msg =  result!["Message"]
            if(((result!["IsSuccess"]) as! Bool) != false){
                let callActionHandler = { () -> Void in
                                       for controller in vc.navigationController!.viewControllers as Array {
                                           if controller.isKind(of: LoginViewController.self) {
                                               vc.navigationController!.popToViewController(controller, animated: true)
                                               break
                                           }
                                       }
                                   }
                Helper.ShowAlertMessageWithHandlesr(message:"Thanks For Your Register" , vc: vc,action:callActionHandler)
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
