//
//  MyInquiryViewController.swift
//  POD
//
//  Created by Apple on 06/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyInquiryViewController:BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    public let refreshControl = UIRefreshControl()
    @IBOutlet var tblInquiry:UITableView!
    @IBOutlet var btnDeleteAll:UIButton!
    
    let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tblInquiry.rowHeight = UITableView.automaticDimension
        self.tblInquiry.estimatedRowHeight = 150
        self.tblInquiry.reloadData();
        if #available(iOS 10.0, *) {
            tblInquiry.refreshControl = refreshControl
        } else {
            tblInquiry.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
        // Fetch Weather Data
        //           if let Id = userInfo!["Id"]{
        InqueryController.GetAllInquiry(userId: account.user_id, vc: self);
        //           }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        if let Id = userInfo!["Id"]{
        InqueryController.GetAllInquiry(userId:account.user_id, vc: self);
        //        }
    }
    
    @IBAction func btnDeleteAll(sender:UIButton){
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        if #available(iOS 13.0, *) {
            deleteAlert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            InqueryController.DeleteAllInquiries(userId: self.account.user_id, vc: self)
            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
}

extension MyInquiryViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(InqueryController.listINquiry != nil){
            if(InqueryController.listINquiry!.count>0){
                tableView.restore()
                btnDeleteAll.isHidden = false
            }
            else{
                tableView.setEmptyMessage("No Inquiry Found")
                btnDeleteAll.isHidden = true
            }
            return InqueryController.listINquiry!.count
        }
        else{
            tableView.setEmptyMessage("No Inquiry Found")
            btnDeleteAll.isHidden = true
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyInquiryCell", for: indexPath) as! MyInquiryCell
        cell.vc = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let orderOBj = InqueryController.listINquiry?[indexPath.row]
        if let title = orderOBj!["TypeOfShoot"]{
            cell.lblContent?.text = "Shooting Type: \(title as! String)";
        }
        if let EntDt = orderOBj!["EntDt"]{
            
            cell.lblDate!.text = "Date: \(EntDt as! String)"
        }
        if let Id = orderOBj!["Id"]{
            
            cell.lblId!.text = "\(Id as! String)"
        }
        if let From = orderOBj!["StartTime"]{
            cell.lblFrom!.text = "From: \(From as! String)"
        }
        if let To = orderOBj!["EndTime"]{
            cell.lblTo!.text = "To: \(To as! String)"
        }
        cell.setNeedsUpdateConstraints();
        cell.updateConstraintsIfNeeded();
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
