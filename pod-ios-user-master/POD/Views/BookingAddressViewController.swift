//
//  BookingAddressViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BookingAddressViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblAdd:UITableView!
    public let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        tblAdd.rowHeight = UITableView.automaticDimension
        tblAdd.estimatedRowHeight = 130
        tblAdd.reloadData()
        if #available(iOS 10.0, *) {
            tblAdd.refreshControl = refreshControl
        } else {
            tblAdd.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAddressData(_:)), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getAddressList()
    }
    
    @objc private func refreshAddressData(_ sender: Any) {
        // Fetch Weather Data
        self.getAddressList()
    }
    
    func getAddressList(){
        let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        //        if let Id = userInfo!["Id"]{
        AddressController.GetAddressList(userID: account.user_id, vc: self)
        //        }
    }
    
}

extension BookingAddressViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(AddressController.listAddress.count != 0){
            return AddressController.listAddress.count
        } else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableCustomCell
        //        cell.delegate = self
        //        cell.indexPath = indexPath
        
        let objAdd  : [String : Any] = AddressController.listAddress[indexPath.row]
        
        cell.setData(dict: objAdd)
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(editClicked(_:)), for: .touchUpInside)
        
        cell.btnDelete.addTarget(self, action: #selector(deleteClicked), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicAddObj = AddressController.listAddress[indexPath.row]
        
        if let address : String = dicAddObj["Address"] as! String{
            let addArray : [String] = address.components(separatedBy: "--")
            var strAddress = String()
            if(addArray.count > 0){
                strAddress = addArray[0]
            }
            if(addArray.count == 2){
                strAddress = addArray[0]
                strAddress = "\(strAddress), \(addArray[1])"
            }
            
            if(addArray.count == 3){
                strAddress = addArray[0]
                strAddress = "\(strAddress), \(addArray[1])"
                strAddress = "\(strAddress), \(addArray[2])"
            }
            Constant.OrderDic["ShootingAddress"] = strAddress
        }
        if let lat = dicAddObj["Lat"]{
            Constant.OrderDic["ShootingLat"] = lat
        }
        if let lng = dicAddObj["Lng"]{
            Constant.OrderDic["ShootingLng"] = lng
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MeetinPonitLocationViewController") as! MeetinPonitLocationViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func editClicked(_ sender: UIButton) {
        let dicAddObj : [String : Any] = AddressController.listAddress[sender.tag]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        controller.IsEdit = true
        controller.editDic = dicAddObj 
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func deleteClicked(_ sender: UIButton) {
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        if #available(iOS 13.0, *) {
            deleteAlert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let dicAddObj : [String : Any] = AddressController.listAddress[sender.tag]
            var dicObj = [String:Any]()
            
            if let customarID = dicAddObj["CustomerId"]{
                dicObj["CustomerId"] = customarID
            }
            if let Id = dicAddObj["Id"]{
                dicObj["Id"] = Id
            }
            AddressController.DeleteAddress(vc: self, dicObj: dicObj)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddNewAddress_Click(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        controller.IsEdit = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //    func EditTapped(at index: IndexPath) {
    //        let dicAddObj = AddressController.listAddress![index.row]
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
    //        controller.IsEdit = true;
    //        controller.editDic = dicAddObj as [String : AnyObject];
    //        self.navigationController?.pushViewController(controller, animated: true)
    //    }
    
    //    func DeleteTapped(at index: IndexPath) {
    //        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
    //        if #available(iOS 13.0, *) {
    //            deleteAlert.overrideUserInterfaceStyle = .light
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
    //            let dicAddObj = AddressController.listAddress![index.row]
    //            var dicObj = [String:Any]()
    //
    //            if let customarID = dicAddObj["CustomerId"]{
    //                dicObj["CustomerId"] = customarID as AnyObject
    //            }
    //            if let Id = dicAddObj["Id"]{
    //                dicObj["Id"] = Id as AnyObject
    //            }
    //            AddressController.DeleteAddress(vc: self, dicObj: dicObj)
    //        }))
    //
    //        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
    //            print("Handle Cancel Logic here")
    //        }))
    //
    //        present(deleteAlert, animated: true, completion: nil)
    //    }
    
    
}
