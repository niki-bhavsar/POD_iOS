//
//  LoginViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleSignIn
import  NotificationBannerSwift

class LoginViewController: BaseViewController,GIDSignInDelegate {
    
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet public var viewSocial:UIView!
    @IBOutlet public var useOther:UILabel!
    @IBOutlet public var seperator:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        GIDSignIn.sharedInstance().delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  let controller = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SIgnUpViewController") as! SIgnUpViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnLoginClick(){
        if(txtEmail.text!.count == 0){
            Helper.ShowAlertMessage(message: "Please enter email/phoneno.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        if(txtPassword.text!.count == 0){
            Helper.ShowAlertMessage(message: "Please enter password.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        let loginUser = LoginUser.init(username: txtEmail.text!, password: txtPassword.text!)
        LoginController.Login(loginUser: loginUser, vc: self);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Constant.notificationCount = 0;
        LoginController.CheckSuccess(vc: self);
    }
    
    @IBAction func btnFacebook_Click(){
        LoginController.LoginWithFaceBook(vc:self)
    }
    
    @IBAction func btnGoogle_Click(){
        LoginController.LoginWithGoogle(vc:self)
    }
}

extension LoginViewController{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      self.showSpinner()
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let profileImageURL = user.profile.imageURL(withDimension: 100)
      let email = user.profile.email
      
        var userInfo:[String:Any] = [String:Any]()
        let imageData:NSData = NSData(contentsOf: profileImageURL!)!
        if(imageData != nil){
            userInfo["ProfileImage"] = imageData
        }
        else{
            userInfo["ProfileImage"] = Data.init() as AnyObject
        }
        userInfo["Name"] = fullName as AnyObject
        userInfo["Email"] = email as AnyObject
        userInfo["Phone"] = "" as AnyObject
        userInfo["Address"] = "" as AnyObject
        userInfo["OTP"] = "1234" as AnyObject?
        userInfo["Password"] = idToken as AnyObject?
        userInfo["SignBy"] = "3" as AnyObject?
        userInfo["SocialId"] = "3" as AnyObject?
        LoginController.FacebookRegistration(vc: self, dicObj: userInfo)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
