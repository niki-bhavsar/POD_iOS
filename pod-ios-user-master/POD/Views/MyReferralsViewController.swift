//
//  MyReferralsViewController.swift
//  POD
//
//  Created by CrossGrids on 24/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SwiftDate

class MyReferralsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblReferrals: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    let account : Account = AccountManager.instance().activeAccount!
    var userArray = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyReferralsApi()
        lblPoints.text = account.referralPoint
        tblView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReferralCell = tableView.dequeueReusableCell(withIdentifier: "ReferralCell", for: indexPath) as! ReferralCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let user : [String : Any] = userArray[indexPath.row]
        cell.lblUsername.text = user["Name"] as? String
        cell.lblPoints.text = user["Total_Refer_Point"] as? String
        
        cell.lblDate.text = Helper.ConvertDateToTime(dateStr: user["DateTime"] as! String,timeFormat: "yyyy-MM-dd")
        return cell
    }
    
    func getMyReferralsApi(){
        ApiManager.sharedInstance.requestGETURL(Constant.getUserReferralsURL+"/"+account.user_id, success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                self.userArray = ((JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]])!
                self.tblView.reloadData()
            } else{
                Helper.ShowAlertMessage(message:msg!.description , vc: self,title:"Failed",bannerStyle: BannerStyle.danger)
            }
        }) { (Error) in
            Helper.ShowAlertMessage(message: Error.localizedDescription, vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
    }
}
