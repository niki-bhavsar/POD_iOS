//
//  InqueryDetailViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
class InqueryDetailViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblemail:UILabel!
//    @IBOutlet var lblPriceInfo:UILabel!
    @IBOutlet var txtContact:SkyFloatingLabelTextField!
    @IBOutlet var txtDate:UITextField!
    @IBOutlet var txtSH:UITextField!
    @IBOutlet var txtEH:UITextField!
//    @IBOutlet var txtDOB:UITextField!
    @IBOutlet var lblHeaderTitle:UILabel!
    @IBOutlet var txtNoOfPeople:UITextField!
    
    var temptxt:UITextField?
    var pickerView = UIPickerView()
    var hours = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16.17,18,19,20,21,22,23,24]
    var selectedStartTimeInq:Date!
     var Multiplier:String?
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        InitializeKeyBoardNotificationObserver()
        
        txtContact.addDoneButtonOnKeyboard(view: self.view)
        
        txtNoOfPeople.addDoneButtonOnKeyboard(view: self.view)
        
        self.txtDate.setInputViewDatePicker(target: self, selector: #selector(dateDone),IsPreviousDisable:true)
        
            self.txtSH.setInputViewTimePicker(target: self, selector: #selector(timeDone), IsFutureDisable: true, selectedDate: selectedDate)
        
          self.txtEH.setInputViewTimePicker(target: self, selector: #selector(hoursDone), IsFutureDisable: false, selectedDate: Date())
        
        
//        self.txtDOB.setInputViewDatePicker(target: self, selector: #selector(dobDateDone),IsFutureDisable:true)

        
        pickerView.delegate = self
        pickerView.dataSource = self
        txtEH.inputView = pickerView
//        self.txtDOB.tintColor = UIColor.clear
        self.txtDate.tintColor = UIColor.clear
        self.txtEH.tintColor = UIColor.clear
        self.txtSH.tintColor = UIColor.clear
        // Do any additional setup after loading the view.
        
        self.SetInfo()
    }
    
    func SetInfo(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        if let name = userInfo!["Name"]{
            lblName.text = (name as! String);
            Constant.InquiryDic["Name"] = name
        }
        
        if let email = userInfo?["Email"]{
            lblemail.text = (email as! String);
            Constant.InquiryDic["Email"] = email
        }
        
        if let mobileNo = userInfo?["Phone"]{
            txtContact.text = (mobileNo as! String);
        }
        
        if let id = userInfo!["Id"]{
            Constant.InquiryDic["CustomerId"] = id
        }
        //Constant.InquiryDic!["TypeOfShoot"] = "OutDoor" as AnyObject;
        Constant.OrderDic["ProductId"] = Constant.FirstSubcategoryId
        Constant.OrderDic["ProductIds"] = Constant.AllSubcategoryId
    }
    
    @objc func dateDone() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd-MM-yyyy" // 2-3
            self.txtDate.text = dateformatter.string(from: datePicker.date) //2-4
            selectedDate = datePicker.date
            self.txtSH.text = ""
            self.txtSH.setInputViewTimePicker(target: self, selector: #selector(timeDone), IsFutureDisable: true, selectedDate: selectedDate)
        }
        self.txtDate.resignFirstResponder() // 2-5
    }
    
    @objc func hoursDone() {
           if let picker = txtEH!.inputView as? UIPickerView { // 2-1
               let selectedvalue = hours[picker.selectedRow(inComponent: 0)];
               txtEH.text = Int(selectedvalue).description;
           }
            if(selectedStartTimeInq != nil){
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateFormat = "HH:mm"
                let minutes = Int(txtEH.text!)!*60*60
                let endTime = dateformatter.string(from:(selectedStartTimeInq!.addingTimeInterval(TimeInterval(minutes))))
            Constant.InquiryDic["EndTime"] = endTime
                Constant.OrderDic["ShootingEndTime"] = endTime
            }
           txtEH!.resignFirstResponder() // 2-5
       }
    
//    @objc func dobDateDone() {
//           if let datePicker = self.txtDOB.inputView as? UIDatePicker { // 2-1
//               let dateformatter = DateFormatter() // 2-2
//               dateformatter.dateFormat = "dd-MM-yyyy" // 2-3
//               self.txtDOB.text = dateformatter.string(from: datePicker.date) //2-4
//           }
//           self.txtDOB.resignFirstResponder() // 2-5
//       }
    
    @objc func timeDone() {
        if let datePicker = txtSH!.inputView as? UIDatePicker { // 2-1
            selectedStartTimeInq = datePicker.date
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm" // 2-3
            txtSH!.text =  dateformatter.string(from: datePicker.date) //2-4
            if(txtEH.text!.count != 0){
                let minutes = Int(txtEH.text!)!*60*60
                let endTime = dateformatter.string(from:(selectedStartTimeInq!.addingTimeInterval(TimeInterval(minutes))))
                Constant.InquiryDic["EndTime"] = endTime
                 Constant.OrderDic["ShootingEndTime"] = endTime
            }
        }
        
        txtSH!.resignFirstResponder() // 2-5
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        temptxt = textField
        return true
    }
    
    @IBAction func btnContinue_Click(){
        if(txtContact.text!.count==0){
            Helper.ShowAlertMessage(message: "Please enter contact no.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        if(txtDate.text!.count==0){
            Helper.ShowAlertMessage(message: "Please select starting date.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        if(txtSH.text!.count==0){
            Helper.ShowAlertMessage(message: "Please select start time.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        if(txtEH.text!.count==0){
            Helper.ShowAlertMessage(message: "Please select  hours.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
//        if(txtDOB.text!.count==0){
//            Helper.ShowAlertMessage(message: "Please select  Date of Birth.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
//            return;
//        }
        
        if(txtNoOfPeople.text!.count==0){
            Helper.ShowAlertMessage(message: "Please enter No of people.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        
        if(txtNoOfPeople.text == "0"){
            Helper.ShowAlertMessage(message: "No of people should not be 0.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        
        let nop =  Int(txtEH.text!)
        if((Int(Multiplier!)! > nop!)){
            Helper.ShowAlertMessage(message: "Selected hours should not be less than \(Multiplier ?? "0")", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        
        Constant.InquiryDic["Phone"] = txtContact.text
        Constant.InquiryDic["DateOfShoot"] = txtDate.text
        Constant.InquiryDic["StartTime"] = txtSH.text
        //Constant.InquiryDic!["DOB"] = txtDOB.text as AnyObject;
        Constant.InquiryDic["ShootingHours"] = txtEH.text
        Constant.InquiryDic["NoOfPeople"] = txtNoOfPeople.text 
        
        Constant.OrderDic["Phone1"] = txtContact.text
        Constant.OrderDic["ShootingDate"] = txtDate.text
        Constant.OrderDic["ShootingStartTime"] = txtSH.text
        Constant.OrderDic["ShootingHours"] = txtEH.text
        Constant.OrderDic["NoOfPeople"] = txtNoOfPeople.text
        
        
//        @Part("CustomerId") RequestBody CustomerId,
//        @Part("Name") RequestBody Name,
//        @Part("Email") RequestBody Email,
//        @Part("Phone") RequestBody Phone,
//        @Part("TypeOfShoot") RequestBody TypeOfShoot,
//        @Part("DateOfShoot") RequestBody DateOfShoot,
//        @Part("StartTime") RequestBody StartTime,
//        @Part("EndTime") RequestBody EndTime,
//        @Part("ShootingHours") RequestBody ShootingHours,
//        @Part("ProductTitles") RequestBody ProductTitles,
//        @Part("ProductIds") RequestBody ProductIds,
//        @Part("Area") RequestBody Area,
//        @Part("City") RequestBody City,
//        @Part("State") RequestBody State,
//        @Part("Country") RequestBody Country,
//        @Part("Message") RequestBody Message,
//        @Part("Source") RequestBody Source,
//        @Part("ShootingAmount") RequestBody ShootingAmount
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InqueryDetailSubmitViewConroller") as! InqueryDetailSubmitViewConroller
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField != txtContact && textField != txtNoOfPeople ){
           return false
        }
        else{
            return true
        }
        
       }
}


extension InqueryDetailViewController{
    
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
        //txtEH.text = Int(hours[row]).description
//        if(selectedStartTimeInq != nil){
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateFormat = "HH:mm"
//            let minutes = Int(txtEH.text!)!*60*60
//            let endTime = dateformatter.string(from:(selectedStartTimeInq!.addingTimeInterval(TimeInterval(minutes))))
//        Constant.InquiryDic!["EndTime"] = endTime as AnyObject;
//            Constant.OrderDic!["ShootingEndTime"] = endTime as AnyObject
//        }
    }
}
