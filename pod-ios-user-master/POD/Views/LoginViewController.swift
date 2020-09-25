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
import AuthenticationServices

class LoginViewController: BaseViewController,GIDSignInDelegate {
    
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet public var viewSocial:UIView!
    @IBOutlet public var useOther:UILabel!
    @IBOutlet public var seperator:UILabel!
    
    @IBOutlet weak var btnApple: UIButton!
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
    @IBAction func btnApple_Click(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let appleIdRequest = provider.createRequest()
            appleIdRequest.requestedScopes = [.fullName, .email]
            
            let paswordProvider = ASAuthorizationPasswordProvider()
            let passwordRequest = paswordProvider.createRequest()
            
            let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest, passwordRequest])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            print("iOS 13")
        }
    }
    
    @IBAction func btnFacebook_Click(){
        LoginController.LoginWithFaceBook(vc:self)
    }
    
    @IBAction func btnGoogle_Click(){
        LoginController.LoginWithGoogle(vc:self)
    }
}

extension LoginViewController {
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
            userInfo["ProfileImage"] = Data.init()
        }
        userInfo["Name"] = fullName
        userInfo["Email"] = email
        userInfo["Phone"] = ""
        userInfo["Address"] = ""
        userInfo["OTP"] = "1234"
        userInfo["Password"] = idToken
        userInfo["SignBy"] = "3"
        userInfo["SocialId"] = "3"
        LoginController.FacebookRegistration(vc: self, dicObj: userInfo)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
// MARK:- ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            let appleId = credentials.user
            
            let appleUserFirstName: String = credentials.fullName?.givenName ?? ""
            
            let appleUserLastName: String = credentials.fullName?.familyName ?? ""
            
            let appleUserEmail: String = credentials.email ?? ""
            
            //self.showCompleteProfileScreen(strFirstName: appleUserFirstName , strLastName: appleUserLastName , strEmail: appleUserEmail, strPhone: "", strBirthdate: "")
            
        case let passwordCredentials as ASPasswordCredential:
            let appleUsername = passwordCredentials.user
            
            let applePassword: String = passwordCredentials.password
            
            //let message: String  = "Apple User ID: \(appleUsername), \n  password: \(applePassword)"
            
            //Utility.showAlertWithOkButton(withMessage: message)
            //self.showCompleteProfileScreen(strFirstName: "" , strLastName: "" , strEmail: "", strPhone: "", strBirthdate: "")
            
        default:
            break
        }
    }
}

@available(iOS 13.0, *)
func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("authorizationController error: \(error.localizedDescription)")
}


// MARK:- ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
