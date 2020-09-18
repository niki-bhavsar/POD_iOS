//
//  HelpViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


class HelpViewController: BaseViewController {

    public var orderDetail = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.SetStatusBarColor()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmit_CLick(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "SubmitHelpViewController") as! SubmitHelpViewController
        controller.issuType = sender.tag.description
        controller.orderDetail = self.orderDetail
        Helper.rootNavigation?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnReschedule_CLick(sender:UIButton){
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  let controller = storyboard.instantiateViewController(withIdentifier: "SubmitRequestViewController") as! SubmitRequestViewController
        controller.issuType = sender.tag.description
        controller.orderDetail = self.orderDetail
                  Helper.rootNavigation?.pushViewController(controller, animated: true)
       }
    
}
