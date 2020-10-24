//
//  LoginUser.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LoginUser: JSONAble {
    //MARK: Properties
    var UserName: String = ""
    var Password: String = ""
    
    init(username: String, password: String) {
        self.UserName = username;
        self.Password = password;
    }
}
