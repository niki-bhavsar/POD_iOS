//
//  InquirySubDetailController.swift
//  POD
//
//  Created by Apple on 11/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InquirySubDetailController: NSObject {
    public static var listState:[String]?
    public static var listCity:[String]?
    public static var listLocation:[String]?
    public static var listMedia:[String]?
    public static func SetList(){
        listState = [String]()
        listCity = [String]()
        listLocation = [String]()
        listMedia = [String]()
        listState?.append("Gujarat")
        listCity?.append("Ahmedabad")
        listLocation?.append("Iscon")
        listLocation?.append("Satelite")
        listLocation?.append("Bopal")
        listLocation?.append("Gota")
        listMedia?.append("Facebook")
        listMedia?.append("Instagram")
        listMedia?.append("Firends")
        listMedia?.append("Other")
        
    }
       
}
