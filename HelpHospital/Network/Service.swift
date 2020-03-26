//
//  Service.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Service {
    
    
    func getNeeds(for keys: [String], success: @escaping ([Need]) -> Void) {
        
        var needs = [Need]()
        
        keys.forEach { key in
            needsRef.observe(.value) { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    guard let title = value["title"] as? String else { return }
                    let desc = value["desc"] as? String
                    let time = value["time"] as? String

                    let need = Need(title: title, time: time, desc: desc)
                    needs.append(need)
                }
            }
        }
        
        success(needs)
    }
    
}
