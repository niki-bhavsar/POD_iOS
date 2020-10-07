//
//  ProfileViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
import Kingfisher

class ProfileViewController: BaseViewController {
    
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
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
        txtPhoneNo.isUserInteractionEnabled = false

        LoginController.GetCustomerProfileForProfile(vc: self, userID: account.user_id, IsBack: false, account: account)
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
        sender.isSelected = true
    }
    
    func LoadProfileData(account : Account){
//        account.parseUserDict(userDict: userProfile as NSDictionary, account: account)
        txtfullName.text = account.name
        txtPhoneNo.text = account.phone
        if(txtPhoneNo.text?.count == 0) {
            txtPhoneNo.isUserInteractionEnabled = true
        }
        if(txtEmail.text?.count == 0){
            txtEmail.isUserInteractionEnabled = true
        }
        
        txtEmail.text = account.email
        txtDOB.text = account.dob
        
        btnMale.isSelected = false
        btnFemale.isSelected = false
        
        if(account.gender == "Male"){
            btnMale.isSelected = true
        } else if(account.gender == "Female"){
            btnFemale.isSelected = true
        }
        
        
        if let url  = URL(string: account.profileImage) {
                 profileImg.kf.indicatorType = .activity
                 
                 profileImg.kf.setImage(
                     with: url,
                     placeholder: UIImage.init(named: "user"),
                     options: nil)
                 profileImg.layer.cornerRadius = profileImg.frame.width / 2
             }
        profileImg.clipsToBounds = true
    }
    
    @IBAction func btnUpdate_Click(){
        if(txtfullName.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter full name." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        } else if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter email." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        } else if(txtPhoneNo.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter mobile no." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        } else if(txtDOB.text?.count == 0 || txtDOB.text == "0000-00-00"){
            Helper.ShowAlertMessage(message:"Please select Date of Birth" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        }
        
        txtfullName.resignFirstResponder()
        txtPhoneNo.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtDOB.resignFirstResponder()
    
        var otpDic = [String:Any]()
        
        
        otpDic["Id"] = account.user_id
        
        otpDic["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5) 
        otpDic["Name"] = txtfullName.text
        otpDic["Address"] = Date.init()
        if(account.phone.count == 0){
            otpDic["Phone"] = txtPhoneNo.text
        }
      
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
