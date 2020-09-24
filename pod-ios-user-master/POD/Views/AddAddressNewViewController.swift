//
//  AddAddressNewViewController.swift
//  POD
//
//  Created by Apple on 22/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class AddAddressNewViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var txtQuery:UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet var btnHome:UIButton!
    @IBOutlet var btnWork:UIButton!
    @IBOutlet var txtOther:UITextField!
    @IBOutlet var txtFlat:UITextField!
    @IBOutlet var txtLandmark:UITextField!
    @IBOutlet var txtArea:UITextField!
    @IBOutlet var tblArea:UITableView!
    
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searchPlaceId = [String]()
    var searhPlacesName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblArea.isHidden = true
        tblArea.tableFooterView = UIView()
        mapView.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        
    }
    func placeAutocomplete(text_input: String) {
        let filter = GMSAutocompleteFilter()
        //        filter.type = .noFilter
        filter.country = "TZ"
        
        
        //geo bounds set for bengaluru region
        //        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: -6.375, longitude: 34.893333), coordinate: CLLocationCoordinate2D(latitude: -6.375, longitude: 34.893333))
        
        placesClient.autocompleteQuery(text_input, bounds: nil, filter: filter) { (results, error) -> Void in
            self.placeIDArray.removeAll() //array that stores the place ID
            self.resultsArray.removeAll() // array that stores the results obtained
            self.primaryAddressArray.removeAll() //array storing the primary address of the place.
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                let json = JSON(results)
                print(json)
                for result in results {
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    //print("primary text: \(result.attributedPrimaryText.string)")
                    //print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID!))")
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                }
            }
            self.searchPlaceId = self.placeIDArray
            self.searchResults = self.resultsArray
            self.searhPlacesName = self.primaryAddressArray
            if(self.searchResults.count > 0){
                self.tblArea.isHidden = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 40.0) {
                    if(self.searchResults.count <= 0){
                        //                          Utils.showAlert(withMessage: "No location found on google maps. Please move the red pin to the desired delivery location")
                        self.tblArea.isHidden = true
                        self.locationManager.delegate = self
                        self.locationManager.startUpdatingLocation()
                    }
                    
                    
                }
            }
            self.tblArea.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == txtArea){
            if(textField.text!.count > 0){
                placesClient = GMSPlacesClient()
                placeAutocomplete(text_input: textField.text ?? "")
            }
            
        } else {
            placesClient = GMSPlacesClient()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == txtArea){
            placesClient = GMSPlacesClient()
        }
    }
    
    func textField (_ textField :  UITextField, shouldChangeCharactersIn range:  NSRange, replacementString string:  String  )  ->  Bool {
        let textString = NSString(format:"%@",textField.text!)
        
        let newString  : String = textString.replacingCharacters(in: range, with: string)
        if(textField == txtArea){
            if(newString.count > 0){
                placeAutocomplete(text_input: newString)
            } else {
                placesClient = GMSPlacesClient()
                searchResults = [String]()
                tblArea.reloadData()
                tblArea.isHidden = true
            }
            
        }
        
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblArea.deselectRow(at: indexPath, animated: true)
        if(searchPlaceId.count > 0){
            placesClient = GMSPlacesClient()
            tblArea.isHidden = true
            //               getPlaceByPlaceId(placeId: searchPlaceId[indexPath.row])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last!
        locationManager.stopUpdatingLocation()
        mapView.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude,
                                              longitude: userLocation.coordinate.longitude,
                                              zoom: 15)
        mapView.camera = camera
        
        let position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Me"
        marker.map = mapView
        
    }
    
    
    
}
