//
//  ProfileResetPasswordViewController.swift
//  POD
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ProfileResetPasswordViewController: BaseViewController {

    @IBOutlet var txtCurrentPassword:UITextField!
    @IBOutlet var txtNewPassword:UITextField!
    @IBOutlet var txtConfirmPassword:UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubMit_Click(){
              if(txtCurrentPassword.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter current password." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txtNewPassword.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter new password." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
              else if(txtConfirmPassword.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter confirm password." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                return;
               }
                else if(txtConfirmPassword.text != txtNewPassword.text){
                 Helper.ShowAlertMessage(message:"Confirm password does not match" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                 return;
                }
        else if(txtNewPassword.text!.count<4){
            Helper.ShowAlertMessage(message:"Password must contains at least 4 character long." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                       return;
        }
//              else if(!Helper.isValidPassword(testPwd: txtNewPassword.text)){
//                   Helper.ShowAlertMessage(message:"Password must contains one lowecase characters ,one uppercase characters ,one special symboles in the list '@#$%' length at least 6 characters and maximum of 20" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
//                   return;
//               }
        
        
               txtConfirmPassword.resignFirstResponder()
               txtNewPassword.resignFirstResponder()
               txtCurrentPassword.resignFirstResponder()
               let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
               var otpDic = [String:AnyObject]()
               if let Id = userInfo!["Id"]{
                    otpDic["Id"] = Id as AnyObject
               }
               otpDic["OldPassword"] = txtCurrentPassword.text as AnyObject
               otpDic["NewPassword"] = txtNewPassword.text as AnyObject
              ForgetPassController.ChangePassword(vc:self,dicObj:otpDic)
    }
   
}

extension ProfileResetPasswordViewController
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string != ""){
            if(textField == txtConfirmPassword || textField == txtNewPassword || textField == txtCurrentPassword){
                if(textField.text!.count<4){
                    return true;
                }
                return false;
            }
        }
        return true;
    }
}
