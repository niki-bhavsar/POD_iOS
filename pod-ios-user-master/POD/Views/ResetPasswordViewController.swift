//
//  ResetPasswordViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ResetPasswordViewController: BaseViewController {

    @IBOutlet var txtOTP:UITextField!
    @IBOutlet var txtNewPassword:UITextField!
    @IBOutlet var txtConfirmPassword:UITextField!
    public var mobileNo:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        txtNewPassword.delegate = self;
        self.InitializeKeyBoardNotificationObserver()
        //self.txtNewPassword.addDoneButtonOnKeyboard(view: self.view)
        //self.txtConfirmPassword.addDoneButtonOnKeyboard(view: self.view)
    }
    
    
    @IBAction func btnResend_Click(){
       var otpDic = [String:Any]()
       otpDic["E_O_P"] = mobileNo as AnyObject;
       ForgetPassController.ForgetPasswordReSendOTP(vc:self,dicObj:otpDic)
    }
    
    @IBAction func btnSubmit_Click(){
        
        if(txtOTP.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter received OTP" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtNewPassword.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter new password." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtConfirmPassword.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter confirmpassword" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtConfirmPassword.text != txtNewPassword.text){
             Helper.ShowAlertMessage(message:"Confirm password does not match" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
             return;
        }
//        else if(!Helper.isValidPassword(testPwd: txtNewPassword.text)){
//            Helper.ShowAlertMessage(message:"Password must contains one lowecase characters ,one uppercase characters ,one special symboles in the list '@#$%' length at least 6 characters and maximum of 20" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
//            return;
//        }
        
        else if(txtNewPassword.text!.count<4){
            Helper.ShowAlertMessage(message:"Password must contains at least 4 character long." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                       return;
        }
        
        var otpDic = [String:Any]()
        otpDic["E_O_P"] = mobileNo
        otpDic["OTP"] = txtOTP.text
        otpDic["Password"] = txtNewPassword.text
        ForgetPassController.ResetPasswordSubmit(vc:self,dicObj:otpDic)
    }
}

extension ResetPasswordViewController
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string != ""){
            if(textField == txtNewPassword || textField == txtConfirmPassword){
                if(textField.text!.count<4){
                    return true;
                }
                return false;
            }
        }
        return true;
    }
}

