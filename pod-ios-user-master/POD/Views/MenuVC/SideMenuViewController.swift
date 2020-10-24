//
//  SideMenuViewController.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Kingfisher
import NotificationBannerSwift

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var profileImage:UIImageView!
    @IBOutlet var lblProfileName:UILabel!
    @IBOutlet weak var lblEarnerPoints: UILabel!
    @IBOutlet var tblMenu:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        Helper.SetRoundImage(img: profileImage, cornerRadius: 50, borderWidth: 2, borderColor: UIColor.white)
        MenuController.GetMenuList()
        
        self.tblMenu.reloadData()
        
        self.SetUserInfo()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SetUserInfo),
                                               name: NSNotification.Name("UpdateProfileInfo"),
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func SetUserInfo(){
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let account : Account = AccountManager.instance().activeAccount!
        lblProfileName.text = account.name
        lblEarnerPoints.text = account.referralPoint
        
        if let url  = URL(string: account.profileImage ) {
            profileImage.kf.indicatorType = .activity
            
            profileImage.kf.setImage(
                with: url,
                placeholder: UIImage.init(named: "user"),
                options: nil)
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            
        }
        profileImage.clipsToBounds = true
        GetCustomerProfile(userID: account.user_id, account: account)
        
    }
    
    func GetCustomerProfile(userID:String, account : Account){
        ApiManager.sharedInstance.requestGETURL(Constant.getCustomerProfileURL+"/"+userID, success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                account.parseUserDict(userDict: JSON.dictionaryObject!["ResponseData"] as! NSDictionary, account: account)
                self.lblEarnerPoints.text = account.referralPoint
                
            } else{
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SideMenuViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(MenuController.menuList.count)
        return MenuController.menuList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.SetData(icon: MenuController.menuList[indexPath.row].icon, name: MenuController.menuList[indexPath.row].name)
        if(indexPath.row == 0){
            cell.icon?.tintColor = UIColor.init(hexString: "#F9B212")
            cell.lblTitle.textColor = UIColor.init(hexString: "#F9B212")
            cell.contentView.backgroundColor = UIColor.init(hexString: "#F2F2F7")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //        if(indexPath.row == 2){
        //            cell.lblTitle.blink()
        //        }
        
//        UIColor.init(hexString: "MenuCell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            Constant.IsOpenMenu = false;
            Constant.homeVC!.RemoveOverlay();
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        } else if(indexPath.row == 1){
            NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        } else if(indexPath.row == 2){
            NotificationCenter.default.post(name: NSNotification.Name("showReferAndEarn"), object: nil)
        } else if(indexPath.row == 3){
            NotificationCenter.default.post(name: NSNotification.Name("ShowNotification"), object: nil)
        } else if(indexPath.row == 4){
            NotificationCenter.default.post(name: NSNotification.Name("ShowOrders"), object: nil)
        } else if(indexPath.row == 5){
            NotificationCenter.default.post(name: NSNotification.Name("ShowInquiry"), object: nil)
        } else if(indexPath.row == 6){
            NotificationCenter.default.post(name: NSNotification.Name("ShowResetPassword"), object: nil)
        } else if(indexPath.row == 7){
            NotificationCenter.default.post(name: NSNotification.Name("ShowAboutUs"), object: nil)
        } else if(indexPath.row == 8){
            NotificationCenter.default.post(name: NSNotification.Name("ShowFAQ"), object: nil)
        } else if(indexPath.row == 9){
            NotificationCenter.default.post(name: NSNotification.Name("ShowTC"), object: nil)
        } else if(indexPath.row == 10){
            NotificationCenter.default.post(name: NSNotification.Name("ShowPivacyPolicy"), object: nil)
        } else if(indexPath.row == 11){
            NotificationCenter.default.post(name: NSNotification.Name("ShowHelpDesk"), object: nil)
        } else if(indexPath.row == 12){
            
            UserDefaults.standard.removeObject(forKey: "UserInfo")
            UserDefaults.standard.synchronize()
            
            var isPresent:Bool = false;
            var findVc:UIViewController?
            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    // some process
                    if viewController is  LoginViewController{
                        isPresent = true;
                        findVc = viewController;
                        break;
                    }
                }
            }
            AccountManager.instance().activeAccount = nil
            if(isPresent){
                self.navigationController?.popToViewController(findVc!, animated: true)
            } else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.viewControllers.insert(controller, at: 1)
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
}
//extension UILabel {
//    func blink() {
//        self.alpha = 0.0;
//        UIView.animate(withDuration: 0.2, //Time duration you want,
//                       delay: 0.0,
//                       options: [.curveEaseInOut, .autoreverse, .repeat],
//                       animations: { [weak self] in self?.alpha = 1.0 },
//                       completion: { [weak self] _ in self?.alpha = 0.0 })
//    }
//
//}
