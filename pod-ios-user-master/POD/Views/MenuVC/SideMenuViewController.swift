//
//  SideMenuViewController.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var profileImage:UIImageView!
    @IBOutlet var lblProfileName:UILabel!
    @IBOutlet var tblMenu:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        Helper.SetRoundImage(img: profileImage, cornerRadius: 50, borderWidth: 2, borderColor: UIColor.white)
        MenuController.GetMenuList();
        self.tblMenu.reloadData();
        self.SetUserInfo();
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
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
         if let name = userInfo!["Name"]{
             lblProfileName.text = (name as! String);
         }
        if let imgURL = userInfo?["ProfileImage"]{
             
            let imageUrl:NSURL = NSURL(string:  (imgURL as! String))!
            if(imageUrl.absoluteString?.count != 0){
             DispatchQueue.global(qos: .default).async {
             let imageData:NSData? = NSData(contentsOf: imageUrl as URL) ?? nil
                 DispatchQueue.main.async {
                    if(imageData != nil){
                        let image = UIImage(data: imageData as! Data)
                    self.profileImage.image = image
                    self.profileImage.contentMode = UIView.ContentMode.scaleAspectFit
                    }
                  }
                }
            }
         }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SideMenuViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(MenuController.menuList.count);
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
        UIColor.init(hexString: "MenuCell");
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            Constant.IsOpenMenu = false;
            Constant.homeVC!.RemoveOverlay();
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        }
        else if(indexPath.row == 1){
                NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        }
        else if(indexPath.row == 2){
            NotificationCenter.default.post(name: NSNotification.Name("ShowNotification"), object: nil)
        }
        else if(indexPath.row == 3){
            NotificationCenter.default.post(name: NSNotification.Name("ShowOrders"), object: nil)
        }
            else if(indexPath.row == 4){
                NotificationCenter.default.post(name: NSNotification.Name("ShowInquiry"), object: nil)
            }
        else if(indexPath.row == 5){
            NotificationCenter.default.post(name: NSNotification.Name("ShowResetPassword"), object: nil)
        }
        else if(indexPath.row == 6){
            NotificationCenter.default.post(name: NSNotification.Name("ShowAboutUs"), object: nil)
        }
            else if(indexPath.row == 7){
                NotificationCenter.default.post(name: NSNotification.Name("ShowFAQ"), object: nil)
            }
        else if(indexPath.row == 8){
            NotificationCenter.default.post(name: NSNotification.Name("ShowTC"), object: nil)
        }
        else if(indexPath.row == 9){
            NotificationCenter.default.post(name: NSNotification.Name("ShowPivacyPolicy"), object: nil)
        }
//        else if(indexPath.row == 7){
//            NotificationCenter.default.post(name: NSNotification.Name("ShowContactUs"), object: nil)
//        }
        else if(indexPath.row == 11){
            
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
            if(isPresent){
                self.navigationController?.popToViewController(findVc!, animated: true)
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.viewControllers.insert(controller, at: 1)
                self.navigationController?.popToViewController(controller, animated: true)
            }
            
        }
        else if(indexPath.row == 10){
            NotificationCenter.default.post(name: NSNotification.Name("ShowHelpDesk"), object: nil)
        }
        
        
    }
}
