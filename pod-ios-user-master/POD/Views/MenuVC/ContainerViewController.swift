//
//  ContainerVC.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

   @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    var visiblewidth:Int! = 60;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuConstraint.constant = -(self.view.frame.size.width-((self.view.frame.size.width*25)/100))
        sideMenuWidthConstraint.constant = (self.view.frame.size.width-((self.view.frame.size.width*25)/100))
         self.navigationController?.setNavigationBarHidden(true, animated: true);
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"),
                                               object: nil)
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = -(self.view.frame.size.width-((self.view.frame.size.width*25)/100))
            
        } else {
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
            NotificationCenter.default.post(name: NSNotification.Name("UpdateProfileInfo"), object: nil)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

}
