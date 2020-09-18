//
//  FAQViewController.swift
//  POD
//
//  Created by Apple on 06/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FAQViewController:BaseViewController, UITableViewDataSource,UITableViewDelegate {

    public let refreshControl = UIRefreshControl()
    @IBOutlet var tblFAQ:UITableView!
    @IBOutlet var btnDeleteAll:UIButton!
    
   let account = AccountManager.instance().activeAccount!//Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tblFAQ.rowHeight = UITableView.automaticDimension
        self.tblFAQ.estimatedRowHeight = 60
        self.tblFAQ.reloadData();
        if #available(iOS 10.0, *) {
            tblFAQ.refreshControl = refreshControl
        } else {
            tblFAQ.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)

        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
           // Fetch Weather Data
//           if let Id = userInfo!["Id"]{
        InqueryController.GetFAQ(userId: account.user_id, vc: self);
//           }
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let Id = userInfo!["Id"]{
            InqueryController.GetFAQ(userId: account.user_id, vc: self);
//        }
    }
    
}

extension FAQViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(InqueryController.listFAQ != nil){
            if(InqueryController.listFAQ!.count>0){
                tableView.restore()
                //btnDeleteAll.isHidden = false
            }
            else{
                tableView.setEmptyMessage("No List Found")
                //btnDeleteAll.isHidden = true
            }
            return InqueryController.listFAQ!.count
        }
        else{
            tableView.setEmptyMessage("No List Found")
            //btnDeleteAll.isHidden = true
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let orderOBj = InqueryController.listFAQ?[indexPath.row]
        if let Content = orderOBj!["Content"]{
            
            cell.lblContent?.attributedText = (Content as! String).html2Attributed
        }
        if let question = orderOBj!["Title"]{
            cell.lblQ?.text = (question as! String)
        }
        cell.setNeedsUpdateConstraints();
        cell.updateConstraintsIfNeeded();
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
