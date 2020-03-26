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
    
    
    
    func geoFireRequest(from location: CLLocation,success: @escaping ([String]) -> Void,  error: @escaping (Error) -> Void) {
        
        var keys = [String]()
        var geoFire: GeoFire? = GeoFire(firebaseRef: needsRef)
        let circleQuery = geoFire?.query(at: location, withRadius: 1)
        
        let queryHandle = circleQuery?.observe(.keyEntered, with: { (key, location) in
            keys.append(key)
        })
    }
    
    
}
