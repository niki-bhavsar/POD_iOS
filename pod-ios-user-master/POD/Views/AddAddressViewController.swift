//
//  AddAddressViewController.swift
//  POD
//
//  Created by Apple on 07/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit

class AddAddressViewController: BaseViewController, MKMapViewDelegate {
    
    @IBOutlet var txtQuery:UITextView!
    @IBOutlet var mapContainerView:UIView!
    @IBOutlet var btnHome:UIButton!
    @IBOutlet var btnWork:UIButton!
    @IBOutlet var txtOther:UITextField!
    @IBOutlet var txtHome:UITextField!
    @IBOutlet var txtLandmark:UITextField!
    @IBOutlet var txtArea:UITextField!
    @IBOutlet var tblArea:UITableView!
    
    var mapView:MKMapView?
    var lat:Double = 0.0
    var lng:Double = 0.0
    var selectedType:Int = 1;
    var editDic:[String:AnyObject]?
    public var IsEdit:Bool?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        AddressController.listSearchAddress = nil
        InitializeKeyBoardNotificationObserver()
        btnHome.layer.borderColor = UIColor.green.cgColor
        selectedType = 1;
        txtQuery!.leftSpace()
        txtQuery.alpha = 0.5
        lat = Constant.currLat;
        lng = Constant.currLng;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView = MKMapView.init(frame: CGRect.init(x: 0, y: 0, width: self.mapContainerView.frame.size.width, height: self.mapContainerView.frame.size.height))
        mapView?.delegate = self;
        self.mapContainerView.addSubview(mapView!)
        if(IsEdit == true){
            SetEditInfo();
        }
        else{
            Helper.getAddressFromLatLon(pdblLatitude: Constant.currLat.description, withLongitude: Constant.currLng.description,txt: self.txtQuery)
                  self.SetLocationOnMap();
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == txtOther){
            Helper.ShowAlertWithTextViewWithHandlesr(message: "Enter Other Location", vc: self, actionOK: { () -> Void in
                
            }, actionCancel: {() -> Void in
                 self.txtOther.resignFirstResponder()
            },result:{(txt) -> Void in
                self.txtOther.text = txt;
                self.txtOther.resignFirstResponder()
            },oldText:txtOther.text!)
        }
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtArea){
            if(txtArea.text!.count == 1 && string == ""){
                DispatchQueue.main.async {
                    self.tblArea.isHidden = true;
                }
            }
            else{
                AddressController.GetAddressAutoList(searchText: txtArea.text!, vc: self)
            }
        }
        return true
    }
    
    func SetLocationOnMap(){
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        mapView!.addAnnotation(annotation)
        mapView?.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2DMake(lat, lng), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
    
    @IBAction func btnContinue_Click(){
        if(selectedType==3){
            if(txtOther.text?.count==0){
                Helper.ShowAlertMessage(message: "Please enter other title.", vc: self)
                return;
            }
        }
        
        if(IsEdit == false){
            AddAddress()
        }
        else{
            UpdateAdddress()
        }
    }
    
    func AddAddress(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
         var otpDic = [String:AnyObject]()
         if let Id = userInfo!["Id"]{
              otpDic["CustomerId"] = Id as AnyObject
         }
          
        otpDic["Type"] = selectedType.description as AnyObject
        if(selectedType == 3){
            otpDic["Title"] = txtOther.text as AnyObject
        }
        else if(selectedType == 2){
            otpDic["Title"] = "Work" as AnyObject
        }
        else if(selectedType == 1){
            otpDic["Title"] = "Home" as AnyObject
        }
               
        otpDic["Address"] = txtQuery.text as AnyObject
        otpDic["Lat"] = self.lat.description as AnyObject
        otpDic["Lng"] = self.lng.description as AnyObject
        AddressController.AddAddress(vc: self, dicObj: otpDic)
        
//        @Part("CustomerId") RequestBody CustomerId,
//                       @Part("Type") RequestBody Type,
//                       @Part("Title") RequestBody Title,
//                       @Part("Address") RequestBody Address,
//                       @Part("Lat") RequestBody Lat,
//                       @Part("Lng") RequestBody Lng
    }
    
    func UpdateAdddress(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
         var otpDic = [String:AnyObject]()
         if let Id = userInfo!["Id"]{
              otpDic["CustomerId"] = Id as AnyObject
         }
        otpDic["Id"] = editDic!["Id"] as AnyObject
        otpDic["Type"] = selectedType.description as AnyObject
        if(selectedType == 3){
            otpDic["Title"] = txtOther.text as AnyObject
        }
        else if(selectedType == 2){
            otpDic["Title"] = "Work" as AnyObject
        }
        else if(selectedType == 1){
            otpDic["Title"] = "Home" as AnyObject
        }
        var add = txtQuery.text;
        if(txtHome.text!.count>0){
            add = add!+", "+txtHome.text!
        }
        if(txtLandmark.text!.count>0){
            add = add!+", "+txtLandmark.text!
        }
        otpDic["Address"] = add as AnyObject
        otpDic["Lat"] = self.lat.description as AnyObject
        otpDic["Lng"] = self.lng.description as AnyObject
        AddressController.EditAddress(vc: self, dicObj: otpDic)
    }
    
    func SetEditInfo(){
        
        let latitude = editDic!["Lat"]
        let longitude = editDic?["Lng"]
        lat = Double(((latitude?.description)!)) as! Double
        lng = Double(((longitude?.description)!)) as! Double
        Helper.getAddressFromLatLon(pdblLatitude: (latitude?.description)!, withLongitude: (longitude?.description)!,txt: self.txtQuery)
        self.SetLocationOnMap();
        if let Title = editDic!["Title"]{
            btnHome.layer.borderColor = UIColor.lightGray.cgColor
            btnWork.layer.borderColor = UIColor.lightGray.cgColor
            txtOther.layer.borderColor = UIColor.lightGray.cgColor
            if(Title as! String == "Home")
            {
                btnHome.layer.borderColor = UIColor.green.cgColor
                selectedType = 1;
            }
            else if(Title as! String == "Work")
            {
                btnWork.layer.borderColor = UIColor.green.cgColor
                selectedType = 2;

            }
            else{
                txtOther.text = Title as! String;
                 txtOther.layer.borderColor = UIColor.green.cgColor
                    selectedType = 3;
            }
        }
        if let Address = editDic!["Address"]{
            txtQuery.text = Address  as! String
        }
       
    }
    
    @IBAction func btnEdit_Click(){
        if(txtQuery.isUserInteractionEnabled == false){
            txtQuery.isUserInteractionEnabled = true
              txtQuery.alpha = 1
        }
        else{
             txtQuery.isUserInteractionEnabled = false
              txtQuery.alpha = 0.5
        }
    }
    
    @IBAction func btnType_Click(sender:UIButton){
        btnHome.layer.borderColor = UIColor.lightGray.cgColor
        btnWork.layer.borderColor = UIColor.lightGray.cgColor
        txtOther.layer.borderColor = UIColor.lightGray.cgColor
        sender.layer.borderColor = UIColor.green.cgColor
        selectedType = sender.tag;
        txtOther.resignFirstResponder()
        txtQuery.resignFirstResponder()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (textView.text == "Your Query") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Query"
            textView.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
        }
    }
}

extension AddAddressViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         if annotation is MKUserLocation  {
               return nil
           }

           let reuseId = "pin"
           var pav:MKPinAnnotationView?
           if (pav == nil)
           {
               pav = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pav?.isDraggable = false
               pav?.canShowCallout = true;
           }
           else
           {
               pav?.annotation = annotation;
           }

           return pav;
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
//        if newState == MKAnnotationView.DragState.ending {
//            let droppedAt = view.annotation?.coordinate
//            lat = droppedAt!.latitude;
//            lng = droppedAt!.longitude;
//            Helper.getAddressFromLatLon(pdblLatitude: lat.description, withLongitude: lng.description,txt: self.txtQuery)
//
//        }
//    }
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let droppedAt = mapView.centerCoordinate
        lat = droppedAt.latitude;
        lng = droppedAt.longitude;
            Helper.getAddressFromLatLon(pdblLatitude: lat.description, withLongitude: lng.description,txt: self.txtQuery)
        mapView.removeAnnotations(mapView.annotations)
         let annotation = MKPointAnnotation()
               annotation.title = title
               annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
               
        mapView.addAnnotation(annotation)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnHome.layer.borderColor = UIColor.lightGray.cgColor
               btnWork.layer.borderColor = UIColor.lightGray.cgColor
               txtOther.layer.borderColor = UIColor.green.cgColor
        selectedType = 3;
    }
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
extension AddAddressViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AddressController.listSearchAddress != nil){
        if(AddressController.listSearchAddress!.count>0)
        {
            tblArea.isHidden = false
        }
        else{
            tblArea.isHidden = true
        }
        return AddressController.listSearchAddress!.count
        }
        tblArea.isHidden = true
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAreaTableViewCell", for: indexPath) as! SearchAreaTableViewCell
        let obj =  AddressController.listSearchAddress![indexPath.row] as [String:AnyObject]
        if let name = obj["Name"]{
            cell.lblName.text = name as! String;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var obj =  AddressController.listSearchAddress![indexPath.row]
        if let name = obj["Name"]{
            txtArea.text = name as! String;
        }
        lat = Double(obj["Lat"] as! String) as! Double
        lng = Double(obj["Lng"] as! String) as! Double
        mapView!.removeAnnotations(mapView!.annotations)
        SetLocationOnMap()
        txtArea.resignFirstResponder()
        tblArea.isHidden = true;
    }
}
