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
        member != nil
    }
    
    var userDidSet: [((Member?) -> Void)] = []
    
    func listenTo(block: @escaping ((Member?) -> Void)) {
        userDidSet.append(block)
    }
    
    var member: Member? {
        didSet {
            userDidSet.forEach {$0(member)}
        }
    }
    
}
