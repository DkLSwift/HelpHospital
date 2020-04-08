//
//  LocationManager.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation
import CoreLocation
import GeoFire

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    
    
    func setup(){
        requestAlwaysAuthorization()
        requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            delegate = self
            desiredAccuracy = kCLLocationAccuracyBestForNavigation
            startUpdatingLocation()
        }
    }
    
    
    
    func geoFireRequest(from location: CLLocation,currentRequestsKeys: [String]? ,success: @escaping ([String]) -> Void,  error: @escaping (Error) -> Void) {
        
        var keys = [String]()
        let geoFire = GeoFire(firebaseRef: needsRef)
        let circleQuery = geoFire.query(at: location, withRadius: 1)
        
        let queryHandle = circleQuery.observe(.keyEntered, with: { (key, location) in
            
            if currentRequestsKeys == nil {
                keys.append(key)
            } else if !currentRequestsKeys!.contains(key) {
                keys.append(key)
            }
        })
        
        success(keys)
    }
    
    
    func observeGeoFireNeeds(from location: CLLocation,currentRequestsKeys: [String]? ,success: @escaping (String) -> Void) {
        
        let geoFire = GeoFire(firebaseRef: needsRef)
               let circleQuery = geoFire.query(at: location, withRadius: 20)
        
        let queryHandle = circleQuery.observe(.keyEntered, with: { (key, location) in
                   
            if currentRequestsKeys == nil || !currentRequestsKeys!.contains(key) {
                      success(key)
                   }
               })
    }
    
    func postNeed(from location: CLLocation, key: String, id: String, title: String, desc: String?, timestamp: Double) {
        
        let geoFire = GeoFire(firebaseRef: needsRef)
        
        geoFire.setLocation(location, forKey: key)
        needsRef.child(key).updateChildValues([
            "title": title,
            "desc": desc ?? "",
            "pseudo": MemberSession.share.member?.pseudo ?? "",
            "senderId": id,
            "id": key,
            "timestamp": timestamp
        ])
        
        usersRef.child(id).child(currentRequests).updateChildValues([key : key])
        
    }
    
    func postContribution(from location: CLLocation, key: String, id: String, title: String, desc: String?, timestamp: Double) {
           
           let geoFire = GeoFire(firebaseRef: contributionsRef)
           
           geoFire.setLocation(location, forKey: key)
           contributionsRef.child(key).updateChildValues([
               "title": title,
               "desc": desc ?? "",
               "pseudo": MemberSession.share.member?.pseudo ?? "",
               "senderId": id,
               "id": key,
               "timestamp": timestamp
           ])
           
           usersRef.child(id).child(currentContributions).updateChildValues([key : key])
           
       }
    
    
}
