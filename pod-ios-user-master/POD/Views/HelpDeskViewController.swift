//
//  HelpDeskViewController.swift
//  POD
//
//  Created by Apple on 14/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HelpDeskViewController: UIViewController {
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblAbout:UILabel!
    @IBOutlet var lblAddress:UILabel!
    @IBOutlet var lblEmail:UILabel!
    @IBOutlet var lblPhone:UILabel!
    @IBOutlet var lblWebSite:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        HelpDeskController.Gethelpinfo(vc:self)
        // Do any additional setup after loading the view.
    }
    public func SetInfo(dic:[String:AnyObject]?)
    {
        if let name = dic!["Name"]{
            lblName.text = (name as! String);
        }
        if let about = dic!["About"]{
            lblAbout.text = (about as! String);
        }
        if let email = dic!["Email"]{
            lblEmail.text = (email as! String);
        }
        if let phone = dic!["Phone"]{
            lblPhone.text = (phone as! String);
        }
        if let Address = dic!["Address"]{
            lblAddress.text = (Address as! String);
        }
        if let website = dic!["Web"]{
            lblWebSite.text = (website as! String);
        }
    }
    
    @IBAction func btnContinue_Click(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
