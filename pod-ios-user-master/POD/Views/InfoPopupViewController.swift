//
//  InfoPopupViewController.swift
//  POD
//
//  Created by Apple on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InfoPopupViewController: BaseViewController {
    
    @IBOutlet var txtDesc:UITextView!
    var desc = String()
    var categoryId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        let htmlData = NSString(string: desc).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        txtDesc.attributedText = attributedString
        
//        let height = (desc! as String).height(forConstrainedWidth: txtDesc.frame.size.width, font: UIFont(name: "AvenirNext-Medium", size: 14)!)
//        if(height>self.view.frame.size.height)
//        {
//            heightConstaing.constant = self.view.frame.size.height-100
//        }
//        else{
//            heightConstaing.constant = height;
//        }
//        //txtDesc.text = desc;
//        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtDesc.setContentOffset(.zero, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         txtDesc.setContentOffset(.zero, animated: false)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SelectSubCategoryViewController") as! SelectSubCategoryViewController
        controller.categoryId = categoryId
//        categoryIndex = Constant.AllSubcategoryArr.count
//        Constant.AllSubcategoryArr.append(obj["Title"] as! String)
//        Constant.AllSubcategoryIdArr.append(obj["Id"] as! String)
//
//        Constant.AllSubcategoryId = (Constant.AllSubcategoryIdArr.map{String($0)}).joined(separator: ",")
//        Constant.AllSubcategory = (Constant.AllSubcategoryArr.map{String($0)}).joined(separator: ",")
//
//                                      print("-----Constant.AllSubcategory-----")
//                                      print(Constant.AllSubcategory)
//                                      print(Constant.AllSubcategoryId)
//                                      print("----Constant.AllSubcategory------")
//        print("-----------")
//        print(Constant.AllSubcategoryArr)
//        print(Constant.AllSubcategoryIdArr)
//        print("-----------")
//        IsSelected = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
