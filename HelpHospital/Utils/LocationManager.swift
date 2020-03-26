//
//  LocationManager.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation
import CoreLocation

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
}
