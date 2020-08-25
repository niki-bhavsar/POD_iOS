//
//  InqueryDetailSubmitViewConroller.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
class InqueryDetailSubmitViewConroller : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet var txtState:UITextField!
    @IBOutlet public var txtCity:UITextField!
    @IBOutlet public var txtLocation:UITextField!
    @IBOutlet var txtMedia:UITextField!
    @IBOutlet var txtQuery:UITextView!
    @IBOutlet var lblHours:UILabel!
    var temptxt:UITextField?;
    var pickerView = UIPickerView()
    public var infoPopup:InquiryDetailInfoPopupViewcontroller!
    var selectedCityIndex:Int = 0
    var selectedLocationIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        InitializeKeyBoardNotificationObserver()
        InquirySubDetailController.SetList()
        pickerView.delegate = self
        pickerView.dataSource = self
        txtCity.inputView = pickerView
        txtState.inputView = pickerView
        txtMedia.inputView = pickerView
        txtLocation.inputView = pickerView
        txtCity.setDismissToolBar(target: self)
        txtState.setDismissToolBar(target: self)
        txtMedia.setDismissToolBar(target: self)
        txtLocation.setDismissToolBar(target: self)
        txtQuery.leftSpace()
        self.txtState.tintColor = UIColor.clear
        self.txtCity.tintColor = UIColor.clear
        self.txtLocation.tintColor = UIColor.clear
        self.txtMedia.tintColor = UIColor.clear
        self.pickerView.selectRow(1, inComponent:0, animated:true)
        if let hours = Constant.OrderDic!["ShootingHours"]{
            lblHours.text = "Shooting duration is :      \(hours)"
            lblHours.halfTextColorChange(fullText: lblHours.text!, changeText: hours as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        txtState.text = InquirySubDetailController.listState![0] as String
        //txtCity.text = InquirySubDetailController.listCity![0] as String
        //txtLocation.text = InquirySubDetailController.listLocation![0] as String
        txtMedia.text = InquirySubDetailController.listMedia![0] as String
        InqueryController.GetCity(vc: self);
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (infoPopup != nil){
            self.present(infoPopup!, animated: true, completion: nil)
        }
    }
    
   
    @IBAction func btnBookNow_Click(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingAddressViewController") as! BookingAddressViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btnSubmit_Click(){
        Constant.InquiryDic!["City"] = txtCity.text as AnyObject;
        Constant.InquiryDic!["Source"] = txtMedia.text as AnyObject;
        Constant.InquiryDic!["Message"] = txtQuery.text as AnyObject;
        Constant.InquiryDic!["State"] = txtState.text as AnyObject;
        Constant.InquiryDic!["Area"] = txtLocation.text as AnyObject;
        Constant.InquiryDic!["Country"] = "India" as AnyObject;
        if(txtQuery.text!.count==0){
            Helper.ShowAlertMessage(message: "Please enter instruction.", vc: self,title:"Required",bannerStyle: BannerStyle.warning);
            return;
        }
        InqueryController.SubmitInquiryy(vc: self, orderInfo: Constant.InquiryDic!)
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        temptxt = textField
        pickerView.reloadAllComponents()
        textField.resignFirstResponder()
        if(textField == txtCity){
            pickerView.selectRow(selectedCityIndex, inComponent: 0, animated: true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "Special Instruction") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Special Instruction"
            textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
        }
    }
    
    
    
}

extension InqueryDetailSubmitViewConroller{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(temptxt == txtState){
            return InquirySubDetailController.listState!.count
        }
        else if(temptxt == txtCity){
            if(InqueryController.listCity != nil){
                return InqueryController.listCity!.count
            }
            else{
                return 0
            }
            //return InquirySubDetailController.listCity!.count
        }
        else if(temptxt == txtLocation){
            if(InqueryController.listLocations != nil){
                return InqueryController.listLocations!.count
            }
            else{
                return 0
            }
            //return InquirySubDetailController.listLocation!.count
        }
        else if(temptxt == txtMedia){
            return InquirySubDetailController.listMedia!.count
        }
        
        return 0
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(temptxt == txtState){
            return InquirySubDetailController.listState![row].description
        }
        else if(temptxt == txtCity){
            let obj = InqueryController.listCity![row];
            return (obj["name"] as! String)
            
            //return InquirySubDetailController.listCity![row].description
        }
        else if(temptxt == txtLocation){
            let obj = InqueryController.listLocations![row];
            return (obj["name"] as! String)
            
            //return InquirySubDetailController.listLocation![row].description
        }
        else if(temptxt == txtMedia){
            return InquirySubDetailController.listMedia![row].description
        }
        
        return "Select"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if(temptxt == txtState){
        txtState.text = InquirySubDetailController.listState![row].description
       }
       else if(temptxt == txtCity){
        let obj = InqueryController.listCity![row];
        txtCity.text = (obj["name"] as! String)
        InqueryController.GetLocation(cityID: obj["id"] as! String, vc: self)
        self.selectedCityIndex = row;
        //txtCity.text = InquirySubDetailController.listCity![row].description
       }
       else if(temptxt == txtLocation){
        let obj = InqueryController.listLocations![row];
        txtLocation.text = (obj["name"] as! String)
        //txtLocation.text = InquirySubDetailController.listLocation![row].description
       }
       else if(temptxt == txtMedia){
           txtMedia.text = InquirySubDetailController.listMedia![row].description
       }
    }
}

