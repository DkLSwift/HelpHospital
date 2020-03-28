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
        
        
        let ref = messagesRef.child(needId)
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
    
    func getConversationMessages(conversationsId: [String]?, success: @escaping ([String: [Message]]) -> Void) {
        
        guard let keys = conversationsId else { return }
        
        var conversationsAndMessages = [String: [Message]]()
        
        let dispatchGroup = DispatchGroup()
        
        keys.forEach({
            dispatchGroup.enter()
            let id = $0
            messagesRef.child(id).observe(.value) { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    var messages = [Message]()
                    
                    dictionary.forEach { (key, value) in
                        if let dict = value as? NSDictionary {
                            guard let fromId = dict["fromId"] as? String,
                                let toId = dict["toId"] as? String,
                                let text = dict["text"] as? String,
                                let timestamp = dict["timestamp"] as? Double else { return }
                            
                            let message = Message(text: text, fromId: fromId, toId: toId, timestamp: timestamp)
                            
                            messages.append(message)
                            
                        }
                    }
                    conversationsAndMessages[id] = messages
                }
                dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main){
            success(conversationsAndMessages)
        }
    }
}
