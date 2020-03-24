//
//  User.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation


public class Member {
    
    var uuid: String?
    var pseudo: String?
    
    init(uuid: String) {
        self.uuid = uuid
    }
}
