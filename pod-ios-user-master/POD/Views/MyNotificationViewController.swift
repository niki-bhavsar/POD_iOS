//
//  MyNotificationViewController.swift
//  POD
//
//  Created by Apple on 12/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyNotificationViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    public let refreshControl = UIRefreshControl()
    @IBOutlet var tblOrder:UITableView!
    @IBOutlet var btnDeleteAll:UIButton!

    let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tblOrder.rowHeight = UITableView.automaticDimension
        self.tblOrder.estimatedRowHeight = 60
        self.tblOrder.reloadData();
        if #available(iOS 10.0, *) {
            tblOrder.refreshControl = refreshControl
        } else {
            tblOrder.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
        // Fetch Weather Data
//        if let Id = userInfo!["Id"]{
        MyOrderController.GetNotificatins(userId: account.user_id, vc: self);
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let Id = userInfo!["Id"]{
        MyOrderController.GetNotificatins(userId: account.user_id, vc: self);
//        }
    }
    
}

extension MyNotificationViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(MyOrderController.listNotification != nil){
            if(MyOrderController.listNotification!.count>0){
                tableView.restore()
                btnDeleteAll.isHidden = false
            }
            else{
                tableView.setEmptyMessage("No Notification Found")
                btnDeleteAll.isHidden = true
            }
            return MyOrderController.listNotification!.count
        }
        else{
            tableView.setEmptyMessage("No Notification Found")
            btnDeleteAll.isHidden = true
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell
        cell.vc = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let orderOBj = MyOrderController.listNotification?[indexPath.row]
        if let title = orderOBj!["Title"]{
            cell.lblContent?.text = "\(title as! String)";
        }
        if let EntDt = orderOBj!["EntDt"]{
            
            cell.lblDate!.text = Helper.ConvertDateToTime(dateStr: (EntDt as! String),timeFormat: "yyyy-MM-dd HH:mm:ss")
        }
        cell.setNeedsUpdateConstraints();
        cell.updateConstraintsIfNeeded();
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderOBj = MyOrderController.listNotification?[indexPath.row]
        if let generalId = orderOBj!["generalId"]{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
            controller.orderID = generalId as? String
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @IBAction func btnDeleteAll(sender:UIButton){
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        if #available(iOS 13.0, *) {
            deleteAlert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//            if let Id = self.userInfo!["Id"]{
            MyOrderController.DeleteAllNotificatins(userId: self.account.user_id, vc: self)
//            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(deleteAlert, animated: true, completion: nil)
    }
}
