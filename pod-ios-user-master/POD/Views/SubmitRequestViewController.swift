//
//  SubmitRequestViewController.swift
//  POD
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class SubmitRequestViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var txtDate:UITextField!
    @IBOutlet var txtSH:UITextField!
    @IBOutlet var txtEH:UITextField!
    @IBOutlet var txtQuery: UITextView!
    public var orderDetail:[String:AnyObject]?
    var issueInfo:[String:AnyObject]?
    var issuType:String?
     var pickerView = UIPickerView()
    var hours = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16.17,18,19,20,21,22,23,24]
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        InitializeKeyBoardNotificationObserver()
         self.txtDate.setInputViewDatePicker(target: self, selector: #selector(dateDone))
        self.txtEH.setDismissToolBar(target: self)
        self.txtSH.setInputViewTimePicker(target: self, selector: #selector(timeDone))
        pickerView.delegate = self
        pickerView.dataSource = self
        txtEH.inputView = pickerView
        self.txtEH.tintColor = UIColor.clear
        self.txtSH.tintColor = UIColor.clear
        self.txtDate.tintColor = UIColor.clear
        txtQuery.leftSpace()
    }
    //2
    @objc func dateDone() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd-MM-yyyy" // 2-3
            self.txtDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtDate.resignFirstResponder() // 2-5
    }
    
    @objc func timeDone() {
        if let datePicker = txtSH.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm" // 2-3
            txtSH!.text = dateformatter.string(from: datePicker.date) //2-4
        }
        txtSH.resignFirstResponder() // 2-5
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "Reason of reschedule") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Reason of reschedule"
            textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    @IBAction func btnSubmit(){
        if(txtQuery.text.count==0 || txtQuery.text == "Enter Date"){
            Helper.ShowAlertMessage(message: "Please  select date", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        if(txtSH.text!.count==0 || txtSH.text == "Start Time"){
            Helper.ShowAlertMessage(message: "Please  select start time", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        if(txtEH.text!.count==0 || txtEH.text == "Shooting hrs"){
            Helper.ShowAlertMessage(message: "Please  select shooting hours", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
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
        issueInfo!["ReScheduleDate"] = txtDate.text as AnyObject
        issueInfo!["ReScheduleStartTime"] = txtSH.text as AnyObject
        issueInfo!["ReScheduleEndTime"] = txtEH.text as AnyObject
        issueInfo!["Issue"] = txtQuery.text as AnyObject
        InqueryController.SubmitQuery(vc: self, orderInfo: issueInfo!)
    }
  
}

extension SubmitRequestViewController{

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}


func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return hours.count
}



func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Int(hours[row]).description
    
}


func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    txtEH.text = Int(hours[row]).description
}
}
