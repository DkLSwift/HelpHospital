//
//  MemberSession.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation

class MemberSession {
    
    public static let share = MemberSession()
    
    var isLogged = false
    
    var user: Member?
    
}
