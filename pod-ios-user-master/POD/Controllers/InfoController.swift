//
//  InfoController.swift
//  POD
//
//  Created by Apple on 23/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class InfoController: NSObject {

    static func GetInfo(vc:UIViewController,txt:UITextView,Slug:String){
        do{
            try
//                vc.showSpinner(onView: vc.view)
            ApiManager.sharedInstance.requestGETURL("\(Constant.gatePageURL)\(Slug)", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                   var response = (JSON.dictionaryObject!["ResponseData"]) as? [String:Any];
                    Helper.SetHTMLContent(desc:(response!["Content"] as! String),txtView:txt)
//                    print(response as Any)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
//                vc.removeSpinner(onView: vc.view)
              
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
//                vc.removeSpinner(onView: vc.view)
            }
            
        }
       
    }
    
}
