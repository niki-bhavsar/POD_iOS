//
//  ForgetPassController.swift
//  POD
//
//  Created by Apple on 13/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ForgetPassController: NSObject {

    static func ForgetPasswordSendOTP(vc:ForgetPasswordViewController,dicObj:[String:Any]!){
        do{
            
            try
                vc.showSpinner()
                ApiManager.sharedInstance.requestPOSTURL(Constant.forgetPassOTPURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
                    DispatchQueue.main.async {
                                           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                           let controller = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        controller.mobileNo = dicObj["E_O_P"] as! String; vc.navigationController!.pushViewController(controller, animated: true)
                                       }
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
    
    static func ForgetPasswordReSendOTP(vc:ResetPasswordViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.forgetPasswordResend, params: dicObj, success: {
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
    
    static func ResetPasswordSubmit(vc:ResetPasswordViewController,dicObj:[String:Any]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.ResetPasswordSubMitURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                        vc.navigationController?.popViewController(animated: true)
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg!.description , vc: vc,action:callActionHandler)
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
    
    static func ChangePassword(vc:ProfileResetPasswordViewController,dicObj:[String:Any]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.ChangedPasswordURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                   
                    let callActionHandler = { () -> Void in
                        ForgetPassController.Logout(vc: vc)
                    }
                    Helper.ShowAlertMessageWithHandlesr(message: msg!.description, vc: vc, action:callActionHandler)

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
    
    static func Logout(vc:UIViewController){
        //UserDefaults.standard.removeObject(forKey: "UserInfo")
        //UserDefaults.standard.synchronize()
        
        var isPresent:Bool = false;
        var findVc:UIViewController?
        if let viewControllers = vc.navigationController?.viewControllers {
            for viewController in viewControllers {
                // some process
                if viewController is  LoginViewController{
                    isPresent = true;
                    findVc = viewController;
                    break;
                }
            }
        }
        AccountManager.instance().activeAccount = nil
        if(isPresent){
            vc.navigationController?.popToViewController(findVc!, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.navigationController?.viewControllers.insert(controller, at: 1)
            vc.navigationController?.popToViewController(controller, animated: true)
        }

    }
}
