//
//  SIgnUpViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
import AuthenticationServices

class SIgnUpViewController: BaseViewController {
    
    @IBOutlet weak var txtRefferCode: SkyFloatingLabelTextField!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
    // @IBOutlet var txtAddress:SkyFloatingLabelTextField!
    // @IBOutlet var sv:UIScrollView!
    @IBOutlet var btnSubmit:UIButton!
    @IBOutlet var txtDOB:UITextField!
    @IBOutlet var btnMale:UIButton!
    @IBOutlet var btnFemale:UIButton!
    var imagePicker: ImagePicker!
    var isImageSelected:Bool = false
    var isFromAppleSignin = Bool()
    var strEmail = String()
    var strName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         KeychainItem.deleteUserIdentifierFromKeychain()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
//        self.SetStatusBarColor()
        txtPhoneNo.addDoneButtonOnKeyboard(view: self.view);
        self.txtDOB.setInputViewDatePicker(target: self, selector: #selector(dateDone),IsFutureDisable:true)
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
        profileImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(SIgnUpViewController.ShowImagePicker)))
        
        let text = lblTerms.text ?? ""
             let underlineAttriString = NSMutableAttributedString(string: text)
             let range1 = (text as NSString).range(of: "Terms & Condition")
             let range2 = (text as NSString).range(of: "Privacy Policy")
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
             
             underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range1)
             underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range2)
             lblTerms.attributedText = underlineAttriString
             lblTerms.isUserInteractionEnabled = true
             lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        if(isFromAppleSignin == true){
            if(strEmail.count > 0){
                txtEmail.text = strEmail
                txtEmail.isUserInteractionEnabled = false
            }
            
            if(strName.count > 0){
                txtfullName.text = strName
                txtfullName.isUserInteractionEnabled = false
            }
        }
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if gesture.didTapAttributedTextInLabel(label: lblTerms, targetText: "Terms & Condition") {
            print("Terms of service")
            let controller = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if gesture.didTapAttributedTextInLabel(label: lblTerms, targetText: "Privacy Policy") {
            print("Privacy policy")
            let controller = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            print("Tapped none")
        }
    }
    
    @IBAction func termsClicked(_ sender: UIButton) {
        if(btnTerms.isSelected == true){
            btnTerms.isSelected = false
        } else {
             btnTerms.isSelected = true
        }
    }
    
    @objc func ShowImagePicker(){
        self.imagePicker.present(from: profileImg)
    }
    
    @objc func dateDone() {
        if let datePicker = self.txtDOB.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "yyyy-MM-dd" // 2-3
            self.txtDOB.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtDOB.resignFirstResponder() // 2-5
    }
    
    @IBAction func btnSelectGender(sender:UIButton){
        self.btnMale.isSelected = false
        self.btnFemale.isSelected = false
        sender.isSelected = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnVerifyOTP(){
        if(txtfullName.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter fullname" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        } else if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter email" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }else if(txtEmail.text!.isEmail() == false){
            Helper.ShowAlertMessage(message:"Please enter valid email." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        } else if(txtPhoneNo.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter mobile no" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }  else if(!isImageSelected){
            Helper.ShowAlertMessage(message:"Please select profile image" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        } else if(btnTerms.isSelected == false){
            Helper.ShowAlertMessage(message:"Please agree Terms & Condition and Privacy Policy" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        var userInfo = [String : Any]()
        if(isImageSelected){
            userInfo["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5)
        }
        else{
            userInfo["ProfileImage"] = Data.init()
        }
        userInfo["ProfileImageUrl"] = ""
        userInfo["Name"] = txtfullName.text
        userInfo["Email"] = txtEmail.text
        userInfo["Phone"] = txtPhoneNo.text
        if(txtDOB.text?.count != 0){
            userInfo["DOB"] = txtDOB.text
        } else{
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "yyyy-MM-dd" // 2-3
            userInfo["DOB"] = dateformatter.string(from: Date.init())
        }
        //userInfo["Address"] = txtAddress.text as AnyObject
        if(btnMale.isSelected){
            userInfo["Gender"] = "Male"
        } else if(btnFemale.isSelected){
            userInfo["Gender"] = "Female"
        }
        
        userInfo["TermsCondition"] = "1"
        if((txtRefferCode.text?.trimmingCharacters(in: .whitespaces).count)! > 0){
            checkValidReferCode(userInfo:userInfo)
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SignUpOTPViewController") as! SignUpOTPViewController
            controller.userInfo = userInfo
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    func checkValidReferCode(userInfo : [String : Any]){
        startAnimating()
        ApiManager.sharedInstance.requestGETURL("\(Constant.getCheckValidReferCodeURL)\(txtRefferCode.text ?? "")", success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                self.stopAnimating()
                var dict : [String : Any] = userInfo
                dict["Referral_Code"] = self.txtRefferCode.text
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SignUpOTPViewController") as! SignUpOTPViewController
                controller.userInfo = dict
                self.navigationController!.pushViewController(controller, animated: true)
            } else{
                self.stopAnimating()
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }

    
}

extension SIgnUpViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImg.image = image
        isImageSelected = true
    }
}
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
