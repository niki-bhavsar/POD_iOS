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
    func applyClicked(code : String)
    func cancleClicked()
}

class ReferCodePopup: BaseViewController {

    @IBOutlet weak var txtRefercode: UITextField!
     var delegate:ReferCodePopupDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func cancleClicked(_ sender: Any) {
          if(self.delegate != nil){
                          self.dismiss(animated: true) {
                              self.delegate.cancleClicked()
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
                        self.delegate.applyClicked(code: self.txtRefercode.text ?? "")
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
