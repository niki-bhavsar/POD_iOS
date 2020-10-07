//
//  OrderDetailTableViewCell.swift
//  POD
//
//  Created by Apple on 25/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

//protocol OrderDetailDelegate{
//    func ExtendButtonTapped(at index:IndexPath,sender:UIButton)
//    func ViewReceiptTapped(total:String,visit:String,method:String,amount:String,extAmount:String,extMethod:String)
//    func HelpTapped(at index:IndexPath)
//}

class OrderDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var btnGetHelp: UIButton!
    
    @IBOutlet weak var btnViewReceipt: UIButton!
    @IBOutlet public var lblOrderNo:UILabel!
    @IBOutlet public var lblOrderDate:UILabel!
    @IBOutlet public var lblOrderTime:UILabel!
    @IBOutlet public var lblShootDate:UILabel!
    @IBOutlet public var lblStatus:UILabel!
    @IBOutlet public var lblStartTime:UILabel!
    @IBOutlet public var lblEndTime:UILabel!
    @IBOutlet public var lblTotalHrs:UILabel!
    @IBOutlet public var lblAssitantID:UILabel!
    @IBOutlet public var btnExtend:UIButton!
    @IBOutlet public var txtAdd:UITextView!
    @IBOutlet public var lblAmount:UILabel!
    @IBOutlet public var lblPayment:UILabel!
    @IBOutlet public var lblRemainingTime:UILabel!
    //    @IBOutlet public var heightConstraing:NSLayoutConstraint!
    @IBOutlet public var TimeheightConstraing:NSLayoutConstraint!
    @IBOutlet public var SendDetailHeightConstraing:NSLayoutConstraint!
    @IBOutlet public var widthExtend:NSLayoutConstraint!
    @IBOutlet weak var addHeightConstraing: NSLayoutConstraint!
    
    //    @IBOutlet public var heightConentView:NSLayoutConstraint!
    @IBOutlet public var btnChat:UIButton!
    @IBOutlet public var btnSend:UIButton!
    @IBOutlet public var lblPhotographerSatus:UILabel!
    @IBOutlet public var lblExtTime:UILabel!
    @IBOutlet public var lblExtHrs:UILabel!
    @IBOutlet public var ExtTimeHeightConstraing:NSLayoutConstraint!
    @IBOutlet public var ExthrsheightConentView:NSLayoutConstraint!
    //    @IBOutlet public var viewInside:UIView!
    
    //    var indexPath:IndexPath!
    //    var delegate:OrderDetailDelegate!
    var total:String?
    var amount:String?
    var visit:String?
    var paymentMehod:String?
    var ExtpaymentMehod:String?
    var extAmount:String?
    var dicObj = [String:Any]()
    public var vc:OrderDetailViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func SetData(dic:[String:Any]){
        dicObj = dic;
        vc!.orderInfoDetail = dic
        self.SetOrderDetailData(dic: dic)
    }
    
    @IBAction func btnViewReceipt_Click(){
        //        delegate.ViewReceiptTapped(total: self.total!, visit: self.visit!, method: self.paymentMehod!, amount: self.amount!, extAmount: self.extAmount!,extMethod: self.ExtpaymentMehod!)
    }
    
    //    @IBAction func btnSend_Click(){
    //        if let photographFile = dicObj["photographFile"]{
    //            if((photographFile as AnyObject).length == 0){
    //                Constant.OrderDic = [String:Any]()
    //                Constant.OrderDic["Name"] =  dicObj["Name"]
    //                Constant.OrderDic["Email"] =  dicObj["Email"]
    //                let controller = self.vc?.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
    //                controller.totalAmount = "199"
    //                controller.del = self
    //                self.vc?.navigationController!.pushViewController(controller, animated: true)
    //            }
    //            else{
    //                let url = NSURL(string: photographFile as! String)!
    //                UIApplication.shared.openURL(url as URL)
    //            }
    //        }
    //    }
    
    //    @IBAction func btnChatClick(sender:UIButton){
    //        let dicObj = MyOrderController.listOrderDetails![indexPath.row]
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
    //        controller.dicObj = dicObj as [String : AnyObject];
    //        vc!.navigationController?.pushViewController(controller, animated: true)
    //    }
    
    
    //    @IBAction func btnGetHelp_Click(){
    ////        delegate.HelpTapped(at: indexPath)
    //    }
    //
    //    @IBAction func btnExtend_Click(sender:UIButton){
    ////        delegate.ExtendButtonTapped(at: indexPath, sender: sender)
    //    }
    
    
    
    func SetOrderDetailData(dic:[String:Any]){
        self.widthExtend.constant = 0
        self.SendDetailHeightConstraing.constant = 0
        self.ExthrsheightConentView.constant = 0
        self.ExtTimeHeightConstraing.constant = 0
        
        self.btnSend.isHidden = true;
        if let OrderNo = dic["OrderNo"]{
            self.lblOrderNo.text = "OrderId: \(OrderNo)"
            self.lblOrderNo.halfTextColorChange(fullText: self.lblOrderNo.text!, changeText: OrderNo as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        if let ShootingDate = dic["ShootingDate"]{
            self.lblOrderDate.text = "Order Date:  \(ShootingDate)"
            self.lblShootDate.text = "Shoot Date:  \(ShootingDate)"
            self.lblOrderDate.halfTextColorChange(fullText: self.lblOrderDate.text!, changeText: ShootingDate as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            self.lblShootDate.halfTextColorChange(fullText: self.lblShootDate.text!, changeText: ShootingDate as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        if let EntDt = dic["EntDt"]{
            
            self.lblOrderTime!.text = "Order Time:  \(Helper.ConvertDateToTime(dateStr: EntDt as! String,timeFormat: "HH:mm:ss"))"
            self.lblOrderTime.halfTextColorChange(fullText: self.lblOrderTime.text!, changeText: (Helper.ConvertDateToTime(dateStr: EntDt as! String,timeFormat: "HH:mm:ss")), color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        if let ShotingStartTime = dic["ShootingStartTime"]{
            
            self.lblStartTime!.text = "Start Time:  \(Helper.ConvertDateToTime(dateStr: ShotingStartTime as! String,timeFormat: "HH:mm"))"
            self.lblStartTime.halfTextColorChange(fullText: self.lblStartTime.text!, changeText: (Helper.ConvertDateToTime(dateStr: ShotingStartTime as! String,timeFormat: "HH:mm")), color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            let remainingTime = Helper.TimeDifference(dateStr: "\(dic["ShootingDate"] as! String) \(ShotingStartTime):00", timeFormat: "yyyy-MM-dd HH:mm:ss")
            self.lblRemainingTime.text = "Remaining Time:\(remainingTime)"
            
        }
        if let ShotingeEndTime = dic["ShootingEndTime"]{
            
            self.lblEndTime!.text = "End Time:  \(Helper.ConvertDateToTime(dateStr: ShotingeEndTime as! String,timeFormat: "HH:mm"))"
            self.lblEndTime.halfTextColorChange(fullText: self.lblEndTime.text!, changeText: (Helper.ConvertDateToTime(dateStr: ShotingeEndTime as! String,timeFormat: "HH:mm")), color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        if let Total = dic["Total"]{
            
            //            let p = Double(dic["ProductPrice"] as! String)!
            //            let h = Double(dic["ShootingHours"] as! String)!
            let e = Double(dic["ExtAmount"] as! String)!
            //            let v = Double(dic["Transportation"] as! String)!
            //            let finalAMount = ((p*h)+e+v);
            //let gst = (((p*h)*18)/100)
            var pricewithgst = Double(Total as! String)!
            pricewithgst = pricewithgst+e
            self.lblAmount!.text = "Amount:   \(String(format: "%.2f", pricewithgst as CVarArg))"
            self.lblAmount.halfTextColorChange(fullText: self.lblAmount.text!, changeText: pricewithgst.description , color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            self.total = "Total:   \(String(format: "%.2f", pricewithgst as CVarArg))"
        }
        
        if let PaymentMethod = dic["PaymentMethod"]{
            
            self.lblPayment!.text = "Payment:   \(PaymentMethod)"
            self.lblPayment.halfTextColorChange(fullText: self.lblPayment.text!, changeText: PaymentMethod as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            self.paymentMehod = "Payment Method:   \(PaymentMethod)"
            
        }
        
        if let ExtPaymentMethod = dic["ExtPayMentMethod"]{
            if((ExtPaymentMethod as! String) !=  "0"){
                self.ExtpaymentMehod = "Payment Extended Method:   \(ExtPaymentMethod)"
            }
            else{
                self.ExtpaymentMehod = "Payment Extended Method:  "
            }
        }
        
        if let ShootingAddress = dic["ShootingAddress"]{
            self.txtAdd!.text = (ShootingAddress as! String)
            
        }
        
        if let Status = dic["Status"]{
            let statusName = Helper.GetOrderDetailStatusName(index:Int(Status as! String)!)
            self.lblStatus.text = "Status:     \(statusName)"
            self.lblStatus.halfTextColorChange(fullText: self.lblStatus.text!, changeText: statusName, color: UIColor.init(red: 285/255, green: 185/255, blue: 59/255, alpha: 1))
            if(Status as! String == "5"){
                self.TimeheightConstraing.constant = 25;
                self.btnExtend.isHidden = false;
                self.widthExtend.constant = 57;
            }
            else{
                self.TimeheightConstraing.constant = 0;
                self.btnExtend.isHidden = true;
                self.widthExtend.constant = 0;
                //  self.btnExtend.setTitle("Pay", for: UIControl.State.normal)
            }
            if(Status as! String == "2" || Status as! String == "3" || Status as! String == "5" || Status as! String == "6"){
                
                self.lblStatus.halfTextColorChange(fullText: self.lblStatus.text!, changeText: statusName, color: UIColor.init(hexString: "#81C283"))
               
                
            }
            if(Status as! String == "1" || Status as! String == "6" || Status as! String == "4" || Status as! String == "5"){
                self.btnChat.isHidden = true
            } else{
                self.btnChat.isHidden = false
            }
        }
        
        if let ExtStatus = dic["ExtStatus"]{
            
            if(ExtStatus as! String == "2"){
                
                self.TimeheightConstraing.constant = 25;
                self.btnExtend.isHidden = false;
                self.btnExtend.setTitle("Pay", for: UIControl.State.normal)
                self.widthExtend.constant = 57;
            }
            if(ExtStatus as! String == "1" || ExtStatus as! String == "3"){
                self.btnExtend.isHidden = true;
                self.widthExtend.constant = 0;
            }
            
            let statusName = Helper.GetExtendOrderStatusName(index:Int(ExtStatus as! String)!)
            if((ExtStatus as! String) != "0"){
                
                self.lblStatus.text = "Status:  \(statusName)"
                self.lblStatus.halfTextColorChange(fullText: self.lblStatus.text!, changeText: statusName, color: UIColor.init(red: 285/255, green: 185/255, blue: 59/255, alpha: 1))
                
                vc?.isExtended = true;
            }
            else{
                vc?.isExtended = false;
            }
            if(ExtStatus as! String == "2" || ExtStatus as! String == "3" || ExtStatus as! String == "5" || ExtStatus as! String == "6" || ExtStatus as! String == "4"){
                self.lblStatus.halfTextColorChange(fullText: self.lblStatus.text!, changeText: statusName, color: UIColor.init(hexString: "#81C283"))
                if(ExtStatus as! String == "4"){
                    self.ExthrsheightConentView.constant = 25
                    
                    self.ExtTimeHeightConstraing.constant = 25
                    
                    if let ExxtEndTime = dic["ExtEndTime"]{
                        self.lblExtTime.text = "Ext End Time: \(ExxtEndTime)"
                    }
                    if let ExtHours = dic["ExtHours"]{
                        self.lblExtHrs.text = "Extented Hrs: \(ExtHours)"
                    }
                    self.TimeheightConstraing.constant = 25
                    self.btnExtend.isHidden = true
                }
            }
            if(dic["Status"] as! String == "6"){
                let statusName = Helper.GetOrderStatusName(index:Int(dic["Status"] as! String)!)
                self.lblStatus.text = "Status:     \(statusName)"
                self.lblStatus.halfTextColorChange(fullText: self.lblStatus.text!, changeText: statusName, color: UIColor.init(hexString: "#81C283"))
                self.btnChat.isHidden = true;
            }
        }
        
        if let ShootingHours = dic["ShootingHours"]{
            
            self.lblTotalHrs!.text = "Total Hrs :      \(ShootingHours)"
            self.lblTotalHrs.halfTextColorChange(fullText: self.lblTotalHrs.text!, changeText: ShootingHours as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
            let p = Double(dic["ProductPrice"] as! String)!
            let h = Double(ShootingHours as! String)!
            let e = Double(dic["ExtAmount"] as! String)!
            let price = ((p*h))
            //let gst = ((price*18)/100)
            //var pricewithgst = Double(price)+gst
            self.amount = "Amount: \(price.description)"
            self.visit =  "Visiting + Transportation Charge: \((dic["Transportation"] as! String))"
            self.extAmount = "Extended Amount: \((dic["ExtAmount"] as! String))"
            
        }
        
        if let PhotographerId = dic["PhotographerId"]{
            
            self.lblAssitantID!.text = "Assitant Id:      #PODPH\(PhotographerId)"
            self.lblAssitantID.halfTextColorChange(fullText: self.lblAssitantID.text!, changeText: "#PODPH\(PhotographerId)" , color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        //        if let invoiceFile = dic["InVoiceFile"]{
        //            if((invoiceFile as AnyObject).length == 0){
        //                vc?.btnDownload.isHidden = true;
        //                vc?.btnExtPopupDownload.isHidden = true;
        //            } else{
        //                vc?.btnDownload.isHidden = false;
        //                vc?.btnExtPopupDownload.isHidden = false;
        //            }
        //        }
        
        
        
        if let pStatus = dic["pStatus"]{
            let statusName = Helper.GetPhotoGrapherStatusName(index:Int(pStatus as! String)!)
            self.lblPhotographerSatus.text = statusName
            self.lblPhotographerSatus.halfTextColorChange(fullText: statusName, changeText: statusName , color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            if(pStatus as! String == "6"){
                self.SendDetailHeightConstraing.constant = 250
                self.btnSend.isHidden = false
            }else{
                self.SendDetailHeightConstraing.constant = 0
                self.btnSend.isHidden = true
            }
        }
        
        if let photographFile = dicObj["photographFile"]{
            if((photographFile as AnyObject).length > 0){
                btnSend.setTitle(" Pay:  "+(photographFile as! String), for: UIControl.State.normal)
                btnSend.isHidden = false
                //                self.SendDetailHeightConstraing.constant = 250
            }else{
                btnSend.isHidden = true
                //                self.SendDetailHeightConstraing.constant = 0
            }
        }
        
        self.addHeightConstraing.constant = self.txtAdd.contentSize.height+10
        //self.heightConentView.constant =  self.heightConentView.constant+self.addHeightConstraing.constant
        //print(self.heightConentView.constant)
        
        //For testing
        //        self.btnExtend.setTitle("Pay", for: UIControl.State.normal)
        //        self.btnExtend.isHidden = false;
        //        self.widthExtend.constant = 57;
        //self.TimeheightConstraing.constant = 25;
    }
    
    //    ///
    //    func GetTransactionId(transactionID: String, status: Bool) {
    //        if(transactionID.count != 0){
    //            if(status == true){
    //                self.SubmitPhotographerRequest()
    //            }
    //            else{
    //                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: vc!,title:"Failed",bannerStyle: BannerStyle.danger)
    //            }
    //        }
    //    }
    //
    //    func SubmitPhotographerRequest(){
    //        var dic = [String:Any]()
    //        dic["OrderId"] = dicObj["Id"]
    //        dic["PaymentMethod"] = "Online"
    //        dic["PaymentStatus"] = "1"
    //        dic["Amount"] = "199"
    //        dic["CustomerId"] = dicObj["CustomerId"]
    //        //MyOrderController.photographOrderPayment(vc: vc!, orderInfo: dic);
    //    }
}
