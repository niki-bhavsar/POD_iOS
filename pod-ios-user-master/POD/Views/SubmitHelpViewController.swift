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
    public var orderDetail = [String:Any]()
    var issueInfo  = [String:Any]()
    var issuType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
//        self.SetStatusBarColor()
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
        issueInfo = [String:Any]()
        
        let account = AccountManager.instance().activeAccount! //Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
//         if let name = userInfo!["Name"]{
        issueInfo["CustomerName"] = account.name
//         }
//         if let Id = userInfo!["Id"]{
        issueInfo["CustomerId"] = account.user_id
//         }
//         if let mobileNo = userInfo?["Phone"]{
        issueInfo["CustomerPhone"] = account.phone
//         }
//         if let email = userInfo?["Email"]{
        issueInfo["CustomerEmail"] = account.email
//         }
        issueInfo["OrderId"] = orderDetail["Id"]
        issueInfo["OrderNo"] = orderDetail["OrderNo"]
        issueInfo["OrderTitle"] = orderDetail["ProductTitle"]
        issueInfo["Type"] = issuType
        issueInfo["ReScheduleDate"] = ""
        issueInfo["ReScheduleStartTime"] = ""
        issueInfo["ReScheduleEndTime"] = ""
        issueInfo["Issue"] = txtQuery.text
        InqueryController.SubmitQuery(vc: self, orderInfo: issueInfo)
    }

}
