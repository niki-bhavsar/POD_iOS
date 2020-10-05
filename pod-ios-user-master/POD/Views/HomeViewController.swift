//
//  HomeViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//
import UIKit
import AVFoundation
class HomeViewController: BaseViewController {
    
    var IsOpenMenu:Bool = false
    @IBOutlet var viewBanner:UIView!
    @IBOutlet var pageControler:UIPageControl!
    @IBOutlet var viewlayer:UIView!
    @IBOutlet var sv:UIScrollView!
    @IBOutlet var lblNotificationCount:UILabel!
   
    var timer:Timer!
    let account = AccountManager.instance().activeAccount//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constant.homeVC = self;
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.SetStatusBarColor()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         Helper.ISINquery = false;
        Constant.mainNav = self.navigationController;
        Constant.FirstSubcategoryId = ""
        Constant.AllSubcategoryId = ""
        Constant.FirstSubcategory = ""
        Constant.AllSubcategory = ""
        Constant.AllSubcategoryArr.removeAll();
        Constant.AllSubcategoryIdArr.removeAll();
        lblNotificationCount.text = Constant.notificationCount.description;
        if(Constant.OrderDic != nil){
            Constant.OrderDic.removeAll()
        }
        if(Constant.InquiryDic != nil){
            Constant.InquiryDic.removeAll()
        }
        self.viewlayer.isHidden = true;
        Constant.IsOpenMenu = false;
        self.CheckCompleteProfile()
        pageControler.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        LoginController.GetBanners(vc: self);
        self.viewlayer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(HomeViewController.CloseMenu)))
        
        if(timer != nil){
            if(timer.isValid){
                timer.invalidate()
            }
        }
        LoadNotification()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(HomeViewController.LoadNotification), userInfo: nil, repeats: true);
//        if let Id = userInfo!["Id"]{
//            LoginController.CheckUnPaidUser(userId: Id as! String, vc: self)
//        }
    }

    
    
    public func RemoveOverlay(){
        Constant.IsOpenMenu = false;
        self.viewlayer.isHidden = true;
    }
    
    @objc func CloseMenu(){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
               if(Constant.IsOpenMenu == false){
                   Constant.IsOpenMenu = !Constant.IsOpenMenu
                self.viewlayer.isHidden = false;
               }
               else{
                   Constant.IsOpenMenu = !Constant.IsOpenMenu
                self.viewlayer.isHidden = true;
               }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let Id = account?.user_id{
            LoginController.CheckUnPaidUser(userId: Id , vc: self)
        }
        LoadNotification();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(timer != nil){
            if(timer.isValid){
                timer.invalidate()
            }
        }
    }
    
    @objc func LoadNotification(){
        if let Id = account?.user_id{
            DispatchQueue.global(qos: .default).async {
                
                LoginController.GetNotificatins(userId: Id as! String, vc: self)
                DispatchQueue.main.async {
                        
                }
            }
        }
        
    }
    
    @IBAction func btn_MenuTapped() {
        self.CloseMenu()
    }
    
    @IBAction func  btnShowNotification(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "MyNotificationViewController") as! MyNotificationViewController
               Helper.rootNavigation?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func bookNowclicked(_ sender: Any) {
        let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        
        Constant.OrderDic = [String:Any]()
        Constant.OrderDic["CustomerId"] = ""
        Constant.OrderDic["Name"] = ""
        Constant.OrderDic["Email"] = ""
        Constant.OrderDic["Phone1"] = ""
        Constant.OrderDic["ShootingAddress"] = ""
        Constant.OrderDic["ShootingDate"] = ""
        Constant.OrderDic["ShootingStartTime"] = ""
        Constant.OrderDic["ShootingEndTime"] = ""
        Constant.OrderDic["ShootingHours"] = ""
        Constant.OrderDic["ProductId"] = ""
        Constant.OrderDic["ProductIds"] = ""
        Constant.OrderDic["ProductTitle"] = ""
        Constant.OrderDic["ProductPrice"] = ""
        Constant.OrderDic["Transportation"] = ""
        Constant.OrderDic["SubTotal"] = ""
        Constant.OrderDic["Total"] = ""
        Constant.OrderDic["PaymentMethod"] = ""
        Constant.OrderDic["PaymentStatus"] = ""
        Constant.OrderDic["Transaction_id"] = "POD"
        Constant.OrderDic["ShootingLat"] = ""
        Constant.OrderDic["ShootingLng"] = ""
        Constant.OrderDic["ShootingMeetPoint"] = ""
        
        //            if let UserID = userInfo!["Id"]{
        Constant.OrderDic["CustomerId"] = account.user_id
        //            }
        //            if let Name = userInfo!["Name"]{
        Constant.OrderDic["Name"] = account.name
        //            }
        //            if let Email = userInfo!["Email"]{
        Constant.OrderDic["Email"] = account.email
        //            }
        
        //            if let Name = userInfo!["Name"]{
        //                Constant.OrderDic["Name"] = Name
        //            }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectGategoryViewController") as! SelectGategoryViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func inquiryNowclicked(_ sender: Any) {
        Constant.InquiryDic = [String:Any]()
                     Constant.InquiryDic["CustomerId"] = ""
                     Constant.InquiryDic["Name"] = ""
                     Constant.InquiryDic["Email"] = ""
                     Constant.InquiryDic["Phone"] = ""
                     Constant.InquiryDic["DOB"] = ""
                     Constant.InquiryDic["TypeOfShoot"] = ""
                     Constant.InquiryDic["DateOfShoot"] = ""
                     Constant.InquiryDic["StartTime"] = ""
                     Constant.InquiryDic["EndTime"] = ""
                     Constant.InquiryDic["ShootingHours"] = ""
                     Constant.InquiryDic["Area"] = ""
                     Constant.InquiryDic["City"] = ""
                     Constant.InquiryDic["State"] = ""
                     Constant.InquiryDic["Country"] = ""
                     Constant.InquiryDic["Message"] = ""
                     Constant.InquiryDic["Source"] = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "InqueryCategoryViewController") as! InqueryCategoryViewController
               self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    
//        if(segue.identifier == "SelectGategoryViewController" || segue.identifier == "InqueryCategoryViewController"){
//            let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
//                
//            Constant.OrderDic = [String:AnyObject]()
//            Constant.OrderDic["CustomerId"] = ""
//            Constant.OrderDic["Name"] = ""
//            Constant.OrderDic["Email"] = ""
//            Constant.OrderDic["Phone1"] = ""
//            Constant.OrderDic["ShootingAddress"] = ""
//            Constant.OrderDic["ShootingDate"] = ""
//            Constant.OrderDic["ShootingStartTime"] = ""
//            Constant.OrderDic["ShootingEndTime"] = ""
//            Constant.OrderDic["ShootingHours"] = ""
//            Constant.OrderDic["ProductId"] = ""
//            Constant.OrderDic["ProductIds"] = ""
//            Constant.OrderDic["ProductTitle"] = ""
//            Constant.OrderDic["ProductPrice"] = ""
//            Constant.OrderDic["Transportation"] = ""
//            Constant.OrderDic["SubTotal"] = ""
//            Constant.OrderDic["Total"] = ""
//            Constant.OrderDic["PaymentMethod"] = ""
//            Constant.OrderDic["PaymentStatus"] = ""
//            Constant.OrderDic["Transaction_id"] = "POD"
//            Constant.OrderDic["ShootingLat"] = ""
//            Constant.OrderDic["ShootingLng"] = ""
//            Constant.OrderDic["ShootingMeetPoint"] = ""
//            
////            if let UserID = userInfo!["Id"]{
//            Constant.OrderDic["CustomerId"] = account.user_id
////            }
////            if let Name = userInfo!["Name"]{
//            Constant.OrderDic["Name"] = account.name
////            }
////            if let Email = userInfo!["Email"]{
//            Constant.OrderDic["Email"] = account.email
////            }
//            
////            if let Name = userInfo!["Name"]{
////                Constant.OrderDic["Name"] = Name
////            }
////            
//            if(segue.identifier == "InqueryCategoryViewController"){
//                
//                Constant.InquiryDic = [String:Any]()
//                Constant.InquiryDic["CustomerId"] = ""
//                Constant.InquiryDic["Name"] = ""
//                Constant.InquiryDic["Email"] = ""
//                Constant.InquiryDic["Phone"] = ""
//                Constant.InquiryDic["DOB"] = ""
//                Constant.InquiryDic["TypeOfShoot"] = ""
//                Constant.InquiryDic["DateOfShoot"] = ""
//                Constant.InquiryDic["StartTime"] = ""
//                Constant.InquiryDic["EndTime"] = ""
//                Constant.InquiryDic["ShootingHours"] = ""
//                Constant.InquiryDic["Area"] = ""
//                Constant.InquiryDic["City"] = ""
//                Constant.InquiryDic["State"] = ""
//                Constant.InquiryDic["Country"] = ""
//                Constant.InquiryDic["Message"] = ""
//                Constant.InquiryDic["Source"] = ""
//                
//            }
//        }
//     }
    
    func CheckCompleteProfile(){
        var result:Bool = true;
        let account = AccountManager.instance().activeAccount! //Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
//        if let mobileNo = account.phone{
        if(account.phone.count == 0 || account.phone == ""){
                result = false;
            }
//        } else{
//            result = false;
//        }
        
//        if let email = userInfo?["Email"]{
            if(account.email.count == 0 || account.email == ""){
                result = false;
            }
//        } else{
//            result = false;
//        }
        
        if(result == false){
            let callActionHandler = { () -> Void in
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                      Helper.rootNavigation?.pushViewController(controller, animated: true)
                     
            }
            
            Helper.ShowAlertMessageWithHandlesr(message:"Please complete your profile first.",title:"" ,vc: self,action:callActionHandler)
        }
        
    }
    let imageCache = NSCache<NSString, UIImage>()
    public func LoadBanners(){
        self.pageControler.numberOfPages = LoginController.listBanners!.count;
        var x:Int = 0
        for subview in sv.subviews{
          subview.removeFromSuperview()
        }
        for obj in LoginController.listBanners! {
            let img = UIImageView.init(frame: CGRect.init(x: x, y: 0, width: Int(viewBanner.frame.size.width), height: Int(viewBanner.frame.size.height)))
            sv.addSubview(img);
            if let cachedImage = imageCache.object(forKey: NSString(string: obj["Image"] as! String)) {
                img.image = cachedImage
                return
            }
            if let url = URL(string: obj["Image"] as! String) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                    //print("RESPONSE FROM API: \(response)")
                    if error != nil {
                        print("ERROR LOADING IMAGES FROM URL: \(error)")
                        DispatchQueue.main.async {
                            //img.image = placeHolder
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                self.imageCache.setObject(downloadedImage, forKey: NSString(string: obj["Image"] as! String))
                                img.image = downloadedImage
                            }
                        }
                    }
                }).resume()
            }
            
            x = x + Int(viewBanner.frame.size.width);
            
        }
        sv.contentSize = CGSize.init(width: x, height: 0);
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(sv.contentOffset.x / sv.frame.size.width)
        pageControler.currentPage = Int(pageNumber)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControler.currentPage) * sv.frame.size.width
        sv.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    @objc func moveToNextPage (){
            
    let pageWidth:CGFloat = self.sv.frame.width
    let maxWidth:CGFloat = pageWidth * 4
    let contentOffset:CGFloat = self.sv.contentOffset.x
    var slideToX = contentOffset + pageWidth
    if  contentOffset + pageWidth == maxWidth{
          slideToX = 0
    }
    sv.setContentOffset(CGPoint(x:slideToX, y:0), animated: true)
        let pageNumber = round(sv.contentOffset.x / sv.frame.size.width)
        pageControler.currentPage = Int(pageNumber)
    //self.sv.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.sv.frame.height), animated: true)
    }
}
