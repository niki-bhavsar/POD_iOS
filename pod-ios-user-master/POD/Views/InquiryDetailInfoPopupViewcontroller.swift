//
//  InquiryDetailInfoPopupViewcontroller.swift
//  POD
//
//  Created by Apple on 22/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InquiryDetailInfoPopupViewcontroller: UIViewController {
     @IBOutlet  var lblCharge:UILabel!
     @IBOutlet  var lblHours:UILabel!
     @IBOutlet  var lblAmount:UILabel!
    public var charge:String?
    public var hours:String?
    public var amount:String?
    public var vc:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        lblCharge.text = charge;
        lblHours.text = hours;
        lblAmount.text = amount;
        NotificationCenter.default.addObserver(self,
        selector: #selector(closePopup),
        name: NSNotification.Name("closePopup"),
        object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func closePopup() {
        self.dismiss(animated: true, completion: nil); vc?.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnBookNow(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingAddressViewController") as! BookingAddressViewController
        self.dismiss(animated: true, completion: nil)
        vc?.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnBookLater(sender:UIButton){
        self.dismiss(animated: true, completion: nil); vc?.navigationController?.popToRootViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
