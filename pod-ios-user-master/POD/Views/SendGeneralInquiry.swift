//
//  SendGeneralInquiry.swift
//  POD
//
//  Created by Apple on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SendGeneralInquiry: BaseViewController {

    @IBOutlet var txtMsg:UITextView!
    @IBOutlet var btnScreenshot:UIButton!
    var imagePicker: ImagePicker!
    var imgData:Data!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
           
           if (textView.text == "Enter Message") {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }
       
       public func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Enter Message"
               textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
           }
       }
    
    @IBAction func btnScreenSHot_Click(sender:UIButton){
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func btnSend_Click(){
        var QueryInfo : [String:Any] = [String:Any]()
              let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        
//                if let name = userInfo!["Name"]{
        QueryInfo["Name"] = account.name
//                }
//                if let Address = userInfo!["Address"]{
        QueryInfo["Email"] = account.email
//                }
//
//                if let email = userInfo?["Email"]{
        QueryInfo["Phone"]  = account.email
//                }
                QueryInfo["Message"]  = (txtMsg.text!)
                QueryInfo["Image"] = imgData
                HelpDeskController.SendGeneralInquiry(vc: self, dicObj: QueryInfo)
           
    }
    
}

extension SendGeneralInquiry: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        imgData = image!.jpegData(compressionQuality: 0.5)
    }
    
    func didGetFileName(filename: String?) {
        self.btnScreenshot.setTitle(filename, for: UIControl.State.normal)
    }
}
