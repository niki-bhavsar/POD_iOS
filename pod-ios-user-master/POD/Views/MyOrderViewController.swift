//
//  MyOrderViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyOrderViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var btnUpcoming:UIButton!
    @IBOutlet var btnComplete:UIButton!
    public let refreshControl = UIRefreshControl()
    @IBOutlet var tblOrder:UITableView!
    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnUpcoming.isSelected = true;
        self.btnComplete.isSelected = false;
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tblOrder.reloadData();
        if #available(iOS 10.0, *) {
            tblOrder.refreshControl = refreshControl
        } else {
            tblOrder.addSubview(refreshControl)
        }
        self.SetStatusBarColor()
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
        if let Id = userInfo!["Id"]{
                   MyOrderController.GetOrders(userId: Id as! String, vc: self);
        }
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
        // Fetch Weather Data
        if let Id = userInfo!["Id"]{
            MyOrderController.GetOrders(userId: Id as! String, vc: self);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    @IBAction func TabAction(sender:UIButton){
        self.btnUpcoming.isSelected = false;
        self.btnComplete.isSelected = false;
        if(sender == btnUpcoming){
            MyOrderController.FilterData(index: 1);
        }
        else{
            MyOrderController.FilterData(index: 2);
        }
        sender.isSelected = true;
        self.tblOrder.reloadData()
    }
  
}

extension MyOrderViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(MyOrderController.listTempOrders != nil){
            if(MyOrderController.listTempOrders!.count>0){
                tableView.restore()
            }
            else{
                tableView.setEmptyMessage("No Booking Found")
            }
            return MyOrderController.listTempOrders!.count
        }
        else{
            tableView.setEmptyMessage("No Booking Found")
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let orderOBj = MyOrderController.listTempOrders?[indexPath.row]
        if let OrderNo = orderOBj!["OrderNo"]{
            cell.lblOrderNo?.text = "Order id: \(OrderNo as! String)";
        }
        if let ShootingDate = orderOBj!["ShootingDate"]{
            cell.lblOrderDate!.text = "Order Date: \(ShootingDate as! String)"
        }
        if let ShootingStartTime = orderOBj!["ShootingStartTime"]{
            
            cell.lblOrderTime!.text = "Order Time: \(ShootingStartTime)"//"Order Time: \(Helper.ConvertDateToTime(dateStr: (EntDt as! String),timeFormat: "HH:mm:ss"))"
        }
        if let AMount = orderOBj!["Total"]{
            cell.lblOrderPayment?.text = (AMount as! String)
        }
        if let PaymentMethod = orderOBj!["PaymentMethod"]{
            var method = (cell.lblOrderPayment?.text ?? "")
            method = "Payment: \(method) (\(PaymentMethod as! String))"
            cell.lblOrderPayment?.text = method;
        }
        if let Status = orderOBj!["Status"]{
            cell.lblStatus?.text = Helper.GetOrderStatusName(index: Int(Status as! String)!);
            if(Status as! String == "1"){
                cell.lblStatus!.textColor = UIColor.init(hexString: "#FBAF40")
            }
            else if(Status as! String == "2" || Status as! String == "3" || Status as! String == "5" || Status as! String == "6"){
                cell.lblStatus!.textColor = UIColor.init(hexString: "#81C283")
            }
            else if(Status as! String == "4"){
                cell.lblStatus!.textColor = UIColor.init(hexString: "#F86A6A")
            }
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderOBj = MyOrderController.listTempOrders?[indexPath.row]
        if let OrderId = orderOBj!["Id"]{
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
            controller.orderID = OrderId as! String;
               Helper.rootNavigation?.pushViewController(controller, animated: true)
        }
    }
}
