//
//  AdminChatViewController.swift
//  POD
//
//  Created by Apple on 07/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class AdminChatViewController: BaseViewController {

   @IBOutlet var tblChat:UITableView!
        @IBOutlet var txtChatMsg:UITextField!
        public var dicObj:[String:AnyObject]!
        public let refreshControl = UIRefreshControl()
    
       let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
       
    override func viewDidLoad() {
            super.viewDidLoad()
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
            self.KeyBoardNotificationObserver()
            self.tblChat.estimatedRowHeight = 60;
            self.tblChat.rowHeight = UITableView.automaticDimension
//            if let Id = userInfo!["Id"]{
        ChatController.GetAdminChatMessage(vc: self, senderID: account.user_id, receiverID: "1")
//            }
            if #available(iOS 10.0, *) {
                tblChat.refreshControl = refreshControl
            } else {
                tblChat.addSubview(refreshControl)
            }
             refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
            // Do any additional setup after loading the view.
        }
        
        @objc private func refreshOrderData(_ sender: Any) {
//           if let Id = userInfo!["Id"]{
                  ChatController.GetAdminChatMessage(vc: self, senderID: account.user_id, receiverID: "1")
//            }
        }
        
        @IBAction func btnBack(sender:UIButton){
            let callOKActionHandler = { () -> Void in
                var dic = [String:Any]()
                dic["uType"] = "c"
                dic["isLiveChat"] = false
                dic["isActiveChat"] = false
                dic["Sender"] = self.account.user_id
                dic["Receiver"] = "1"
                dic["Message"] = "Offline"
                ChatController.SendAdminMessage(vc: self, dicObj: dic)
                self.navigationController?.popViewController(animated: true)
           
            }
            let callCancelActionHandler = { () -> Void in
                                                                           
            }
            Helper.ShowAlertMessageWithHandlesr(message: "Drop your message we will response you and notify soon thanks.", buttonTitle: "OK", title: "Are you sure do you want to go back?", vc: self, actionOK: callOKActionHandler, actionCancel: callCancelActionHandler)
       }
        
    @IBAction func btnSend(sender:UIButton){
        if(txtChatMsg.text!.count == 0){
            Helper.ShowAlertMessage(message:"Please enter message" , buttonTitle: "OK", vc: self, title: "Required", bannerStyle: .warning)
            return;
        }
        var dic = [String:Any]();
        dic["uType"] = "c"
        dic["isLiveChat"] = true
        dic["isActiveChat"] = true
        dic["Sender"] = account.user_id
        dic["Receiver"] = "1"
        dic["Message"] = txtChatMsg.text
        ChatController.SendAdminMessage(vc: self, dicObj: dic)
        txtChatMsg.text = ""
        
    }
        
        func KeyBoardNotificationObserver(){
            NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        @objc func KeyboardWillShow(notification: NSNotification) {
            guard let userInfo = notification.userInfo else {return}
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardFrame.height)
            }
        }
        @objc func KeyboardWillHide(notification: NSNotification) {
            guard let userInfo = notification.userInfo else {return}
             guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            _ = keyboardSize.cgRectValue
            if self.view.frame.origin.y != 0 && self.view.frame.origin.y < 0{
                self.view.frame.origin.y = 0
            }
        }
    }

    extension AdminChatViewController:UITableViewDelegate,UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             if( ChatController.listAdminChat != nil){
                 if( ChatController.listAdminChat!.count>0){
                     tableView.restore()
                 }else{
                     tableView.setEmptyMessage("No Message Found")
                }
                 return  ChatController.listAdminChat!.count
             }
             else{
                 tableView.setEmptyMessage("No Message Found")
                 return 0;
             }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell:UITableViewCell?
            
            let dic =  ChatController.listAdminChat![indexPath.row] as! [String:AnyObject]
            
            if((dic["uType"] as! String) != "c"){
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftCell", for: indexPath) as! ChatLeftCell
                (cell as! ChatLeftCell).SetData(dic: dic,title: "POD")
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
                (cell as! ChatRightCell).SetData(dic: dic)
            }
            return (cell ?? nil)!;
        }
    }
