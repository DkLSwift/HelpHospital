//
//  Constants.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import FirebaseDatabase

let green = UIColor(red: 95/255, green: 221/255, blue: 157/255, alpha: 1.0)
let greenishBlue = UIColor(red: 145/255, green: 249/255, blue: 229/255, alpha: 1.0)
let dark = UIColor(red: 4/255, green: 27/255, blue: 21/255, alpha: 1.0)
let clearBlue = UIColor(red: 201/255, green: 249/255, blue: 255/255, alpha: 1.0)



var ref = Database.database().reference()

var usersRef: DatabaseReference {
    return ref.child("users")
}
var needsRef: DatabaseReference {
    return ref.child("needs")
}
let currentRequests = "currentRequests"
