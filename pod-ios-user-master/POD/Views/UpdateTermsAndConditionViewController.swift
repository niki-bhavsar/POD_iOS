//
//  UpdateTermsAndConditionViewController.swift
//  POD
//
//  Created by Apple on 18/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class UpdateTermsAndConditionViewController: UIViewController, NVActivityIndicatorViewable {
    
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
        
        
   
            let imageUrl:NSURL = NSURL(string:  account.profileImage)!
                      if(imageUrl.absoluteString?.count != 0){
                          DispatchQueue.global(qos: .default).async {
                              if(imageUrl != nil){
                                  let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                                  DispatchQueue.main.async {
                                      let image = UIImage(data: imageData as Data)
                                    self.profileImage = image!
                                  }
                              }
                          }
                      }
                      else{
                      }
                  
                  
        
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
    
    
    @IBAction func submitclicked(_ sender: Any) {
       
//        let userInfo : [String : Any] = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as! [String : Any]
     
        
        var otpDic = [String : Any]()
        otpDic["Id"] = account.user_id
        otpDic["Name"] = account.name
        otpDic["Address"] = account
        otpDic["Phone"] = account.phone
        otpDic["Gender"] = account.gender
        otpDic["DOB"] = account.dob
        otpDic["TermsCondition"] = "1"
        otpDic["ProfileImage"] = nil
        otpDic["ProfileImage"] = profileImage.jpegData(compressionQuality: 0.5)
        
        startAnimating()
        ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.updateCustomerProfileURL, imageData: otpDic["ProfileImage"] as? Data, parameters: otpDic, success: { (JSON) in
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
//                Helper.ArchivedUserDefaultObject(obj: JSON.dictionaryObject!["ResponseData"]! as! [String : Any], key: "UserInfo")
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
