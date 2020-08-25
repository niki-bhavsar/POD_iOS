//
//  MenuController.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MenuController: NSObject {

    public static var menuList:[Menu] = [Menu]()
    static func GetMenuList()
    {
        NotificationCenter.default.removeObserver(self);
        menuList.removeAll()
        menuList.append(Menu.init(name: "Home", icon: "Home"))
        menuList.append(Menu.init(name: "My Profile", icon: "ic_edit_profile"))
         menuList.append(Menu.init(name: "My Notification", icon: "Notification"))
        menuList.append(Menu.init(name: "My Booking", icon: "ic_booking"))
        menuList.append(Menu.init(name: "My Inquiry", icon: "Inquiry"))
        menuList.append(Menu.init(name: "Reset Password", icon: "ic_forgot_password"))
        menuList.append(Menu.init(name: "About Us", icon: "Chat"))
        menuList.append(Menu.init(name: "FAQ", icon: "FAQ"))
        menuList.append(Menu.init(name: "Terms and Condition", icon: "ic_terms_and_conditions"))
        menuList.append(Menu.init(name: "Privacy Policy", icon: "ic_privacy"))
        //menuList.append(Menu.init(name: "Contact Us", icon: "ic_contact_us"))
        menuList.append(Menu.init(name: "24*7 Help", icon: "ic_help"))
        menuList.append(Menu.init(name: "Logout", icon: "ic_logout"))
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showProfile),
                                               name: NSNotification.Name("ShowProfile"),
                                               object: nil)
       
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(showOrders),
                                                      name: NSNotification.Name("ShowOrders"),
                                                      object: nil)
        
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(showAboutUs),
        name: NSNotification.Name("ShowAboutUs"),
        object: nil)
        
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(showResetPassword),
               name: NSNotification.Name("ShowResetPassword"),
               object: nil)
        
       
        NotificationCenter.default.addObserver(self,
        selector: #selector(showTC),
        name: NSNotification.Name("ShowTC"),
        object: nil)
        
       
        NotificationCenter.default.addObserver(self,
        selector: #selector(showPrivacyPolicy),
        name: NSNotification.Name("ShowPivacyPolicy"),
        object: nil)
        
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(showContactUs),
        name: NSNotification.Name("ShowContactUs"),
        object: nil)
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(showhelpDesk),
               name: NSNotification.Name("ShowHelpDesk"),
               object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(showNotification),
        name: NSNotification.Name("ShowNotification"),
        object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(showFAQ),
        name: NSNotification.Name("ShowFAQ"),
        object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(showInquiry),
        name: NSNotification.Name("ShowInquiry"),
        object: nil)
       
    }
    
    
    @objc static func showProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showOrders() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showAboutUs() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc static func showResetPassword() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileResetPasswordViewController") as! ProfileResetPasswordViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showTC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        controller.isFAQ = false;
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showPrivacyPolicy() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showContactUs() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showhelpDesk() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HelpDeskViewController") as! HelpDeskViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showNotification() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyNotificationViewController") as! MyNotificationViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showFAQ() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc static func showInquiry() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyInquiryViewController") as! MyInquiryViewController
        Helper.rootNavigation?.pushViewController(controller, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
}
