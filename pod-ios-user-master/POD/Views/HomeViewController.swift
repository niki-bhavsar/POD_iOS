//
//  HomeViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//
import UIKit
import AVFoundation
class HomeViewController: UIViewController {
    var IsOpenMenu:Bool = false
    @IBOutlet var viewBanner:UIView!
    @IBOutlet var pageControler:UIPageControl!
    @IBOutlet var viewlayer:UIView!
    @IBOutlet var sv:UIScrollView!
    @IBOutlet var lblNotificationCount:UILabel!
   
    var timer:Timer!
    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constant.homeVC = self;
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.SetStatusBarColor()
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
            Constant.OrderDic?.removeAll()
        }
        if(Constant.InquiryDic != nil){
            Constant.InquiryDic?.removeAll()
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
        if let Id = userInfo!["Id"]{
            LoginController.CheckUnPaidUser(userId: Id as! String, vc: self)
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
        if let Id = userInfo!["Id"]{
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
    
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if(segue.identifier == "SelectGategoryViewController" || segue.identifier == "InqueryCategoryViewController"){
            let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
                
            Constant.OrderDic = [String:AnyObject]()
            Constant.OrderDic!["CustomerId"] = "" as AnyObject;
            Constant.OrderDic!["Name"] = "" as AnyObject;
            Constant.OrderDic!["Email"] = "" as AnyObject;
            Constant.OrderDic!["Phone1"] = "" as AnyObject;
            Constant.OrderDic!["ShootingAddress"] = "" as AnyObject;
            Constant.OrderDic!["ShootingDate"] = "" as AnyObject;
            Constant.OrderDic!["ShootingStartTime"] = "" as AnyObject;
            Constant.OrderDic!["ShootingEndTime"] = "" as AnyObject;
            Constant.OrderDic!["ShootingHours"] = "" as AnyObject;
            Constant.OrderDic!["ProductId"] = "" as AnyObject;
            Constant.OrderDic!["ProductIds"] = "" as AnyObject;
            Constant.OrderDic!["ProductTitle"] = "" as AnyObject;
            Constant.OrderDic!["ProductPrice"] = "" as AnyObject;
            Constant.OrderDic!["Transportation"] = "" as AnyObject;
            Constant.OrderDic!["SubTotal"] = "" as AnyObject;
            Constant.OrderDic!["Total"] = "" as AnyObject;
            Constant.OrderDic!["PaymentMethod"] = "" as AnyObject;
            Constant.OrderDic!["PaymentStatus"] = "" as AnyObject;
            Constant.OrderDic!["Transaction_id"] = "POD" as AnyObject;
            Constant.OrderDic!["ShootingLat"] = "" as AnyObject;
            Constant.OrderDic!["ShootingLng"] = "" as AnyObject;
            Constant.OrderDic!["ShootingMeetPoint"] = "" as AnyObject;
            
            if let UserID = userInfo!["Id"]{
                Constant.OrderDic!["CustomerId"] = UserID as AnyObject;
            }
            if let Name = userInfo!["Name"]{
                Constant.OrderDic!["Name"] = Name as AnyObject;
            }
            if let Email = userInfo!["Email"]{
                Constant.OrderDic!["Email"] = Email as AnyObject;
            }
            if let Name = userInfo!["Name"]{
                Constant.OrderDic!["Name"] = Name as AnyObject;
            }
//            
            if(segue.identifier == "InqueryCategoryViewController")
            {
                
                Constant.InquiryDic = [String:AnyObject]()
                Constant.InquiryDic!["CustomerId"] = "" as AnyObject;
                Constant.InquiryDic!["Name"] = "" as AnyObject;
                Constant.InquiryDic!["Email"] = "" as AnyObject;
                Constant.InquiryDic!["Phone"] = "" as AnyObject;
                Constant.InquiryDic!["DOB"] = "" as AnyObject;
                Constant.InquiryDic!["TypeOfShoot"] = "" as AnyObject;
                Constant.InquiryDic!["DateOfShoot"] = "" as AnyObject;
                Constant.InquiryDic!["StartTime"] = "" as AnyObject;
                Constant.InquiryDic!["EndTime"] = "" as AnyObject;
                Constant.InquiryDic!["ShootingHours"] = "" as AnyObject;
                Constant.InquiryDic!["Area"] = "" as AnyObject;
                Constant.InquiryDic!["City"] = "" as AnyObject;
                Constant.InquiryDic!["State"] = "" as AnyObject;
                Constant.InquiryDic!["Country"] = "" as AnyObject;
                Constant.InquiryDic!["Message"] = "" as AnyObject;
                Constant.InquiryDic!["Source"] = "" as AnyObject;
                
            }
        }
     }
    
    func CheckCompleteProfile(){
        var result:Bool = true;
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        if let mobileNo = userInfo?["Phone"]{
            if(mobileNo.count==0 || mobileNo as! String == ""){
                result = false;
            }
        }
        else{
            result = false;
        }
        if let email = userInfo?["Email"]{
            if(email.count==0 || email as! String == ""){
                result = false;
            }
        }
        else{
            result = false;
        }
        
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
    if  contentOffset + pageWidth == maxWidth
    {
          slideToX = 0
    }
    sv.setContentOffset(CGPoint(x:slideToX, y:0), animated: true)
        let pageNumber = round(sv.contentOffset.x / sv.frame.size.width)
        pageControler.currentPage = Int(pageNumber)
    //self.sv.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.sv.frame.height), animated: true)
    }
}
