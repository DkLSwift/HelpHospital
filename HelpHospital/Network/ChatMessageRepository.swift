//
//  ChatMessageRepository.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatMessageRepository {
    
    
//    worker id -> need id ->
    
    func postMessage(workerId: String, currentUserId: String, needId: String, message: Message, success: @escaping () -> Void) {
        
        
        let ref = messagesRef.child(workerId).child(needId)
        let childRef = ref.childByAutoId()
        guard let key = childRef.key else { return }
        
        let data: [String:Any] = [
            "text": message.text,
            "toId": message.toId,
            "fromId": message.fromId,
            "timestamp": message.timestamp
        ]
        
        childRef.setValue(data)
        
        usersMessagesRef.child(currentUserId).child(needId).child(key).setValue([key: "1"])
        
        success()
        
    }

    
    
    func observeRegistredTopic(success: @escaping ([String]) -> Void) {
        guard let id = MemberSession.share.member?.uuid else { return }
        
        var keys = [String]()
        usersMessagesRef.child(id).observe(.value) { (snapshot) in
            
            let value = snapshot.value as? [String: Any]
            
            value?.forEach({ (val) in
                keys.append(val.key)
            })
            
            success(keys)
        }
    }
}
