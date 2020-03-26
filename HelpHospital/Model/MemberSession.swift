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
    
    var isLogged: Bool {
        user != nil
    }
    
    var userDidSet: ((Member?) -> Void)?
    var user: Member? {
        didSet {
            userDidSet?(user)
        }
    }
    
}
