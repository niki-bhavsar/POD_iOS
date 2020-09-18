//
//  SplashViewController.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
class SplashViewController: UIViewController {
    
    @IBOutlet var imglogo1:UIImageView!
    @IBOutlet var imglogo2:UIImageView!
    var appVersion = String()
    var iPhoneVersion = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        Helper.rootNavigation = self.navigationController;
        self.LoadAnimation()
        // Do any additional setup after loading the view.
    }
    
    func LoadAnimation(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            // HERE
            self.imglogo1.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5) // Scale your image
            
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.imglogo1.transform = CGAffineTransform.identity // undo in 1 seconds
                UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseIn, animations: {() -> Void in
                    self.imglogo1.layoutIfNeeded()
                    
                    var xPos = self.imglogo1.frame.origin.x-((((self.view.frame.size.width*50)/100)))
                    if(xPos<0){
                        xPos = (-1)*xPos
                    }
                    self.imglogo1.frame = CGRect.init(x:xPos,  y: self.imglogo1.frame.origin.y, width: self.imglogo1.frame.size.width,  height: self.imglogo1.frame.size.height);
                    
                    self.imglogo2.frame = CGRect.init(x: (self.imglogo1.frame.origin.x+self.imglogo1.frame.size.width-10),  y: self.imglogo2.frame.origin.y, width: self.imglogo2.frame.size.width,  height: self.imglogo2.frame.size.height);
                    self.imglogo2.layoutIfNeeded()
                    
                    
                    
                }, completion: {(_ finished: Bool) -> Void in
                    self.getAppVersionApi()
                    
                })
            })
        }
    }
    
    func getAppVersionApi(){
        ApiManager.sharedInstance.requestGETURL(Constant.getAppVersionURL, success: { (JSON) in
            
            //                let msg =  JSON.dictionary?["Message"]
            self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            if((JSON.dictionary?["IsSuccess"]) != false){
                let response = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                let dict : [String : Any] = response![0]
                
                self.iPhoneVersion = dict["viphone"] as! String
                if(Double(self.appVersion)! < Double(self.iPhoneVersion)!){
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SplashViewController.showUpdateAppView), userInfo: nil, repeats:  false)
                } else {
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SplashViewController.MoveToLogin), userInfo: nil, repeats:  false)
                }
                
            } else{
                
            }
        }) { (Error) in
        }
    }
    
    
    
    @objc func showUpdateAppView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UpdateAppViewController") as! UpdateAppViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func MoveToLogin(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //        let isUserExist = Helper.UnArchivedUserDefaultObject(key: "UserInfo")
        
        if (AccountManager.instance().activeAccount != nil) {
            let acc : Account = AccountManager.instance().activeAccount!
            if(acc.termsCondition == "1"){
                let controller = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "UpdateTermsAndConditionViewController") as! UpdateTermsAndConditionViewController
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
        //        if (AccountManager.instance().activeAccount != nil) {
        //            let acc : Account = AccountManager.instance().activeAccount!
        ////             let userInfo : [String : Any] = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as! [String : Any]
        //            if(acc.termsCondition == "1"){
        //                let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //                self.navigationController?.pushViewController(controller, animated: true)
        //            } else {
        //                let controller = storyboard.instantiateViewController(withIdentifier: "UpdateTermsAndConditionViewController") as! UpdateTermsAndConditionViewController
        //                self.navigationController?.pushViewController(controller, animated: true)
        //            }
        //        }else{
        //            let controller = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
    }
    
}
