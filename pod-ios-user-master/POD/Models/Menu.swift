//
//  Menu.swift
//  POD
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Menu: NSObject {
    
    //MARK: Properties
    var name: String
    var icon: String
    
    init(name: String, icon: String) {
        self.icon = icon;
        self.name = name;
    }
}
