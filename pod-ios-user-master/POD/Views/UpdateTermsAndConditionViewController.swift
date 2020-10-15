//
//  UpdateTermsAndConditionViewController.swift
//  POD
//
//  Created by Apple on 18/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class UpdateTermsAndConditionViewController: UIViewController, NVActivityIndicatorViewable  {
    
    @IBOutlet weak var lblMessage: UILabel!
    
    let account : Account = AccountManager.instance().activeAccount!
    var profileImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = lblMessage.text ?? ""
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Condition")
        let range2 = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range2)
        lblMessage.attributedText = underlineAttriString
        lblMessage.isUserInteractionEnabled = true
        lblMessage.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if gesture.didTapAttributedTextInLabel(label: lblMessage, targetText: "Terms & Condition") {
            print("Terms of service")
            let controller = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if gesture.didTapAttributedTextInLabel(label: lblMessage, targetText: "Privacy Policy") {
            print("Privacy policy")
            let controller = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            print("Tapped none")
        }
    }
    
//    func showRefercodeAlert(){
//
//        let alert = UIAlertController(title:"Referral code", message: "Do you have any referral code?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "ReferCodePopup") as! ReferCodePopup
//            controller.delegate = self
//            controller.modalPresentationStyle = .overCurrentContext
//            controller.modalTransitionStyle = .crossDissolve
//            self.present(controller, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(_: UIAlertAction!) in
//            self.updateCustomerProfile(referral_Code: "")
//        }))
//        Helper.getTopViewController().present(alert, animated: true, completion: nil)
//
//
//    }
    
//    func applyClicked(code: String) {
//        updateCustomerProfile(referral_Code: code)
//    }
//
//    func cancleClicked() {
//        updateCustomerProfile(referral_Code: "")
//    }
    
    
    
    
    @IBAction func submitclicked(_ sender: Any) {
        var otpDic = [String : Any]()
        otpDic["Id"] = account.user_id
        otpDic["TermsCondition"] = "1"
        startAnimating()
        ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.updateCustomerProfileURL, parameters: otpDic, success: { (JSON) in
            let result = JSON.string?.parseJSONString!
            let msg =  result!["Message"]
            if(((result!["IsSuccess"]) as! Bool) != false){
                
                self.GetCustomerProfile(userID: otpDic["Id"] as! String, account: self.account)
            } else{
                self.stopAnimating()
                Helper.ShowAlertMessage(message:msg as! String , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
            
        }, failure:{ (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message:Error.localizedDescription , vc: self,title:"Error",bannerStyle: BannerStyle.danger)
            
        })
    }
    
    func GetCustomerProfile(userID:String, account : Account){
        ApiManager.sharedInstance.requestGETURL(Constant.getCustomerProfileURL+"/"+userID, success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                self.stopAnimating()
                account.parseUserDict(userDict: JSON.dictionaryObject!["ResponseData"] as! NSDictionary, account: account)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
                self.navigationController?.pushViewController(controller, animated: true)
                
            } else{
                self.stopAnimating()
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }
    
    
}
