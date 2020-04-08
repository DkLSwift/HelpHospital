//
//  Constants.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import FirebaseDatabase

let greenee = UIColor(red: 95/255, green: 221/255, blue: 157/255, alpha: 1.0)
let greenishBlue = UIColor(red: 145/255, green: 249/255, blue: 229/255, alpha: 1.0)
let dark = UIColor(red: 4/255, green: 27/255, blue: 21/255, alpha: 1.0)
let clearBlue = UIColor(red: 201/255, green: 249/255, blue: 255/255, alpha: 1.0)

let seaDarkBlue = UIColor(red: 2/255, green: 22/255, blue: 52/255, alpha: 1.0)
let seaLightBlue = UIColor(red: 60/255, green: 96/255, blue: 141/255, alpha: 1.0)
let seaWhite = UIColor(red: 184/255, green: 212/255, blue: 234/255, alpha: 1.0)

let blue = UIColor(red: 0/255, green: 172/255, blue: 193/255, alpha: 1.0)
let bluePlus = UIColor(red: 0/255, green: 130/255, blue: 143/255, alpha: 1.0)
let blueMinus = UIColor(red: 37/255, green: 197/255, blue: 218/255, alpha: 1.0)
let red = UIColor(red: 193/255, green: 23/255, blue: 0/255, alpha: 1.0)
let green = UIColor(red: 0/255, green: 193/255, blue: 119/255, alpha: 1.0)

var ref = Database.database().reference()

var usersRef: DatabaseReference {
    return ref.child("users")
}
var needsRef: DatabaseReference {
    return ref.child("needs")
}
var contributionsRef: DatabaseReference {
    return ref.child("contributions")
}
let currentRequests = "currentRequests"
let currentContributions = "currentContributions"
let sub = "sub"
var messagesRef: DatabaseReference {
    return ref.child("messages")
}
var usersMessagesRef: DatabaseReference {
    return ref.child("usersMessages")
}
