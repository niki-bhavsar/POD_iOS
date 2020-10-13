//
//  AddAddressViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit

class AddAddressViewController: BaseViewController {//, MKMapViewDelegate {
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var txtQuery:UITextView!
    //    @IBOutlet var mapContainerView:UIView!
    @IBOutlet var btnHome:UIButton!
    @IBOutlet var btnWork:UIButton!
    //    @IBOutlet var txtOther:UITextField!
    @IBOutlet var txtFlat:UITextField!
    @IBOutlet var txtLandmark:UITextField!
    //    @IBOutlet var txtArea:UITextField!
    //    @IBOutlet var tblArea:UITableView!
    //
    //    var mapView:MKMapView?
    var lat:Double = 0.0
    var lng:Double = 0.0
    var selectedType : Int = 1
    var editDic = [String:Any]()
    public var IsEdit = Bool()
    var isCurrentLocation = Bool()
    var currentLocationAddress = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //        AddressController.listSearchAddress = nil
        InitializeKeyBoardNotificationObserver()
        btnHome.layer.borderColor = UIColor.green.cgColor
        selectedType = 1
        txtQuery!.leftSpace()
        txtQuery.alpha = 0.5
        lat = Constant.currLat
        lng = Constant.currLng
        
        if(IsEdit == true){
            lblTitle.text = "Edit Address"
            SetEditInfo()
        } else{
            lblTitle.text = "Add Address"
            //            Helper.getAddressFromLatLon(pdblLatitude: Constant.currLat.description, withLongitude: Constant.currLng.description,txt: self.txtQuery)
            //                  self.SetLocationOnMap()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        mapView = MKMapView.init(frame: CGRect.init(x: 0, y: 0, width: self.mapContainerView.frame.size.width, height: self.mapContainerView.frame.size.height))
        //        mapView?.delegate = self;
        //        self.mapContainerView.addSubview(mapView!)
        
        //        if(IsEdit == true){
        //            SetEditInfo()
        //        } else{
        //
        ////            Helper.getAddressFromLatLon(pdblLatitude: Constant.currLat.description, withLongitude: Constant.currLng.description,txt: self.txtQuery)
        ////                  self.SetLocationOnMap()
        //        }
    }
    
    @IBAction func btnUseCurrentLocation(_ sender: Any) {
        isCurrentLocation = true
        Helper.getAddressFromLatLon(pdblLatitude: Constant.currLat.description, withLongitude: Constant.currLng.description,txt: self.txtQuery)
       
//        txtQuery.isUserInteractionEnabled = false
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(isCurrentLocation == true){
             currentLocationAddress = txtQuery.text
        }
        return true
    }
    
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        if(textField == txtOther){
    //            Helper.ShowAlertWithTextViewWithHandlesr(message: "Enter Other Location", vc: self, actionOK: { () -> Void in
    //
    //            }, actionCancel: {() -> Void in
    //                 self.txtOther.resignFirstResponder()
    //            },result:{(txt) -> Void in
    //                self.txtOther.text = txt;
    //                self.txtOther.resignFirstResponder()
    //            },oldText:txtOther.text!)
    //        }
    //
    //        return true;
    //    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if(textField == txtArea){
    //            if(txtArea.text!.count == 1 && string == ""){
    //                DispatchQueue.main.async {
    //                    self.tblArea.isHidden = true;
    //                }
    //            }
    //            else{
    //                AddressController.GetAddressAutoList(searchText: txtArea.text!, vc: self)
    //            }
    //        }
    //        return true
    //    }
    
    //    func SetLocationOnMap(){
    //        let annotation = MKPointAnnotation()
    //        annotation.title = title
    //        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
    //
    //        mapView!.addAnnotation(annotation)
    //        mapView?.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2DMake(lat, lng), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    //    }
    
    func getLatLongFromAddress(address: String, dict : [String : Any]){
        //        let address = "Burlington, Vermont"
        var addDict = [String : Any]()
        addDict = dict
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if (error != nil) {
                Helper.ShowAlertMessage(message: "Please enter valid Address", vc: self)
                return
//                if(self.IsEdit == false){
//                    AddressController.AddAddress(vc: self, dicObj: addDict)
//                } else {
//                    AddressController.EditAddress(vc: self, dicObj: addDict)
//                }
//                return
            }
            
            if let placemark = placemarks?[0]  {
                let longi = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                let latti = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                let name = placemark.name!
                let country = placemark.country!
//                let region = placemark.administrativeArea!
                print("\(latti),\(longi)\n\(name), \(country)")
                
                addDict["Lat"] = latti
                addDict["Lng"] = longi
                if(self.IsEdit == false){
                    AddressController.AddAddress(vc: self, dicObj: addDict)
                } else {
                    AddressController.EditAddress(vc: self, dicObj: addDict)
                }
            }
        })
    }
    
    
    @IBAction func btnContinue_Click(){
        if(txtQuery.text == "Type here"){
            Helper.ShowAlertMessage(message: "Please enter address.", vc: self)
            return
        } else if(selectedType == 3){
            if(btnOther.titleLabel!.text == "Other"){
                Helper.ShowAlertMessage(message: "Please enter other title.", vc: self)
                return
            }
        }
        
        if(IsEdit == false){
            addAddress()
        } else{
            updateAdddress()
        }
        
    }
    
    func addAddress(){
        let account = AccountManager.instance().activeAccount!
        var otpDic = [String:Any]()
        
        otpDic["CustomerId"] = account.user_id
        
        otpDic["Type"] = selectedType.description
        
        if(selectedType == 3){
            otpDic["Title"] = btnOther.titleLabel?.text
        } else if(selectedType == 2){
            otpDic["Title"] = "Work"
        } else if(selectedType == 1){
            otpDic["Title"] = "Home"
        }
        var add : String = txtQuery.text.trimmingCharacters(in: .whitespaces)
        
        if(txtFlat.text!.count > 0){
            add = "\(add)--\(txtFlat.text ?? "")"
        }
        if(txtLandmark.text!.count > 0){
            add = "\(add)--\(txtLandmark.text ?? "")"
        }
        
        otpDic["Address"] = add
        if(isCurrentLocation == true){
            if(currentLocationAddress == txtQuery.text){
                otpDic["Lat"] = self.lat.description
                otpDic["Lng"] = self.lng.description
                self.showSpinner()
                AddressController.AddAddress(vc: self, dicObj: otpDic)
            } else {
                self.showSpinner()
                getLatLongFromAddress(address: txtQuery.text.trimmingCharacters(in: .whitespaces), dict: otpDic)
            }
        } else {
            //            otpDic["Lat"] = "0.0"
            //            otpDic["Lng"] = "0.0"
            self.showSpinner()
            getLatLongFromAddress(address: txtQuery.text.trimmingCharacters(in: .whitespaces), dict: otpDic)
        }
    }
    
    func updateAdddress(){
        let account = AccountManager.instance().activeAccount!
        var otpDic = [String:Any]()
        otpDic["CustomerId"] = account.user_id
        
        
        otpDic["Id"] = editDic["Id"]
        otpDic["Type"] = selectedType.description
        
        if(selectedType == 3){
            otpDic["Title"] = btnOther.titleLabel!.text
        } else if(selectedType == 2){
            otpDic["Title"] = "Work"
        } else if(selectedType == 1){
            otpDic["Title"] = "Home"
        }
        
        var add : String = txtQuery.text.trimmingCharacters(in: .whitespaces)
        
        if(txtFlat.text!.count > 0){
            add = "\(add)--\(txtFlat.text ?? "")"
        }
        if(txtLandmark.text!.count > 0){
            add = "\(add)--\(txtLandmark.text ?? "")"
        }
        
        otpDic["Address"] = add
        if(isCurrentLocation == true){
            if(currentLocationAddress == txtQuery.text){
                otpDic["Lat"] = self.lat.description
                otpDic["Lng"] = self.lng.description
                self.showSpinner()
                AddressController.EditAddress(vc: self, dicObj: otpDic)
            } else {
                self.showSpinner()
                getLatLongFromAddress(address: txtQuery.text.trimmingCharacters(in: .whitespaces), dict: otpDic)
            }
        } else {
            //            otpDic["Lat"] = "0.0"
            //            otpDic["Lng"] = "0.0"
            self.showSpinner()
            getLatLongFromAddress(address: txtQuery.text, dict: otpDic)
        }
       
    }
    
    func SetEditInfo(){
        
        let latitude = editDic["Lat"]
        let longitude = editDic["Lng"]
        
        lat = Double((((latitude as AnyObject).description)!))!
        lng = Double((((longitude as AnyObject).description)!))!
        
        //        if(lat != 0.0 || lng != 0.0){
        //             Helper.getAddressFromLatLon(pdblLatitude: ((latitude as AnyObject).description)!, withLongitude: ((longitude as AnyObject).description)!,txt: self.txtQuery)
        //        } else{
        if let address : String = editDic["Address"] as? String{
            let addArray : [String] = address.components(separatedBy: "--")
            if(addArray.count > 0){
                txtQuery.text = addArray[0]
            }
            if(addArray.count == 2){
                txtQuery.text = addArray[0]
                txtFlat.text = addArray[1]
            }
            
            if(addArray.count == 3){
                txtQuery.text = addArray[0]
                txtFlat.text = addArray[1]
                txtLandmark.text = addArray[2]
            }
        }
        //        }
        //        self.SetLocationOnMap()
        
        if let Title : String = editDic["Title"] as? String{
            btnHome.layer.borderColor = UIColor.lightGray.cgColor
            btnWork.layer.borderColor = UIColor.lightGray.cgColor
            btnOther.layer.borderColor = UIColor.lightGray.cgColor
            if(Title  == "Home") {
                btnHome.layer.borderColor = UIColor.green.cgColor
                selectedType = 1
            } else if(Title == "Work") {
                btnWork.layer.borderColor = UIColor.green.cgColor
                selectedType = 2
            } else{
                btnOther.setTitle(Title, for: .normal)
                btnOther.layer.borderColor = UIColor.green.cgColor
                selectedType = 3
            }
        }
    }
    
    @IBAction func btnEdit_Click(){
        if(txtQuery.isUserInteractionEnabled == false){
            txtQuery.isUserInteractionEnabled = true
            //              txtQuery.alpha = 1
        } else{
            txtQuery.isUserInteractionEnabled = false
            //              txtQuery.alpha = 0.5
        }
    }
    
    @IBAction func otherClicked(_ sender: Any) {
        Helper.ShowAlertWithTextViewWithHandlesr(message: "Enter Other Location", vc: self, actionOK: { () -> Void in
            
        }, actionCancel: {() -> Void in
            //                        self.txtOther.resignFirstResponder()
        },result:{(txt) -> Void in
            self.btnOther.setTitle(txt, for: .normal)
            self.btnHome.layer.borderColor = UIColor.lightGray.cgColor
            self.btnWork.layer.borderColor = UIColor.lightGray.cgColor
            self.btnOther.layer.borderColor = UIColor.green.cgColor
            self.selectedType = 3
        },oldText:btnOther.titleLabel?.text ?? "")
    }
    
    @IBAction func btnType_Click(sender:UIButton){
        btnHome.layer.borderColor = UIColor.lightGray.cgColor
        btnWork.layer.borderColor = UIColor.lightGray.cgColor
        btnOther.layer.borderColor = UIColor.lightGray.cgColor
        sender.layer.borderColor = UIColor.green.cgColor
        selectedType = sender.tag
        //        txtOther.resignFirstResponder()
        txtQuery.resignFirstResponder()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "Type here") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type here"
            textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
        }
    }
}

//extension AddAddressViewController{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//         if annotation is MKUserLocation  {
//               return nil
//           }
//
//           let reuseId = "pin"
//           var pav:MKPinAnnotationView?
//           if (pav == nil)
//           {
//               pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//               pav?.isDraggable = false
//               pav?.canShowCallout = true;
//           }
//           else
//           {
//               pav?.annotation = annotation;
//           }
//
//           return pav;
//    }
//
////    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
////        if newState == MKAnnotationView.DragState.ending {
////            let droppedAt = view.annotation?.coordinate
////            lat = droppedAt!.latitude;
////            lng = droppedAt!.longitude;
////            Helper.getAddressFromLatLon(pdblLatitude: lat.description, withLongitude: lng.description,txt: self.txtQuery)
////
////        }
////    }
//
//
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let droppedAt = mapView.centerCoordinate
//        lat = droppedAt.latitude;
//        lng = droppedAt.longitude;
//            Helper.getAddressFromLatLon(pdblLatitude: lat.description, withLongitude: lng.description,txt: self.txtQuery)
//        mapView.removeAnnotations(mapView.annotations)
//         let annotation = MKPointAnnotation()
//               annotation.title = title
//               annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
//
//        mapView.addAnnotation(annotation)
//    }
//
////    func textFieldDidBeginEditing(_ textField: UITextField) {
////        btnHome.layer.borderColor = UIColor.lightGray.cgColor
////               btnWork.layer.borderColor = UIColor.lightGray.cgColor
////               txtOther.layer.borderColor = UIColor.green.cgColor
////        selectedType = 3;
////    }
//
//
//    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//}
//extension AddAddressViewController : UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(AddressController.listSearchAddress != nil){
//        if(AddressController.listSearchAddress!.count>0)
//        {
//            tblArea.isHidden = false
//        }
//        else{
//            tblArea.isHidden = true
//        }
//        return AddressController.listSearchAddress!.count
//        }
//        tblArea.isHidden = true
//        return 0;
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAreaTableViewCell", for: indexPath) as! SearchAreaTableViewCell
//        let obj =  AddressController.listSearchAddress![indexPath.row] as [String:Any]
//        if let name = obj["Name"]{
//            cell.lblName.text = name as? String
//        }
//
//        return cell;
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj =  AddressController.listSearchAddress![indexPath.row]
//        if let name = obj["Name"]{
//            txtArea.text = name as? String
//        }
//        lat = Double(obj["Lat"] as! String)!
//        lng = Double(obj["Lng"] as! String)!
//        mapView!.removeAnnotations(mapView!.annotations)
//        SetLocationOnMap()
//        txtArea.resignFirstResponder()
//        tblArea.isHidden = true;
//    }
//}
