//
//  SendPaymentViewController.swift
//  POD
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class SendPaymentViewController: BaseViewController, OnlinePaymentProtocal {
    
    @IBOutlet var lblOrderID:UILabel!
    @IBOutlet var lblDate:UILabel!
    //    @IBOutlet var lblStartDate:UILabel!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet var lblStartTime:UILabel!
    //    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblAmount:UILabel!
    @IBOutlet var lblVisiting:UILabel!
    @IBOutlet var lblTotal:UILabel!
    public var dicInfo:[String:Any]!
    
    let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetData()
        // Do any additional setup after loading the view.
    }
    
    
    func SetData(){
        if(dicInfo != nil){
            if let OrderNo = dicInfo["OrderNo"]{
                self.lblOrderID.text = "\(OrderNo)"
            }
            
            if let ShootingDate = dicInfo["ShootingDate"]{
                self.lblDate.text = "\(ShootingDate)"
                
            }
            
            if let ShotingStartTime = dicInfo["ShootingStartTime"]{
                
                self.lblStartTime.text = "\(Helper.ConvertDateToTime(dateStr: ShotingStartTime as! String,timeFormat: "HH:mm"))"
            }
            
            if let ShotingeEndTime = dicInfo["ShootingEndTime"]{
                
                self.lblStartTime.text = "\(lblStartTime.text ?? "") to \((Helper.ConvertDateToTime(dateStr: ShotingeEndTime as! String,timeFormat: "HH:mm")))"
            }
            
            if let title = dicInfo["ProductTitle"]{
                self.lblTitle.text = "\(title)"
            }
            var subTotalVal : Double = 0.0
            var totlaVal : Double = 0.0
            
            if let SubTotal : String = dicInfo!["SubTotal"] as? String{
                lblAmount.text = SubTotal
                subTotalVal = Double(SubTotal) ?? 0.0
            }
            
            if let Total : String = dicInfo["Total"] as? String {
                self.lblTotal.text = Total
                totlaVal = Double(Total) ?? 0.0
            }
            
            if let trasportation = dicInfo["Transportation"]{
                self.lblVisiting.text = "\(trasportation)"
            }
            
            lblGST.text = String(format: "%.2f", totlaVal - subTotalVal)
            
        }
    }
    
    @IBAction func btnPayClick(){
        //        //if let photographFile = dicInfo["photographFile"]{
        //           // if(photographFile.length == 0){
        //                Constant.OrderDic = [String:AnyObject]()
        //                Constant.OrderDic!["Name"] =  dicInfo["Name"] as AnyObject;
        //                Constant.OrderDic!["Email"] =  dicInfo["Email"] as AnyObject;
        //                let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
        //                controller.totalAmount = "199"
        //                controller.del = self; self.navigationController?.pushViewController(controller, animated: true)
        //
        //
        //            //}
        //
        //        //}
        
        Constant.OrderDic = [String:Any]()
        Constant.OrderDic["Name"] =  dicInfo["Name"]
        Constant.OrderDic["Email"] =  dicInfo["Email"]
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
        controller.totalAmount =  lblTotal.text!
        controller.del = self; self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    //    func GetTransactionId(transactionID: String, status: Bool) {
    //        if(transactionID.count != 0){
    //            if(status == true){
    //                self.SubmitPhotographerRequest()
    //            }
    //            else{
    //                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
    //            }
    //        }
    //    }
    
    func GetTransactionId(transactionID: String, status: Bool) {
        if(transactionID.count != 0){
            if(status == true){
                self.SubmitPhotographerPaymentRequest(transactionID: transactionID)
            }
            else{
                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }
    }
    
    func SubmitPhotographerPaymentRequest(transactionID:String){
        var dic = [String:AnyObject]()
        dic["OrderId"] = dicInfo["Id"] as AnyObject;
        dic["TransactionId"] = transactionID as AnyObject;
        dic["ExtId"] = dicInfo["ExtId"] as AnyObject;
        dic["CustomerId"] = dicInfo["CustomerId"] as AnyObject;
        MyOrderController.ExtendedRemainPhotoGrapherOrderPayment(vc: self, orderInfo: dic);
    }
    
    //    func SubmitPhotographerRequest(){
    //        var dic = [String:AnyObject]()
    //        dic["OrderId"] = dicInfo["Id"] as AnyObject;
    //        dic["PaymentMethod"] = "Online" as AnyObject;
    //        dic["PaymentStatus"] = "1" as AnyObject;
    //        dic["Amount"] = "199" as AnyObject;
    //        dic["CustomerId"] = dicInfo["CustomerId"] as AnyObject;
    //        MyOrderController.photographOrderPayment(vc: self, orderInfo: dic);
    //
    //
    //    }
    
    
}
