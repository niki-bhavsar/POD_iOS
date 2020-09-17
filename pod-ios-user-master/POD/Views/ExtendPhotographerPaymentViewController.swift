//
//  ExtendPhotographerPaymentViewController.swift
//  POD
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ExtendPhotographerPaymentViewController: BaseViewController, OnlinePaymentProtocal {
    
    @IBOutlet var lblOrderID:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblStartTime:UILabel!
//    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblcategory:UILabel!
    @IBOutlet var lblVisiting:UILabel!
    @IBOutlet var lblTotal:UILabel!
//    @IBOutlet var lblExtendedTime:UILabel!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet var lblShootingAmount:UILabel!
    @IBOutlet var lblExtShootingAmount:UILabel!
    public var dicOrder:[String:AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var shootingamt:Double = 0.0
//        var extamt:Double = 0.0
        
        if(dicOrder != nil){
            if let category = dicOrder["ProductTitle"]{
                lblcategory.text = (category as! String);
            }
            if let OrderNo = dicOrder["OrderNo"]{
                lblOrderID.text = (OrderNo as! String);
            }
            if let date = dicOrder["ShootingDate"]{
                lblDate.text = (Helper.ConvertDateToTime(dateStr: date as! String, timeFormat: "yyyy-MM-dd") );
            }
            if let starttime = dicOrder["ShootingStartTime"]{
                lblStartTime.text = (starttime as! String);
            }
            
            if let extendedtime = dicOrder["ExtEndTime"]{
                lblStartTime.text = "\(lblStartTime.text ?? "") to \(extendedtime)"
            }
            //            else {
            //                if let endtime = dicOrder["ShootingEndTime"]{
            //                    lblStartTime.text = "\(lblStartTime.text ?? "") to \(endtime)"
            //                }
            //            }
            
            var subTotalVal : Double = 0.0
            var extendedVal : Double = 0.0
            var totlaVal : Double = 0.0
            
            if let SubTotal : String = dicOrder!["SubTotal"] as? String{
                lblShootingAmount.text = SubTotal
                subTotalVal = Double(SubTotal) ?? 0.0
            }
            
            if let productPrice : String = dicOrder!["ProductPrice"] as? String{
                let prodPrice : Int = Int(productPrice) ?? 0
                let extHours : String = dicOrder!["ExtHours"] as! String
                let extHoursInt : Int = Int(extHours) ?? 0
                
                lblExtShootingAmount.text = "\(prodPrice * extHoursInt)"
                extendedVal = Double(prodPrice * extHoursInt)
            }
            
            if let visiting = dicOrder["Transportation"]{
                lblVisiting.text = (visiting as! String);
            }
            
            if let totalStr : String = dicOrder!["Total"] as? String{
                let extAMTStr : String = dicOrder!["ExtAmount"] as! String
                let extAMT : Double = Double(extAMTStr) ?? 0.0
                
                let total : Double = Double(totalStr) ?? 0.0
                lblTotal.text = String(format: "%.2f", total + extAMT)
                totlaVal = total + extAMT
            }
            
             var gstVal : Double = 0.0
            gstVal = subTotalVal + extendedVal
            
             lblGST.text = String(format: "%.2f", totlaVal - gstVal)
            
        }
        
        
      
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnPayClick(){
        
        Constant.OrderDic = [String:Any]()
        Constant.OrderDic["Name"] =  dicOrder["Name"]
        Constant.OrderDic["Email"] =  dicOrder["Email"]
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
