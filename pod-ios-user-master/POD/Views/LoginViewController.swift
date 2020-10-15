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
import JWTDecode

class LoginViewController: BaseViewController,GIDSignInDelegate, ReferCodePopupDelegate {
    
    
    
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
        controller.isFromAppleSignin = false
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
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
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
    
    func showRefercodeAlert(userId: String){
        
        let alert = UIAlertController(title:"Referral code", message: "Do you have any referral code?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ReferCodePopup") as! ReferCodePopup
            controller.delegate = self
            controller.userId = userId
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(_: UIAlertAction!) in
            let account = Account()
            LoginController.GetCustomerProfile(vc: self, userID: userId, IsBack: false, account: account)
        }))
        Helper.getTopViewController().present(alert, animated: true, completion: nil)
    }
    
//    ReferCodePopupDelegate
    func applyClicked(code: String, userID : String) {
        var otpDic = [String : Any]()
        otpDic["Id"] = userID
       
        if(code.count > 0){
            otpDic["Referral_Code"] = code
        }
        
        startAnimating()
        ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.updateCustomerProfileURL, parameters: otpDic, success: { (JSON) in
            let result = JSON.string?.parseJSONString!
            let msg =  result!["Message"]
            if(((result!["IsSuccess"]) as! Bool) != false){
                let account = Account()
                LoginController.GetCustomerProfile(vc: self, userID: otpDic["Id"] as! String, IsBack: false, account: account)
            } else{
                self.stopAnimating()
                Helper.ShowAlertMessage(message:msg as! String , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
            
        }, failure:{ (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message:Error.localizedDescription , vc: self,title:"Error",bannerStyle: BannerStyle.danger)
            
        })
    }
    
    func cancleClicked(userID : String) {
        let account = Account()
        LoginController.GetCustomerProfile(vc: self, userID: userID, IsBack: false, account: account)
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
        //        userInfo["Address"] = ""
        userInfo["OTP"] = "1234"
        userInfo["Password"] = idToken
        userInfo["SignBy"] = "3"
        userInfo["SocialId"] = "3"
        userInfo["Gender"] = ""
        userInfo["DOB"] = ""
        userInfo["ProfileImageUrl"] = ""
        userInfo["TermsCondition"] = "0"
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
    //    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    //    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    //    let userIdentifier = appleIDCredential.user
    //    let fullName = appleIDCredential.fullName
    //    let email = appleIDCredential.email
    //    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    //    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            let appleId = credentials.user
            //            credentials.identityToken
            //            credentials.authorizationCode
            //            credentials.authorizedScopes
            //            credentials.realUserStatus
            
            var appleUserFirstName: String = credentials.fullName?.givenName ?? ""
            
            var appleUserLastName: String = credentials.fullName?.familyName ?? ""
            
            var appleUserEmail: String = credentials.email ?? ""
            
            
            
            print("Email : \(appleUserEmail)")
            
            print("Id : \(appleId)")
            
            print("Firstname : \(appleUserFirstName)")
            
            print("User : \(credentials.user)")
            
            //            print("Full NME : \(credentials.fullName)")
            
            self.saveUserInKeychain(appleId)
            
            
            //Niki
            
            
            
            if let identityTokenData = credentials.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
                do {
                    let jwt = try decode(jwt: identityTokenString)
                    let decodedBody = jwt.body as Dictionary
                    print(decodedBody)
                    print("Decoded email: "+(decodedBody["email"] as? String ?? "n/a")   )
                    appleUserEmail = decodedBody["email"] as? String ?? "n/a"
                    appleUserFirstName = ""
                    appleUserLastName = ""
                } catch {
                    print("decoding failed")
                }
            }
            
            
            var userInfo:[String:Any] = [String:Any]()
            userInfo["ProfileImage"] = Data.init()
            
            userInfo["Name"] = "\(appleUserFirstName) \(appleUserLastName)"
            userInfo["Email"] = appleUserEmail
            userInfo["Phone"] = ""
            //        userInfo["Address"] = ""
            userInfo["OTP"] = "1234"
            userInfo["Password"] = appleId
            userInfo["SignBy"] = "3"
            userInfo["SocialId"] = "3"
            userInfo["Gender"] = ""
            userInfo["DOB"] = ""
            userInfo["ProfileImageUrl"] = ""
            userInfo["TermsCondition"] = "0"
            LoginController.FacebookRegistration(vc: self, dicObj: userInfo)
            
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let controller = storyboard.instantiateViewController(withIdentifier: "SIgnUpViewController") as! SIgnUpViewController
            //            controller.isFromAppleSignin = true
            //            controller.strName = "\(appleUserFirstName) \(appleUserLastName)"
            //            controller.strEmail = appleUserEmail
            //            self.navigationController?.pushViewController(controller, animated: true)
            
            //self.showCompleteProfileScreen(strFirstName: appleUserFirstName , strLastName: appleUserLastName , strEmail: appleUserEmail, strPhone: "", strBirthdate: "")
            
        case let passwordCredentials as ASPasswordCredential:
            let appleUsername = passwordCredentials.user
            
            let applePassword: String = passwordCredentials.password
            
            let message: String  = "Apple User ID: \(appleUsername), \n  password: \(applePassword)"
            //
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let controller = storyboard.instantiateViewController(withIdentifier: "SIgnUpViewController") as! SIgnUpViewController
            //            controller.isFromAppleSignin = true
            //            self.navigationController?.pushViewController(controller, animated: true)
            
            //Utility.showAlertWithOkButton(withMessage: message)
            //self.showCompleteProfileScreen(strFirstName: "" , strLastName: "" , strEmail: "", strPhone: "", strBirthdate: "")
            
        default:
            break
        }
    }
    
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.seawindsolution.PODUser", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController error: \(error.localizedDescription)")
    }
    
}



// MARK:- ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
