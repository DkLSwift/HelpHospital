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
        
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
            
            circleQuery.removeObserver(withFirebaseHandle: queryHandle)
            success(keys)
        })
    }
    
    func postNeed(from location: CLLocation, key: String, id: String, title: String, desc: String?, time: String?) {
        
        let geoFire = GeoFire(firebaseRef: needsRef)
        
        geoFire.setLocation(location, forKey: key)
        needsRef.child(key).updateChildValues([
            "title": title,
            "desc": desc ?? "",
            "time": time ?? "",
            "pseudo": MemberSession.share.member?.pseudo ?? "",
            "workerId": id,
            "id": key
        ])
        
        usersRef.child(id).child(currentRequests).updateChildValues([key : key])
        
    }
}
