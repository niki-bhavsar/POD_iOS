//
//  ExtendPhotographerPaymentViewController.swift
//  POD
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ExtendPhotographerPaymentViewController:  UIViewController,OnlinePaymentProtocal {
    
    @IBOutlet var lblOrderID:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblStartTime:UILabel!
    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblcategory:UILabel!
    @IBOutlet var lblVisiting:UILabel!
    @IBOutlet var lblTotal:UILabel!
    @IBOutlet var lblExtendedTime:UILabel!
    @IBOutlet var lblShootingAmount:UILabel!
    @IBOutlet var lblExtShootingAmount:UILabel!
    public var dicOrder:[String:AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var shootingamt:Double = 0.0
        var extamt:Double = 0.0
        if(dicOrder != nil){
            if let category = dicOrder["ProductTitle"]{
                lblcategory.text = (category as! String);
            }
            if let OrderNo = dicOrder["OrderNo"]{
                lblOrderID.text = (OrderNo as! String);
            }
            if let date = dicOrder["ShootingDate"]{
                lblDate.text = (Helper.ConvertDateToTime(dateStr: date as! String, timeFormat: "yyyy-MM-dd") as! String);
            }
            if let starttime = dicOrder["ShootingStartTime"]{
                lblStartTime.text = (starttime as! String);
            }
            if let endtime = dicOrder["ShootingEndTime"]{
                lblEndTime.text = (endtime as! String);
            }
            if let extendedtime = dicOrder["ExtEndTime"]{
                lblExtendedTime.text = (extendedtime as! String);
            }
            
            if let shootingAMT = dicOrder["Total"]{
                lblShootingAmount.text = (shootingAMT as! String);
                shootingamt = Double(shootingAMT as! String)!
            }
            
            if let visiting = dicOrder["Transportation"]{
                lblVisiting.text = (visiting as! String);
            }
            
            if let extAMT = dicOrder["ExtAmount"]{
                lblExtShootingAmount.text = (extAMT as! String);
                extamt = Double(extAMT as! String)!
            }
            
            let total = shootingamt + extamt
            lblTotal.text = total.description;
            
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnPayClick(){
        
        Constant.OrderDic = [String:AnyObject]()
        Constant.OrderDic!["Name"] =  dicOrder["Name"] as AnyObject;
        Constant.OrderDic!["Email"] =  dicOrder["Email"] as AnyObject;
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
        controller.totalAmount =  lblTotal.text!
        controller.del = self; self.navigationController?.pushViewController(controller, animated: true)
        
        
        
    }
    
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
        dic["OrderId"] = dicOrder["ExtOrderId"] as AnyObject;
        dic["TransactionId"] = transactionID as AnyObject;
        dic["ExtId"] = dicOrder["ExtId"] as AnyObject;
        dic["CustomerId"] = dicOrder["ExtCustomerId"] as AnyObject;
        MyOrderController.ExtendedRemainPhotoGrapherOrderPayment(vc: self, orderInfo: dic);
    }
}
