//
//  ReferCodePopup.swift
//  POD
//
//  Created by Apple on 14/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol ReferCodePopupDelegate{
    func applyClicked(code : String, userID : String)
    func cancleClicked(userID : String)
}

class ReferCodePopup: BaseViewController {

    @IBOutlet weak var txtRefercode: UITextField!
     var delegate:ReferCodePopupDelegate!
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegateShared = UIApplication.shared.delegate as? AppDelegate
        if(UserDefaults.standard.object(forKey: "UserReferralCode") != nil){
            txtRefercode.text = UserDefaults.standard.string(forKey: "UserReferralCode")!
        } else{
            txtRefercode.text = appDelegateShared?.userCode
        }
    }

    @IBAction func cancleClicked(_ sender: Any) {
          if(self.delegate != nil){
                          self.dismiss(animated: true) {
                            self.delegate.cancleClicked(userID: self.userId)
                          }
                      }
    }
    
    @IBAction func applyclicked(_ sender: Any) {
        if((txtRefercode.text?.trimmingCharacters(in: .whitespaces).count)! <= 0){
            Helper.ShowAlertMessage(message:"Please enter code" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        checkValidREferCode()
    }
    
    func checkValidREferCode(){
        startAnimating()
        ApiManager.sharedInstance.requestGETURL("\(Constant.getCheckValidReferCodeURL)\(txtRefercode.text ?? "")", success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                self.stopAnimating()
                if(self.delegate != nil){
                    self.dismiss(animated: true) {
                        self.delegate.applyClicked(code: self.txtRefercode.text ?? "", userID: self.userId)
                    }
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

}
