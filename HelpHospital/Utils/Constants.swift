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

let seaDarkBlue = UIColor(red: 2/255, green: 22/255, blue: 52/255, alpha: 1.0)
let seaLightBlue = UIColor(red: 60/255, green: 96/255, blue: 141/255, alpha: 1.0)
let seaWhite = UIColor(red: 184/255, green: 212/255, blue: 234/255, alpha: 1.0)

var ref = Database.database().reference()

var usersRef: DatabaseReference {
    return ref.child("users")
}
var needsRef: DatabaseReference {
    return ref.child("needs")
}
let currentRequests = "currentRequests"
var messagesRef: DatabaseReference {
    return ref.child("messages")
}
var usersMessagesRef: DatabaseReference {
    return ref.child("usersMessages")
}
