//
//  OrderDetailViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class OrderDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {//, OnlinePaymentProtocal {//}, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet public var tblOrderDetails:UITableView!
    public var orderID = String()
    public var orderInfoDetail = [String:Any]()
    
    public let refreshControl = UIRefreshControl()
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    var isExtended:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrderDetail(_:)),
                                               name: NSNotification.Name("UpdateOrderDetailView"),
                                               object: nil)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            //Fallback on earlier versions
        }
        self.tblOrderDetails.reloadData();
        if #available(iOS 10.0, *) {
            tblOrderDetails.refreshControl = refreshControl
        } else {
            tblOrderDetails.addSubview(refreshControl)
        }
        
        tblOrderDetails.rowHeight = UITableView.automaticDimension
        tblOrderDetails.estimatedRowHeight = 730
        //        self.SetStatusBarColor()
        MyOrderController.GetOrderByorderId(orderId: orderID, vc: self)
        
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        
        //        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        //        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        
    }
    
    @objc func updateOrderDetail(_ notification: Notification) {
        
        let orderId : String = notification.object as! String//notification.userInfo as! String
        MyOrderController.GetOrderByorderId(orderId: orderId, vc: self)
        //        MyOrderController.GetOrderByorderId(orderId: orderId, vc: self)
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
        // Fetch Weather Data
        MyOrderController.GetOrderByorderId(orderId: orderID, vc: self)
    }
    
    //    @IBAction func btnViewReceipt_Click(){
    ////        self.viewPopup.isHidden = false
    //        if let invoiceFile = orderInfoDetail["InVoiceFile"]{
    //            if((invoiceFile as AnyObject).length == 0){
    //                btnDownload.isHidden = true;
    //                btnExtPopupDownload.isHidden = true;
    //            } else{
    //                btnDownload.isHidden = false;
    //                btnExtPopupDownload.isHidden = false;
    //            }
    //        }
    //
    //    }
    
    @IBAction func btnDownload_Click(){
        if(self.orderInfoDetail != nil){
            if let invoiceFile = self.orderInfoDetail["InVoiceFile"]{
                if((invoiceFile as AnyObject).length != 0){
                    self.showSpinner()
                    let url = URL(string: invoiceFile as! String)!
                    downloadTask = backgroundSession.downloadTask(with: url)
                    downloadTask.resume()
                }
                else{
                    //                     self.showSpinner(onView: self.view)
                    //                    let url = URL(string: "http://publications.gbdirect.co.uk/c_book/thecbook.pdf")!
                    //                    downloadTask = backgroundSession.downloadTask(with: url)
                    //                    downloadTask.resume()
                }
            }
        }
    }
    
    //    @IBAction func btnClose_Click(){
    ////        self.viewPopup.isHidden = true;
    ////        self.viewExtPopup.isHidden = true;
    //    }
    
    //    @IBAction func btnGetHelp_Click(){
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
    //        controller.orderDetail =  orderInfoDetail
    //        self.navigationController?.pushViewController(controller, animated: true)
    //    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //        guard  MyOrderController.listOrderDetails != nil else {
        //            return 0
        //        }
        //        return MyOrderController.listOrderDetails!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
        //        let dicObj = MyOrderController.listOrderDetails![indexPath.row] as [String: AnyObject]
        cell.vc = self
        cell.SetData(dic: orderInfoDetail)
        //        cell.indexPath = indexPath
        //        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.btnExtend.addTarget(self, action: #selector(extendClicked(sender:)), for: .touchUpInside)
        
        cell.btnGetHelp.addTarget(self, action: #selector(helpClicked(sender:)), for: .touchUpInside)
        
        cell.btnViewReceipt.addTarget(self, action: #selector(viewReceiptClicked(sender:)), for: .touchUpInside)
        
        cell.btnSend.addTarget(self, action: #selector(sendClicked(sender:)), for: .touchUpInside)
        
        cell.btnChat.addTarget(self, action: #selector(chatClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @IBAction func chatClicked(sender:UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.dicObj = orderInfoDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func sendClicked(sender:UIButton){
        if let photographFile : String = orderInfoDetail["photographFile"] as? String{
            if(photographFile.count == 0){
            } else{
                if let url = URL(string: photographFile) {
                    UIApplication.shared.open(url)
                } else {
                    Helper.ShowAlertMessage(message:"Can't open this url" , vc: self, title:"Failed", bannerStyle: BannerStyle.warning)
                }
            }
        }
    }
    
//    //    OnlinePaymentProtocal
//
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
//
//    func SubmitPhotographerRequest(){
//        var dic = [String:Any]()
//        dic["OrderId"] = orderInfoDetail["Id"]
//        dic["PaymentMethod"] = "Online"
//        dic["PaymentStatus"] = "1"
//        dic["Amount"] = "199"
//        dic["CustomerId"] = orderInfoDetail["CustomerId"]
//        //MyOrderController.photographOrderPayment(vc: vc!, orderInfo: dic);
//    }
    
    
    @IBAction func viewReceiptClicked(sender:UIButton){
        if(isExtended){
            //            self.viewPopup.isHidden = false;
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendPhotographerPaymentViewController") as! ExtendPhotographerPaymentViewController
            controller.dicOrder = orderInfoDetail
            self.navigationController!.pushViewController(controller, animated: true)
        } else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SendPaymentViewController") as! SendPaymentViewController
            controller.dicInfo = orderInfoDetail
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
    }
    
    @IBAction func helpClicked(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        controller.orderDetail =  orderInfoDetail
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func extendClicked(sender:UIButton){
        if(sender.titleLabel!.text == "Pay"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendOrderPaymentViewController") as! ExtendOrderPaymentViewController
            controller.dicOrder = orderInfoDetail
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendViewController") as! ExtendViewController
            controller.vc = self
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.OrderInfo = orderInfoDetail
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}

//extension OrderDetailViewController : OrderDetailDelegate{
//
//
//
//
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////         let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
////         let dicObj = MyOrderController.listOrderDetails![indexPath.row] as [String: AnyObject]
////        if let Status = dicObj["Status"]{
////            if(Status as! String == "6"){
////                 cell.SendDetailHeightConstraing.constant = 0
////                return 400;
////            }
////            else{
////                cell.SendDetailHeightConstraing.constant = 0
////                return 420;
////
////            }
////        }
////        else{
////             cell.SendDetailHeightConstraing.constant = 0
////            return 420;
////        }
////        return 420;
////    }
//
////    func ExtendButtonTapped(at index: IndexPath,sender:UIButton) {
////        if(sender.titleLabel!.text == "Pay"){
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendOrderPaymentViewController") as! ExtendOrderPaymentViewController
////            controller.dicOrder = MyOrderController.listOrderDetails![index.row] as [String : AnyObject]; self.navigationController?.pushViewController(controller, animated: true)
////        }
////        else{
////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendViewController") as! ExtendViewController
////            controller.vc = self;
////            controller.modalPresentationStyle = .overCurrentContext
////            controller.modalTransitionStyle = .crossDissolve
////            controller.OrderInfo = MyOrderController.listOrderDetails![index.row] as [String : Any]
////
////            self.present(controller, animated: true, completion: nil)
////        }
////    }
//
//
//    func HelpTapped(at index: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
//        controller.orderDetail =  MyOrderController.listOrderDetails![index.row] as [String : AnyObject]; self.navigationController?.pushViewController(controller, animated: true)
//    }
//
//
//    func ViewReceiptTapped(total: String, visit: String, method: String, amount: String, extAmount: String,extMethod: String) {
////        self.lblExtPopupVisit.text = visit;
////        self.lblPopupVisit.text = visit;
////        self.lblPopupTotal.text = total;
////        self.lblExtPopupTot.text = total;
////        self.lblPopupAmount.text = amount;
////        self.lblExtPopupAmt.text = amount;
////        self.lblPopupPayment.text = method;
////        self.lblExtPopupPay.text = method;
////        self.lblPopupExtPayment.text = extAmount;
////        self.lblPaymentExtendedMethod.text = extMethod;
//        if(isExtended){
//            //            self.viewPopup.isHidden = false;
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "ExtendPhotographerPaymentViewController") as! ExtendPhotographerPaymentViewController
//            controller.dicOrder = orderInfoDetail
//            self.navigationController!.pushViewController(controller, animated: true)
//        } else{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "SendPaymentViewController") as! SendPaymentViewController
//            controller.dicInfo = orderInfoDetail
//            self.navigationController!.pushViewController(controller, animated: true)
//
//            //            self.viewExtPopup.isHidden = false;
//        }
//    }
//
//    //MARK: URLSessionDownloadDelegate
//    func urlSession(_ session: URLSession,
//                    downloadTask: URLSessionDownloadTask,
//                    didFinishDownloadingTo location: URL){
//
//        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        let documentDirectoryPath:String = path[0]
//        let fileManager = FileManager()
//        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
//
//        if fileManager.fileExists(atPath: destinationURLForFile.path){
//            showFileWithPath(path: destinationURLForFile.path)
//        }
//        else{
//            do {
//                try fileManager.moveItem(at: location, to: destinationURLForFile)
//                // show file
//                showFileWithPath(path: destinationURLForFile.path)
//            }catch{
//                 Helper.ShowAlertMessage(message:"An error occurred while moving file to destination url" , vc: self,title:"Error",bannerStyle: BannerStyle.danger)
//            }
//        }
//    }
//    // 2
//    func urlSession(_ session: URLSession,
//                    downloadTask: URLSessionDownloadTask,
//                    didWriteData bytesWritten: Int64,
//                    totalBytesWritten: Int64,
//                    totalBytesExpectedToWrite: Int64){
//
//    }
//
//    func showFileWithPath(path: String){
//        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
//        if isFileFound == true{
//            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
//            viewer.delegate = self
//            viewer.presentPreview(animated: true)
//        }
//        self.removeSpinner()
//    }
//
//    //MARK: URLSessionTaskDelegate
//    func urlSession(_ session: URLSession,
//                    task: URLSessionTask,
//                    didCompleteWithError error: Error?){
//        downloadTask = nil
//        if (error != nil) {
//            print(error!.localizedDescription)
//        }else{
//            Helper.ShowAlertMessage(message:"File downloaded successfully." , vc: self,title:"Success",bannerStyle: BannerStyle.success)
//            print("The task finished transferring data successfully")
//        }
//        self.removeSpinner()
//    }
//
//    //MARK: UIDocumentInteractionControllerDelegate
//    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
//    {
//        return self
//    }
//
//
//}
