//
//  ExtendOrderPaymentViewController.swift
//  POD
//
//  Created by Apple on 14/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ExtendOrderPaymentViewController: UIViewController ,OnlinePaymentProtocal {
    
    @IBOutlet var btnPAS:UIButton!
    @IBOutlet var btnOnline:UIButton!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblVisitingCost: UILabel!
    @IBOutlet weak var lblShootCost: UILabel!
    var dicOrder:[String:AnyObject]!
    var prodcutPrice:Double = 0;
    var extHours:Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        if(dicOrder != nil){
           if let category = dicOrder["ProductTitle"]{
            lblCategory.text = (category as! String);
            
            }
            if let cost = dicOrder["ProductPrice"]{
                lblShootCost.text = (cost as! String);
                prodcutPrice = Double(cost as! String)!
            }
            if let hours = dicOrder["ExtHours"]{
                //extHours = Int((hours as! String))!
                lblVisitingCost.text = (hours as! String);
            
            }
            if let total = Double(dicOrder["ExtAmount"] as! String){
                if(lblShootCost.text!.count>0){
                    
                    //let totalWithGST:Double = (prodcutPrice * 18)/100
                    //let totVal = (total  + totalWithGST);
                    lblTotal.text = String(format: "%.2f", total);
                }
                else{
                    lblTotal.text = total as? String
                }
            
            }
            if let PaymentMethod = dicOrder["PaymentMethod"]{
                if(PaymentMethod as! String == "PAS" || PaymentMethod as! String == "Pod"){
                    btnPAS.isSelected = true;
                    btnOnline.isSelected = false;
                }
                else{
                    btnPAS.isSelected = false;
                    btnOnline.isSelected = true;
                }
            }
        }
        
    }
    
    @IBAction func btnContinue_Click(){
        //MyOrderController.CreateOrder(vc: self, orderInfo: Constant.OrderDic!)
        if(btnPAS.isSelected == true){
             ExtendedOrderPayment(transactionID: "PAS")
        }
        else{
            let controller = storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
            controller.totalAmount = lblTotal.text!
            controller.del = self;
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func GetTransactionId(transactionID: String, status: Bool) {
        if(transactionID.count != 0){
            if(status == true){
                Helper.ShowAlertMessage(message:"Payment Done Successfully." , vc: self,title:"",bannerStyle: BannerStyle.success)
                ExtendedOrderPayment(transactionID: transactionID)
                //self.popPushToVC(ofKind:  ContainerViewController.self, pushController: self)
            }
            else{
                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }
    }
    
    func ExtendedOrderPayment(transactionID:String){
        var QueryInfo:[String:AnyObject] = [String:AnyObject]()
        QueryInfo["ExtTransaction_id"] = transactionID as AnyObject;
        QueryInfo["ExtPayMentStatus"] = 2 as AnyObject;
        if(btnOnline.isSelected){
            QueryInfo["ExtPayMentMethod"] = "ONLINE" as AnyObject;
        }
        else{
            QueryInfo["ExtPayMentMethod"] = "PAS" as AnyObject;
        }
        if let ExtId = dicOrder["ExtId"]{
            QueryInfo["ExtId"] = (ExtId as! String) as AnyObject;
        }
        if let ExtPayMentStatus = dicOrder["ExtPayMentStatus"]{
            QueryInfo["ExtPayMentStatus"] = (ExtPayMentStatus as! String) as AnyObject;
        }
        if let ExtOrderId = dicOrder["ExtOrderId"]{
            QueryInfo["ExtOrderId"] = (ExtOrderId as! String) as AnyObject;
        }
        MyOrderController.ExtendedOrderPayment(vc: self, orderInfo: QueryInfo)
    }
    
}
