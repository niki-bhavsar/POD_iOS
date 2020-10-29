//
//  ReferAndEarnViewController.swift
//  POD
//
//  Created by Apple on 13/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import FirebaseDynamicLinks

class ReferAndEarnViewController: BaseViewController {
    
    @IBOutlet weak var lblNoOrderMessage: UILabel!
    @IBOutlet weak var referalCodeTitle: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblReferalCode: UILabel!
    var account = Account()
    var strMessage = String()
    var invitationUrl = String()
    
    @IBOutlet weak var myReferralView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateReferandEarnView(_:)),
                                               name: NSNotification.Name("UpdateReferAndEarnView"),
                                               object: nil)
        
        account = AccountManager.instance().activeAccount!
        lblPoints.text = account.referralPoint
        lblReferalCode.text = account.referralCode
        
        self.codeView.isHidden = true
        self.btnShare.isHidden = true
        self.referalCodeTitle.isHidden = true
        self.myReferralView.isHidden = true
        self.lblNoOrderMessage.isHidden = false
        
        createLink()
        
        GetCustomerProfile(userID: account.user_id, account: account)
    }
    
    @objc func updateReferandEarnView(_ notification: Notification){
        account = AccountManager.instance().activeAccount!
        lblPoints.text = account.referralPoint
        lblReferalCode.text = account.referralCode
        
        self.codeView.isHidden = true
        self.btnShare.isHidden = true
        self.referalCodeTitle.isHidden = true
        self.myReferralView.isHidden = true
        self.lblNoOrderMessage.isHidden = false
        
        GetCustomerProfile(userID: account.user_id, account: account)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor =   UIColor.init(hexString: "#FBAF40").cgColor
        yourViewBorder.lineDashPattern = [5, 6]
        yourViewBorder.frame = codeView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: codeView.bounds).cgPath
        codeView.layer.addSublayer(yourViewBorder)
    }
    
    @IBAction func copyClicked(_ sender: Any) {
        UIPasteboard.general.string = lblReferalCode.text
        //        let content = UIPasteboard.general.string
        Helper.ShowAlertMessage(message:"Referral code is copied to clipboard" , vc: self,title:"",bannerStyle: BannerStyle.info)
    }
    
    @IBAction func shareclicked(_ sender: Any) {
        
        //        let msg = "<p>Let's play MyExampleGame together! Use my <a href=\"\(invitationUrl)\">referrer link</a>!</p>"
        
        let items = ["\(strMessage) ReferLink: \(invitationUrl)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
    func createLink(){
        //        http://photographerondemand.in
        //        guard let uid = Auth.auth().currentUser?.uid else { return }
        let link = URL(string: "https://www.podahmedabad.com/?invitedby=\(AccountManager.instance().activeAccount?.referralCode ?? "")")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://poduser.page.link")
        
        
        referralLink!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.seawindsolution.PODUser")
        //        referralLink!.iOSParameters?.minimumAppVersion = "1.0.1"
        referralLink!.iOSParameters?.appStoreID = "1503321883"
        
        referralLink!.androidParameters = DynamicLinkAndroidParameters(packageName: "com.seawindsolution.pod")
        //        referralLink!.androidParameters?.minimumVersion = 125
        
        referralLink!.shorten { (shortURL, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print(shortURL!)
            self.invitationUrl = shortURL?.absoluteString ?? ""
        }
    }
    
    func getReferCode(){
        startAnimating()
        ApiManager.sharedInstance.requestGETURL("\(Constant.getReferCodeURL)\(account.user_id)", success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                self.stopAnimating()
                let ResponseData : [[String : Any]]  = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!
                
                self.strMessage = ResponseData[0]["Message"] as! String
                
                self.lblMessage.text = "Invite your friends to signup with your referral code and book their first order. Once done you have earned \(ResponseData[0]["Point"] as! String) points."
                
                let strTotalOrder : String = ResponseData[0]["TotalOrder"] as! String
                
                let totalOrder : Int = Int(strTotalOrder) ?? 0
                
                if(totalOrder > 0){
                    self.codeView.isHidden = false
                    self.btnShare.isHidden = false
                    self.referalCodeTitle.isHidden = false
                    self.myReferralView.isHidden = false
                    self.lblNoOrderMessage.isHidden = true
                } else {
                    self.codeView.isHidden = true
                    self.btnShare.isHidden = true
                    self.referalCodeTitle.isHidden = true
                    self.myReferralView.isHidden = true
                    self.lblNoOrderMessage.isHidden = false
                }
                
            } else{
                self.stopAnimating()
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }
    
    
    func GetCustomerProfile(userID:String, account : Account){
        ApiManager.sharedInstance.requestGETURL(Constant.getCustomerProfileURL+"/"+userID, success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                account.parseUserDict(userDict: JSON.dictionaryObject!["ResponseData"] as! NSDictionary, account: account)
                self.lblPoints.text = account.referralPoint
                self.lblReferalCode.text = account.referralCode
                self.getReferCode()
                
            } else{
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }
    
    
    @IBAction func myReferralClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyReferralsViewController") as! MyReferralsViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
