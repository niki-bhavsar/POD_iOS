//
//  FreelancerController.swift
//  POD
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FreelancerController: NSObject {

   static func GetPracticeList()-> [[String:Any]]{
        var listPracticeValue = [String]()
        listPracticeValue.append("Couple Photography")
         listPracticeValue.append("Body Photography(New Born-Syrs)")
         listPracticeValue.append("Product Photography(Bags/Jewellery/Shoes/Machinery etc)")
         listPracticeValue.append("Fashion Photography")
         listPracticeValue.append("Food Photography")
         listPracticeValue.append("Group Events(Birthday/Baby Shower/Engagement etc)")
         listPracticeValue.append("Interior Photography(Corporate/Personal)")
         listPracticeValue.append("Corporate Photography(Meetings/Events/Celebrations etc)")
         listPracticeValue.append("Potrait Photography")
         listPracticeValue.append("Candids")
        
        var listPractice = [[String:Any]]()
    
        for val in listPracticeValue {
            var obj = [String:Any]()
            obj["Title"] = val
            obj["IsSelected"] = false
            listPractice.append(obj)
        }
        
        return listPractice;
    }
    
}
