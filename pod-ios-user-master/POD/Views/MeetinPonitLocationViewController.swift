//
//  MeetinPonitLocationViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class MeetinPonitLocationViewController: UIViewController {
    @IBOutlet var txtQuery:UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        InitializeKeyBoardNotificationObserver()
        txtQuery!.leftSpace()
    }
   
    @IBAction func btnContinue_Click(){
        if(txtQuery!.text!.count==0 || txtQuery!.text! == "Near By Address"){
            Helper.ShowAlertMessage(message: "Please enter near by address", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        Constant.OrderDic!["ShootingMeetPoint"] = txtQuery!.text as AnyObject;
       
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentDetailViewController") as! PaymentDetailViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
           
           if (textView.text == "Near By Address") {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }
       
       public func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Near By Address"
               textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
           }
       }
}
