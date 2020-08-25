//
//  TermsAndConditionViewController.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: UIViewController {
    @IBOutlet var txtView:UITextView!
    @IBOutlet var btnFAQ:UIButton!
    var isFAQ:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
         btnFAQ.isHidden = true
        if(isFAQ == true){
            btnFAQ.isHidden = false
        }
        InfoController.GetInfo(vc: self, txt: txtView, Slug: "term-and-condition")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFAQ(sender:UIButton){
        let controller = storyboard!.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
