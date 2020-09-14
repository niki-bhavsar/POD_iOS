//
//  ExtendViewController.swift
//  POD
//
//  Created by Apple on 24/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ExtendViewController: BaseViewController {

    @IBOutlet var lblexthrours:UILabel!
    @IBOutlet var lblExtAmount:UILabel!
    public var OrderInfo:[String:AnyObject]?
    var vc:OrderDetailViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        lblExtAmount.text = "Total Extended Amount: 0";
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose_Click(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPlus(){
        var currentValue = Int(lblexthrours.text!)
        currentValue = currentValue!+1;
        lblexthrours.text = currentValue?.description
        let p = Double(OrderInfo!["ProductPrice"] as! String)!
        let h = Double(lblexthrours.text as! String)!
        let price = (p*h)
        lblExtAmount.text = "Total Extended Amount:\(price.description)";
    }
    
    @IBAction func btnMinus(){
           var currentValue = Int(lblexthrours.text!)
        if(currentValue!>0){
        currentValue = currentValue!-1;
           lblexthrours.text = currentValue?.description
        }
        let p = Double(OrderInfo!["ProductPrice"] as! String)!
        let h = Double(lblexthrours.text as! String)!
        let price = (p*h)
        let gstPrice = (price*18)/100;
        let priceWIthGST = price+gstPrice;
        lblExtAmount.text = "Total Extended Amount:\(priceWIthGST.description)";
    }
    
    @IBAction func btnExtend_CLick(){
        
        var extendIndfo = [String:AnyObject]()
        if let ExtOrderId = OrderInfo!["Id"]{
            extendIndfo["ExtOrderId"] = ExtOrderId
        }
        if let ExtPhotographerId = OrderInfo!["PhotographerId"]{
            extendIndfo["ExtPhotographerId"] = ExtPhotographerId
        }
        if let ExtCustomerId = OrderInfo!["CustomerId"]{
            extendIndfo["ExtCustomerId"] = ExtCustomerId
        }
        if let ExtName = OrderInfo!["Name"]{
            extendIndfo["ExtName"] = ExtName
        }
        if let ExtEmail = OrderInfo!["Email"]{
            extendIndfo["ExtEmail"] = ExtEmail
        }
        if let ExtOrderTitle = OrderInfo!["ProductTitle"]{
            extendIndfo["ExtOrderTitle"] = ExtOrderTitle
        }
        if let ExtAddress = OrderInfo!["ShootingAddress"]{
            extendIndfo["ExtAddress"] = ExtAddress
        }
        if let ExtDate = OrderInfo!["ShootingDate"]{
            extendIndfo["ExtDate"] = ExtDate
        }
        if let ExtStartTime = OrderInfo!["ShotingStartTime"]{
            extendIndfo["ExtStartTime"] = ExtStartTime
        }
        if let ExtHours = lblexthrours.text {
            extendIndfo["ExtHours"] = ExtHours as AnyObject
        }
        
        extendIndfo["ExtReqFlg"] = "Yes" as AnyObject
        extendIndfo["ExtGST"] = "0" as AnyObject
        
        if let ExtAmount = OrderInfo!["ProductPrice"]{
            
            let p = Double(ExtAmount as! String)!
            let h = Double(lblexthrours.text as! String)!
            let price = (p*h)
            let gstPrice = (price*18)/100;
            let priceWIthGST = price+gstPrice;
            extendIndfo["ExtGST"] = gstPrice as AnyObject;
            extendIndfo["ExtAmount"] = priceWIthGST as AnyObject
        }
        
        MyOrderController.ExtendOrder(vc: self, orderInfo: extendIndfo)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
