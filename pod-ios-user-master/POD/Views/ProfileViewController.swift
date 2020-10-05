//
//  ProfileViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import  NotificationBannerSwift
class ProfileViewController: BaseViewController {
    
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
//    @IBOutlet var txtAddress:SkyFloatingLabelTextField!
//    @IBOutlet var sv:UIScrollView!
    @IBOutlet var btnSubmit:UIButton!
    @IBOutlet var activityInd:UIActivityIndicatorView!
    @IBOutlet var txtDOB:UITextField!
    @IBOutlet var btnMale:UIButton!
    @IBOutlet var btnFemale:UIButton!
    var imagePicker: ImagePicker!
    var imgData:Data!
    
    let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
        self.txtDOB.setInputViewDatePicker(target: self, selector: #selector(dateDone),IsFutureDisable:true)
//        self.SetStatusBarColor()
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
        profileImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ProfileViewController.ShowImagePicker)))
//        sv.contentSize = CGSize.init(width: 0, height: btnSubmit.frame.origin.y+btnSubmit.frame.size.height)
        
        txtEmail.isUserInteractionEnabled = false
        txtPhoneNo.isUserInteractionEnabled = false;
        btnSubmit.isEnabled = false
        self.btnMale.isSelected = true;
//        let Id = account.user_id
        LoginController.GetCustomerProfileForProfile(vc: self, userID: account.user_id, IsBack: false, account: account)
        
        
        //self.LoadProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func dateDone() {
        if let datePicker = self.txtDOB.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "yyyy-MM-dd" // 2-3
            self.txtDOB.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtDOB.resignFirstResponder() // 2-5
    }
    
    @objc func ShowImagePicker(){
        self.imagePicker.present(from: profileImg)
    }
    
    @IBAction func btnSelectGender(sender:UIButton){
        self.btnMale.isSelected = false;
        self.btnFemale.isSelected = false;
        sender.isSelected = true;
    }
    
    func LoadProfileData(account : Account){
//        account.parseUserDict(userDict: userProfile as NSDictionary, account: account)
        txtfullName.text = account.name
        txtPhoneNo.text = account.phone
        if(txtPhoneNo.text?.count == 0) {
            txtPhoneNo.isUserInteractionEnabled = true
        }
        
        txtEmail.text = account.email
        txtDOB.text = account.dob
        btnMale.isSelected = false
                   btnFemale.isSelected = false
        
        if(account.gender == "Male"){
            btnMale.isSelected = true
        } else{
            btnFemale.isSelected = true
        }
        
        
//        if let name = userProfile["Name"]{
//            txtfullName.text = (name as! String);
//        }
////        if let Address = userProfile["Address"]{
////            txtAddress.text = (Address as! String);
////        }
//        if let mobileNo = userProfile["Phone"]{
//            txtPhoneNo.text = (mobileNo as! String);
//            if(txtPhoneNo.text?.count == 0)
//            {
//                txtPhoneNo.isUserInteractionEnabled = true;
//            }
//        }
//        if let email = userProfile["Email"]{
//            txtEmail.text = (email as! String);
//        }
//
//        if let dob = userProfile["DOB"]{
//            txtDOB.text = (dob as! String);
//        }
//
//        if let gender = userProfile["Gender"]{
//            btnMale.isSelected = false
//            btnFemale.isSelected = false;
//            if((gender as! String) == "Male"){
//                btnMale.isSelected = true
//            }
//            else{
//                btnFemale.isSelected = true
//            }
//        }
        
        if (account.profileImage != nil || account.profileImage != "") {
            self.activityInd.isHidden = false;
            self.activityInd.startAnimating()
            let imageUrl:NSURL = NSURL(string:  account.profileImage)!
            if(imageUrl.absoluteString?.count != 0){
                DispatchQueue.global(qos: .default).async {
                    if(imageUrl != nil){
                        let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData as Data)
                            self.profileImg.image = image
                            self.profileImg.contentMode = UIView.ContentMode.scaleAspectFit
                            self.activityInd.stopAnimating()
                            self.activityInd.isHidden = true;
                            self.btnSubmit.isEnabled = true
                        }
                    }
                }
            } else{
                self.activityInd.stopAnimating()
                self.activityInd.isHidden = true;
                btnSubmit.isEnabled = true
            }
        }else{
            self.activityInd.stopAnimating()
            self.activityInd.isHidden = true;
            btnSubmit.isEnabled = true
        }
    }
    
    @IBAction func btnUpdate_Click(){
        if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter email." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
//        else if(txtAddress.text?.count == 0){
//            Helper.ShowAlertMessage(message:"Please enter address." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
//            return;
//        }
        else if(txtPhoneNo.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter phone no." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtDOB.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please select Date of Birth" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtfullName.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter full name." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        txtfullName.resignFirstResponder()
        txtPhoneNo.resignFirstResponder()
//        txtAddress.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtDOB.resignFirstResponder()
        
//        let account = AccountManager.instance().activeAccount!
//        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        
        var otpDic = [String:Any]()
        
      
        otpDic["Id"] = account.user_id
        
        otpDic["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5) 
        otpDic["Name"] = txtfullName.text
        otpDic["Address"] = Date.init()
        otpDic["Phone"] = txtPhoneNo.text
        if(btnMale.isSelected){
            otpDic["Gender"] = "Male"
        } else {
            otpDic["Gender"] = "Female"
        }
        otpDic["DOB"] = txtDOB.text
          otpDic["TermsCondition"] = "1"
        LoginController.UpdateUserProfile(vc: self, dicObj: otpDic, account: account)
    }
    
}
extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImg.image = image
    }
}
