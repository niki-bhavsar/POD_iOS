//
//  InfoPopupViewController.swift
//  POD
//
//  Created by Apple on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InfoPopupViewController: UIViewController {
    @IBOutlet var txtDesc:UITextView!
    @IBOutlet var heightConstaing:NSLayoutConstraint!
    public var desc:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        let htmlData = NSString(string: desc!).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        txtDesc.attributedText = attributedString;
        let height = (desc! as String).height(forConstrainedWidth: txtDesc.frame.size.width, font: UIFont(name: "AvenirNext-Medium", size: 14)!)
        if(height>self.view.frame.size.height)
        {
            heightConstaing.constant = self.view.frame.size.height-100
        }
        else{
            heightConstaing.constant = height;
        }
        //txtDesc.text = desc;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(){
        self.dismiss(animated: true, completion: nil)
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
