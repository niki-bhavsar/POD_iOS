//
//  SplashViewController.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
class SplashViewController: UIViewController {
    
    @IBOutlet var imglogo1:UIImageView!
    @IBOutlet var imglogo2:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
         Helper.rootNavigation = self.navigationController;
        self.LoadAnimation()
        // Do any additional setup after loading the view.
    }
    
    func LoadAnimation(){
         UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    // HERE
                    self.imglogo1.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5) // Scale your image
                    
                }) { (finished) in
                    UIView.animate(withDuration: 1, animations: {
                        self.imglogo1.transform = CGAffineTransform.identity // undo in 1 seconds
                        UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseIn, animations: {() -> Void in
                            self.imglogo1.layoutIfNeeded()
                            
                            var xPos = self.imglogo1.frame.origin.x-((((self.view.frame.size.width*50)/100)))
                            if(xPos<0){
                                xPos = (-1)*xPos
                            }
                            self.imglogo1.frame = CGRect.init(x:xPos,  y: self.imglogo1.frame.origin.y, width: self.imglogo1.frame.size.width,  height: self.imglogo1.frame.size.height);
                            
                            self.imglogo2.frame = CGRect.init(x: (self.imglogo1.frame.origin.x+self.imglogo1.frame.size.width-10),  y: self.imglogo2.frame.origin.y, width: self.imglogo2.frame.size.width,  height: self.imglogo2.frame.size.height);
                                           self.imglogo2.layoutIfNeeded()
                            
                            
                            
                        }, completion: {(_ finished: Bool) -> Void in
                            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SplashViewController.MoveToLogin), userInfo: nil, repeats:  false)
                        })
                    })
                }
    }
    
    @objc func MoveToLogin(){

        let isUserExist = Helper.UnArchivedUserDefaultObject(key: "UserInfo")
        if (Helper.isObjectNotNil(object: isUserExist as AnyObject)) {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
