//
//  SubmitHelpViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class SubmitHelpViewController: BaseViewController {
    
    @IBOutlet var txtQuery: UITextView!
    public var orderDetail:[String:AnyObject]?
    var issueInfo:[String:AnyObject]?
    var issuType:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.SetStatusBarColor()
        txtQuery.leftSpace()
        
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
           
           if (textView.text == "Your Query") {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }
       
       public func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Your Query"
               textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
           }
       }
    
    @IBAction func btnSubmit(){
        if(txtQuery.text.count==0 || txtQuery.text == "Your Query"){
            Helper.ShowAlertMessage(message: "Please enter query", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        issueInfo = [String:AnyObject]();
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
         if let name = userInfo!["Name"]{
            issueInfo!["CustomerName"] = name as AnyObject
         }
         if let Id = userInfo!["Id"]{
             issueInfo!["CustomerId"] = Id as AnyObject
         }
         if let mobileNo = userInfo?["Phone"]{
             issueInfo!["CustomerPhone"] = mobileNo as AnyObject
         }
         if let email = userInfo?["Email"]{
             issueInfo!["CustomerEmail"] = email as AnyObject
         }
        issueInfo!["OrderId"] = orderDetail!["Id"] as AnyObject
        issueInfo!["OrderNo"] = orderDetail!["OrderNo"] as AnyObject
        issueInfo!["OrderTitle"] = orderDetail!["ProductTitle"] as AnyObject
        issueInfo!["Type"] = issuType as AnyObject
        issueInfo!["ReScheduleDate"] = "" as AnyObject
        issueInfo!["ReScheduleStartTime"] = "" as AnyObject
        issueInfo!["ReScheduleEndTime"] = "" as AnyObject
        issueInfo!["Issue"] = txtQuery.text as AnyObject
        InqueryController.SubmitQuery(vc: self, orderInfo: issueInfo!)
    }

}
