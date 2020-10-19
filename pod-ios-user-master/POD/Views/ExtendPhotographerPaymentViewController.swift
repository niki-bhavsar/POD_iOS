//
//  ExtendPhotographerPaymentViewController.swift
//  POD
//
//  Created by Apple on 09/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ExtendPhotographerPaymentViewController: BaseViewController, OnlinePaymentProtocal, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var lblRedeemPoints: UILabel!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet var lblOrderID:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblStartTime:UILabel!
    //    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblcategory:UILabel!
    @IBOutlet var lblVisiting:UILabel!
    @IBOutlet var lblTotal:UILabel!
    //    @IBOutlet var lblExtendedTime:UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet var lblShootingAmount:UILabel!
    @IBOutlet var lblExtShootingAmount:UILabel!
    public var dicOrder = [String:Any]()
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    @IBOutlet weak var btnPayment: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
        //        var shootingamt:Double = 0.0
        //        var extamt:Double = 0.0
        
        if(dicOrder != nil){
            
            if let PaymentStatus : String = dicOrder["PaymentStatus"] as? String{
                if(PaymentStatus != "1"){
                    btnPayment.isHidden = false
                }else {
                    btnPayment.isHidden = true
                }
            }
            
            if let invoiceFile = dicOrder["InVoiceFile"]{
                if((invoiceFile as AnyObject).length == 0){
                    btnDownloadInvoice.isHidden = true
                    
                } else{
                    btnDownloadInvoice.isHidden = false
                }
            }
            
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
            var transVal : Double = 0.0
            
            if let SubTotal : String = dicOrder["SubTotal"] as? String{
                lblShootingAmount.text = SubTotal
                subTotalVal = Double(SubTotal) ?? 0.0
            }
            
            if let productPrice : String = dicOrder["ProductPrice"] as? String{
                let prodPrice : Int = Int(productPrice) ?? 0
                let extHours : String = dicOrder["ExtHours"] as! String
                let extHoursInt : Int = Int(extHours) ?? 0
                
                lblExtShootingAmount.text = "\(prodPrice * extHoursInt)"
                extendedVal = Double(prodPrice * extHoursInt)
            }
            
            if let trasportation : String = dicOrder["Transportation"] as? String{
                lblVisiting.text = trasportation
                transVal = Double(trasportation) ?? 0.0
            }
            
            if let totalStr : String = dicOrder["Total"] as? String{
                let extAMTStr : String = dicOrder["ExtAmount"] as! String
                let extAMT : Double = Double(extAMTStr) ?? 0.0
                
                let total : Double = Double(totalStr) ?? 0.0
                lblTotal.text = String(format: "%.2f", total + extAMT)
                totlaVal = total + extAMT
            }
            
            
            if let RedeemPoint : String = dicOrder["RedeemPoint"] as? String {
                self.lblRedeemPoints.text = RedeemPoint
            }
            
            if let GST : String = dicOrder["GST"] as? String {
                          let GSTVal : Double = Double(GST) ?? 0.0
                          
                          lblCGST.text = String(format: "%.2f", GSTVal / 2)
                          lblSGST.text = String(format: "%.2f", GSTVal / 2)
                          
                      }
            
//            var gstVal : Double = 0.0
//            gstVal = subTotalVal + extendedVal + transVal
//
//            let cGST : Double = (totlaVal - gstVal) / 2
//            let sGST : Double = (totlaVal - gstVal) / 2
//
//            lblCGST.text = String(format: "%.2f", cGST)
//
//            lblSGST.text = String(format: "%.2f", sGST)
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadInvoiceClicked(_ sender: Any) {
        self.showSpinner()
        let invoiceFile : String = dicOrder["InVoiceFile"] as! String
        
        let url = URL(string:invoiceFile)
        downloadTask = backgroundSession.downloadTask(with: url!)
        downloadTask.resume()
    }
    
    @IBAction func btnPayClick(){
        
        Constant.OrderDic = [String:Any]()
        Constant.OrderDic["Name"] =  dicOrder["Name"]
        Constant.OrderDic["Email"] =  dicOrder["Email"]
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
        controller.totalAmount =  lblTotal.text!
        controller.del = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func GetTransactionId(transactionID: String, status: Bool) {
        if(transactionID.count != 0){
            if(status == true){
                Constant.OrderDic = [String : Any]()
                Constant.OrderDic["OrderId"] = dicOrder["Id"]
                Constant.OrderDic["Transaction_id"] = transactionID
                Constant.OrderDic["PaymentStatus"] = "1"
                orderPaid()
            }
            else{
                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }
    }
    
    func orderPaid(){
        startAnimating()
        
        ApiManager.sharedInstance.requestPOSTURL(Constant.updatePaymentStatusURL, params: Constant.OrderDic, success: {
            (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                let callActionHandler = { () -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                Helper.ShowAlertMessageWithHandlesr(message:"Payment has been done successfully.",title:"" ,vc: self,action:callActionHandler)
            }
            else{
                Helper.ShowAlertMessage(message: msg!.description, vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
            self.stopAnimating()
        }, failure: { (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        })
    }
    
    
    //    func SubmitPhotographerPaymentRequest(transactionID:String){
    //        var dic = [String:Any]()
    //        dic["OrderId"] = dicOrder["ExtOrderId"]
    //        dic["TransactionId"] = transactionID
    //        dic["ExtId"] = dicOrder["ExtId"]
    //        dic["CustomerId"] = dicOrder["ExtCustomerId"]
    //        MyOrderController.ExtendedRemainPhotoGrapherOrderPayment(vc: self, orderInfo: dic);
    //    }
    
    //MARK: URLSessionDownloadDelegate
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                Helper.ShowAlertMessage(message:"An error occurred while moving file to destination url" , vc: self,title:"Error",bannerStyle: BannerStyle.danger)
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        self.removeSpinner()
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            Helper.ShowAlertMessage(message:"File downloaded successfully." , vc: self,title:"Success",bannerStyle: BannerStyle.success)
            print("The task finished transferring data successfully")
        }
        self.removeSpinner()
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
    
}
