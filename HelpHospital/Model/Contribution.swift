//
//  Contribution.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation

struct Contribution: Decodable {
    
    let title, id, pseudo, senderId: String
    let desc: String?
    let timestamp: Double
    var iSub: Bool? = false
}
