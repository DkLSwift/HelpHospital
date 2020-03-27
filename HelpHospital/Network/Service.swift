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
        
        let dispatchGroup = DispatchGroup()
        
        keys.forEach { key in
            
            dispatchGroup.enter()
            needsRef.child(key).observe(.value) { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    guard let title = value["title"] as? String, let id = value["id"] as? String else { return }
                    let desc = value["desc"] as? String
                    let time = value["time"] as? String
                    let pseudo = value["pseudo"] as? String
                    let need = Need(title: title, id: id, time: time, desc: desc, pseudo: pseudo)
                    needs.append(need)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main){
            success(needs)
        }
    }
    
    
    func fetchCurrentUserNeeds(id: String, success: @escaping ([Need]) -> Void) {
        
        var needs = [Need]()
        var keys = [String]()
        
        usersRef.child(id).child(currentRequests).observeSingleEvent(of: .value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                values.forEach({
                    guard let key = $0.key as? String else { return }
                    keys.append(key)
                })
                
                let dispatchGroup = DispatchGroup()
                
                keys.forEach { (key) in
                    
                    dispatchGroup.enter()
                    needsRef.child(key).observeSingleEvent(of: .value) { (snapshot) in
                        
                        if let value = snapshot.value as? NSDictionary {
                            guard let title = value["title"] as? String, let id = value["id"] as? String else { return }
                            let desc = value["desc"] as? String
                            let time = value["time"] as? String
                            let pseudo = value["pseudo"] as? String
                            
                            let need = Need(title: title, id: id, time: time, desc: desc, pseudo: pseudo)
                            needs.append(need)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main){
                    success(needs)
                }
            }
        }
    }
    
    
    func deleteDBRef( ref: DatabaseReference, id: String) {
        
        ref.child(id).removeValue()
    }
    
}
