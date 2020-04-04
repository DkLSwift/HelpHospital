//
//  Need.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation

struct Need: Decodable {
    
    let title, id, pseudo, workerId: String
    let time, desc: String?
    let timestamp: Double
}
