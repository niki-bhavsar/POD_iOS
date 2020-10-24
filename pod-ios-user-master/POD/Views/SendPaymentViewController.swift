//
//  SendPaymentViewController.swift
//  POD
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class SendPaymentViewController: BaseViewController, OnlinePaymentProtocal, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var lblRedeemPoint: UILabel!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet var lblOrderID:UILabel!
    @IBOutlet var lblDate:UILabel!
    //    @IBOutlet var lblStartDate:UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet var lblStartTime:UILabel!
    //    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblAmount:UILabel!
    @IBOutlet var lblVisiting:UILabel!
    @IBOutlet var lblTotal:UILabel!
    public var dicInfo  = [String:Any]()
    @IBOutlet weak var btnPayment: UIButton!
    
    let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetData()
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    
    func SetData(){
        if(dicInfo != nil){
            
            if let PaymentStatus : String = dicInfo["PaymentStatus"] as? String{
                if(PaymentStatus != "1"){
                    btnPayment.isHidden = false
                }else {
                    btnPayment.isHidden = true
                }
            }
            btnDownloadInvoice.isHidden = true
            if let invoiceFile = dicInfo["InVoiceFile"]{
                if((invoiceFile as AnyObject).length == 0){
                    btnDownloadInvoice.isHidden = true
                    
                } else{
                    btnDownloadInvoice.isHidden = false
                }
            }
            
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
            var transVal : Double = 0.0
            
            if let SubTotal : String = dicInfo["SubTotal"] as? String{
                lblAmount.text = SubTotal
                subTotalVal = Double(SubTotal) ?? 0.0
            }
            
            if let Total : String = dicInfo["Total"] as? String {
                totlaVal = Double(Total) ?? 0.0
                self.lblTotal.text = String(format: "%.2f", totlaVal)
            }
            
            if let RedeemPoint : String = dicInfo["RedeemPoint"] as? String {
                self.lblRedeemPoint.text = "-\(RedeemPoint)"
            }
            
            if let trasportation : String = dicInfo["Transportation"] as? String{
                self.lblVisiting.text = "\(trasportation)"
                transVal = Double(trasportation) ?? 0.0
            }
            
            if let GST : String = dicInfo["GST"] as? String {
                let GSTVal : Double = Double(GST) ?? 0.0
                
                lblCGST.text = String(format: "%.2f", GSTVal / 2)
                lblSGST.text = String(format: "%.2f", GSTVal / 2)
                
            }
            
            
            //            let cGST : Double = (totlaVal - subTotalVal - transVal) / 2
            //            let sGST : Double = (totlaVal - subTotalVal - transVal) / 2
            //
            //            lblCGST.text = String(format: "%.2f", cGST)
            //            lblSGST.text = String(format: "%.2f", sGST)
            
        }
    }
    
    @IBAction func downloadInvoiceClicked(_ sender: Any) {
        self.showSpinner()
        let invoiceFile : String = dicInfo["InVoiceFile"] as! String
        
        let url = URL(string:invoiceFile)
        downloadTask = backgroundSession.downloadTask(with: url!)
        downloadTask.resume()
    }
    
    @IBAction func btnPayClick(){
        Constant.OrderDic = [String:Any]()
        Constant.OrderDic["Name"] =  dicInfo["Name"]
        Constant.OrderDic["Email"] =  dicInfo["Email"]
        
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as! OnlinePaymentViewController
        controller.totalAmount =  lblTotal.text!
        controller.del = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func GetTransactionId(transactionID: String, status: Bool) {
        if(transactionID.count != 0){
            if(status == true){
                SubmitPaymentRequest(transactionID: transactionID)
                //                Constant.OrderDic = [String : Any]()
                //                Constant.OrderDic["OrderId"] = dicInfo["Id"]
                //                Constant.OrderDic["Transaction_id"] = transactionID
                //                Constant.OrderDic["PaymentStatus"] = "1"
                //                orderPaid()
            }
            else{
                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }
    }
    
    
    //    func orderPaid(){
    //        startAnimating()
    //
    //        ApiManager.sharedInstance.requestPOSTURL(Constant.updatePaymentStatusURL, params: Constant.OrderDic, success: {
    //            (JSON) in
    //            let msg =  JSON.dictionary?["Message"]
    //            if((JSON.dictionary?["IsSuccess"]) != false){
    //                let callActionHandler = { () -> Void in
    //                    self.navigationController?.popViewController(animated: true)
    //                }
    //                Helper.ShowAlertMessageWithHandlesr(message:"Payment has been done successfully.",title:"" ,vc: self,action:callActionHandler)
    //            }
    //            else{
    //                Helper.ShowAlertMessage(message: msg!.description, vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
    //            }
    //            self.stopAnimating()
    //        }, failure: { (Error) in
    //            self.stopAnimating()
    //            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
    //        })
    //    }
    
    func SubmitPaymentRequest(transactionID:String){
        var dic = [String:Any]()
        dic["OrderId"] = dicInfo["Id"]
        dic["TransactionId"] = transactionID
        dic["ExtId"] = dicInfo["ExtId"]
        dic["CustomerId"] = dicInfo["CustomerId"]
        MyOrderController.PASUserOrderPayment(vc: self, orderInfo: dic);
    }
    
    
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
