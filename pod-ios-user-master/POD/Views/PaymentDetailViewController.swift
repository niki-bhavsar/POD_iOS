//
//  PaymentDetailViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit
import NotificationBannerSwift
class PaymentDetailViewController: BaseViewController, OnlinePaymentProtocal {

    @IBOutlet var btnPAS:UIButton!
    @IBOutlet var btnOnline:UIButton!
    @IBOutlet var mapView:MKMapView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblVisitingCost: UILabel!
    @IBOutlet weak var lblShootCost: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            //Fallback on earlier versions
        }
        self.btnPAS.isSelected = true;
        lblCategory.text = Constant.FirstSubcategory+","+Constant.AllSubcategory;
        SetLocationOnMap()
    }
    
    func SetLocationOnMap(){
        
        btnPAS.isSelected = true
        Constant.OrderDic!["PaymentMethod"] = "PAS"
        Constant.OrderDic!["PaymentStatus"] = "2"
        let annotation = MKPointAnnotation()
           annotation.title = title
           annotation.coordinate = CLLocationCoordinate2DMake(Double(Constant.OrderDic!["ShootingLat"]! as! String)! , Double(Constant.OrderDic!["ShootingLng"]! as! String)!)
           
            mapView!.addAnnotation(annotation)
        mapView?.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2DMake(Double(Constant.OrderDic!["ShootingLat"]! as! String)! , Double(Constant.OrderDic!["ShootingLng"]! as! String)!), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        MyOrderController.GetTransportationCharges(lat: (Constant.OrderDic!["ShootingLat"]! as! String), lng: (Constant.OrderDic!["ShootingLng"]! as! String), vc: self)
       
        if let category = Constant.SelectedCategory!["Title"]
        {
            Constant.OrderDic!["ProductTitle"] = category
        }
        
        if let ProductPrice = Constant.SelectedCategory!["Price"]
        {
            Constant.OrderDic!["ProductPrice"] = ProductPrice
            
        }
        Constant.OrderDic!["ProductTitles"] = ((Constant.FirstSubcategory)+","+(Constant.AllSubcategory ))
    }
    
    @IBAction func btnPaymentMethod_Clic(sender:UIButton){
        btnPAS.isSelected = false;
        btnOnline.isSelected = false;
        sender.isSelected = true;
        if(btnPAS.isSelected == true){
            Constant.OrderDic!["PaymentMethod"] = "PAS"
            Constant.OrderDic!["PaymentStatus"] = "2"
        }
        else{
            Constant.OrderDic!["PaymentMethod"] = "Online"
            Constant.OrderDic!["PaymentStatus"] = "1"
        }
    }
    
    @IBAction func btnContinue_Click(){
        //MyOrderController.CreateOrder(vc: self, orderInfo: Constant.OrderDic!)
        if(btnPAS.isSelected == true){
            MyOrderController.CreateOrder(vc: self, orderInfo: Constant.OrderDic!)
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
                Constant.OrderDic!["Transaction_id"] = transactionID 
                MyOrderController.CreateOrder(vc: self, orderInfo: Constant.OrderDic!)
            }
            else{
                Helper.ShowAlertMessage(message:"Transaction Failed-(\(transactionID))" , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }
    }

}
