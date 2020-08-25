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
    
    static func GetOTP(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestPOSTURL(Constant.getOTPURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    
    static func ReGetOTP(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestPOSTURL(Constant.getResendURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    
static func UserRegistration(vc:UIViewController,dicObj:[String:AnyObject]){
    do{
        vc.showSpinner(onView: vc.view); ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.signUpUrl, imageData: dicObj["ProfileImage"] as! Data, parameters: dicObj, success: { (JSON) in
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
            vc.removeSpinner(onView: vc.view)
        }, failure:{ (Error) in
            Helper.ShowAlertMessage(message:Error.localizedDescription , vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner(onView: vc.view)
        })
    }
    catch let error{
        Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
        vc.removeSpinner(onView: vc.view)
    }
}
}
