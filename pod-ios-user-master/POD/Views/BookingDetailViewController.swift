//
//  BookingDetailViewController.swift
//  POD
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift

class BookingDetailViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblemail:UILabel!
    @IBOutlet var lblPriceInfo:UILabel!
    @IBOutlet var txtContact:SkyFloatingLabelTextField!
    @IBOutlet var txtDate:UITextField!
    @IBOutlet var txtSH:UITextField!
    @IBOutlet var txtEH:UITextField!
    @IBOutlet var lblHeaderTitle:UILabel!
    @IBOutlet var txtNoOfPeople:UITextField!
    
    var selectedStartTime:Date?
    var temptxt:UITextField?
    var pickerView = UIPickerView()
    var hours = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16.17,18,19,20,21,22,23,24]
    var bookingInfo = [String:Any]()
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
        
        //self.txtEH.setDismissToolBar(target: self)
        
        self.txtEH.setInputViewTimePicker(target: self, selector: #selector(hoursDone), IsFutureDisable: true, selectedDate: Date())
        
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        txtEH.inputView = pickerView
        
        self.txtDate.tintColor = UIColor.clear
        self.txtSH.tintColor = UIColor.clear
        self.txtEH.tintColor = UIColor.clear
        self.SetInfo()
    }
    
    func SetInfo(){
        let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
//        if let name = userInfo!["Name"]{
        lblName.text = account.name
//        }
//
//        if let email = userInfo?["Email"]{
        lblemail.text = account.email
//        }
//
//        if let mobileNo = userInfo?["Phone"]{
        txtContact.text = account.phone
//        }
        
        if(Constant.SelectedCategory != nil){
            lblPriceInfo.text =  "Hourly price for "+(Constant.AllSubcategory )+" session is ₹ "+(Constant.SelectedCategory["Price"] as! String)+" Price"
            
            lblPriceInfo.halfTextColorChange(fullText: lblPriceInfo.text!, changeText:[(Constant.AllSubcategory ),(Constant.SelectedCategory["Price"] as! String)], color:  UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
        } else{
            lblPriceInfo.text =  "Hourly price for N/A session is ₹N/A Price"
        }
        
//        let readmoreFont = UIFont(name: "Avenir Next Medium", size: 14.0)
//        let readmoreFontColor = UIColor.blue
//        DispatchQueue.main.async {
//           // self.lblPriceInfo.addTrailing(with: "... ", moreText: "Learnmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
//        }
        if let categoryId = Constant.SelectedCategory["Id"] {
            Constant.OrderDic["ProductId"] = (categoryId as! String) as AnyObject;
        }
        
        //Constant.OrderDic!["ProductId"] = Constant.FirstSubcategoryId as AnyObject;
        Constant.OrderDic["ProductIds"] = Constant.AllSubcategoryId
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(BookingDetailViewController.showTC))
        tapGesture.numberOfTapsRequired = 1;
        lblPriceInfo.addGestureRecognizer(tapGesture)
    }
    
    @objc func showTC(){
    let controller = storyboard!.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
     controller.isFAQ = true; self.navigationController?.pushViewController(controller, animated: true)
        
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
    
    @objc func timeDone() {
        if let datePicker = txtSH!.inputView as? UIDatePicker { // 2-1
            print(datePicker.date)
            selectedStartTime = datePicker.date
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm" // 2-3
            txtSH!.text = dateformatter.string(from: datePicker.date)
            
            if(txtEH.text!.count != 0){
                let minutes = Int(txtEH.text!)!*60*60
                let endTime = dateformatter.string(from:(selectedStartTime!.addingTimeInterval(TimeInterval(minutes))))
                Constant.OrderDic["ShootingEndTime"] = endTime
            }
        }
        txtSH!.resignFirstResponder() // 2-5
    }
    
    @objc func hoursDone() {
        if let picker = txtEH!.inputView as? UIPickerView { // 2-1
            let selectedvalue = hours[picker.selectedRow(inComponent: 0)];
            txtEH.text = Int(selectedvalue).description;
        }
        if(selectedStartTime != nil){
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "HH:mm"
            let minutes = Int(txtEH.text!)!*60*60
            let endTime = dateformatter.string(from:(selectedStartTime!.addingTimeInterval(TimeInterval(minutes))))
            Constant.OrderDic["ShootingEndTime"] = endTime
        }
        txtEH!.resignFirstResponder() // 2-5
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        temptxt = textField
        pickerView.reloadAllComponents()
        if(textField != txtContact){
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField != txtContact && textField != txtNoOfPeople ){
            return false
         }
         else{
             return true
         }
    }
    
    @IBAction func btnShowInfo(){
        if let content = Constant.SelectedCategory["Content"]{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "InfoPopupViewController") as! InfoPopupViewController
            controller.desc = (content as! String)
             self.navigationController?.pushViewController(controller, animated: true)
//            controller.modalPresentationStyle = .overCurrentContext
//            controller.modalTransitionStyle = .crossDissolve
//            present(controller, animated: true, completion: nil)
        }
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
        if(txtNoOfPeople.text!.count == 0){
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        Constant.OrderDic["Phone1"] = txtContact.text
        Constant.OrderDic["ShootingDate"] = txtDate.text
        Constant.OrderDic["ShootingStartTime"] = txtSH.text
        Constant.OrderDic["ShootingHours"] = txtEH.text
        Constant.OrderDic["NoOfPeople"] = txtNoOfPeople.text 
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingAddressViewController") as! BookingAddressViewController;
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BookingDetailViewController{
    
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
//        if(selectedStartTime != nil){
//            let dateformatter = DateFormatter() // 2-2
//            dateformatter.dateFormat = "HH:mm"
//            let minutes = Int(txtEH.text!)!*60*60
//            let endTime = dateformatter.string(from:(selectedStartTime!.addingTimeInterval(TimeInterval(minutes))))
//        Constant.OrderDic!["ShootingEndTime"] = endTime as AnyObject;
//        }
    }
}
