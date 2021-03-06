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
    
    let service = Service()
    
    func postMessage(senderId: String, currentUserId: String, topicId: String, message: Message, success: @escaping () -> Void) {
        
        
        let ref = messagesRef.child(topicId)
        let childRef = ref.childByAutoId()
        guard let key = childRef.key else { return }
        
        let data: [String:Any] = [
            "text": message.text,
            "toId": message.toId,
            "fromId": message.fromId,
            "myPseudo": message.myPseudo,
            "toPseudo": message.toPseudo,
            "timestamp": message.timestamp
        ]
        
        childRef.setValue(data)
        
        usersMessagesRef.child(currentUserId).child(topicId).child(key).setValue([key: "1"])
        usersMessagesRef.child(message.toId).child(topicId).child(key).setValue([key: "1"])
        
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
            print("enter  ////////////////////")
            let id = $0
            messagesRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    var messages = [Message]()
                    
                    dictionary.forEach { (key, value) in
                        if let dict = value as? NSDictionary {
                            guard let fromId = dict["fromId"] as? String,
                                let toId = dict["toId"] as? String,
                                let text = dict["text"] as? String,
                                let myPseudo = dict["myPseudo"] as? String,
                                let toPseudo = dict["toPseudo"] as? String,
                                let timestamp = dict["timestamp"] as? Double else { return }
                            
                            let message = Message(text: text, fromId: fromId, toId: toId, myPseudo: myPseudo, toPseudo: toPseudo, timestamp: timestamp)
                            
                            messages.append(message)
                        }
                    }
                    conversationsAndMessages[id] = messages
                }
                
                print("leave  *******************")
                dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main){
            print("notify  -----------")
            success(conversationsAndMessages)
        }
    }
    
    func getLastMessagesPreviewData(conversations:[String: [Message]], isNeed: Bool, isSingleTopic: Bool, success: @escaping ([ChatMessagePreview]) -> Void) {
        
        var chatMessagePreviews = [ChatMessagePreview]()
        let dispatchGroup = DispatchGroup()
        
        conversations.forEach { (arg) in
            
            dispatchGroup.enter()
            var toPseudo = ""
            var title = ""
            var lastText = ""
            var toId = ""
            var lastTimestamp: Double = 0
            
            let (key, value) = arg
            
            value.forEach { (message) in
                if MemberSession.share.member?.pseudo != message.toPseudo {
                    toPseudo = message.toPseudo
                }else if MemberSession.share.member?.pseudo != message.myPseudo {
                    toPseudo = message.myPseudo
                }
                if MemberSession.share.member?.uuid != message.toId {
                    toId = message.toId
                } else if MemberSession.share.member?.uuid != message.fromId {
                    toId = message.fromId
                }
                
            }
            
            
            if isSingleTopic {
                if isNeed {
                    service.getNeeds(for: [key]) { (need) in
                        
                        title = need[0].title
                        if let text = value.last?.text {
                            lastText = text
                        }
                        if let timestamp = value.last?.timestamp {
                            lastTimestamp = timestamp
                        }
                        let chatMessage = ChatMessagePreview(pseudo: toPseudo, title: title, text: lastText, key: key, toId: toId, timestamp: lastTimestamp, isContribution: false)
                        chatMessagePreviews.append(chatMessage)
                        dispatchGroup.leave()
                    }
                } else {
                    service.getContributions(for: [key]) { (contrib) in
                        
                        title = contrib[0].title
                        if let text = value.last?.text {
                            lastText = text
                        }
                        if let timestamp = value.last?.timestamp {
                            lastTimestamp = timestamp
                        }
                        let chatMessage = ChatMessagePreview(pseudo: toPseudo, title: title, text: lastText, key: key, toId: toId, timestamp: lastTimestamp, isContribution: true)
                        chatMessagePreviews.append(chatMessage)
                        dispatchGroup.leave()
                    }
                }
            } else {
                service.getNeeds(for: [key]) { (need) in
                    
                    title = need[0].title
                    if let text = value.last?.text {
                        lastText = text
                    }
                    if let timestamp = value.last?.timestamp {
                        lastTimestamp = timestamp
                    }
                    let chatMessage = ChatMessagePreview(pseudo: toPseudo, title: title, text: lastText, key: key, toId: toId, timestamp: lastTimestamp, isContribution: false)
                    chatMessagePreviews.append(chatMessage)
                    dispatchGroup.leave()
                }
                service.getContributions(for: [key]) { (contrib) in
                    
                    title = contrib[0].title
                    if let text = value.last?.text {
                        lastText = text
                    }
                    if let timestamp = value.last?.timestamp {
                        lastTimestamp = timestamp
                    }
                    let chatMessage = ChatMessagePreview(pseudo: toPseudo, title: title, text: lastText, key: key, toId: toId, timestamp: lastTimestamp, isContribution: true)
                    chatMessagePreviews.append(chatMessage)
                    dispatchGroup.leave()
                }
            }
            
            
        }
        dispatchGroup.notify(queue: .main){
            success(chatMessagePreviews)
        }
    }
    
    
    func observeLiveChat(conversationId: String, success: @escaping (Message) -> Void ) {
        
        messagesRef.child(conversationId).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]  {
                guard let fromId = dict["fromId"] as? String,
                    let toId = dict["toId"] as? String,
                    let text = dict["text"] as? String,
                    let myPseudo = dict["myPseudo"] as? String,
                    let toPseudo = dict["toPseudo"] as? String,
                    let timestamp = dict["timestamp"] as? Double else { return }
                
                let message = Message(text: text, fromId: fromId, toId: toId, myPseudo: myPseudo, toPseudo: toPseudo, timestamp: timestamp)
                
                success(message)
            }
        }
    }
    
    
    func clearOldMessagesReferences() {
        
                guard let id = MemberSession.share.member?.uuid else { return }
        let dispatchGroup = DispatchGroup()
                usersMessagesRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                    print(snapshot)
                    
                    if let dictionary = snapshot.value as? [String: Any] {
                    
                    dictionary.forEach { (key, value) in
                        
                      
                        var isNeed = true
                        var isContribution = true
                        dispatchGroup.enter()
                        needsRef.child(key).observeSingleEvent(of: .value) { (snap) in
                            if !snap.exists() {
                                isNeed = false
                            }
                            dispatchGroup.leave()
                        }
                        
                        dispatchGroup.enter()
                         print("enter dispatch")
                        contributionsRef.child(key).observeSingleEvent(of: .value) { (snap) in
                            if !snap.exists() {
                                isContribution = false
                            }
                            dispatchGroup.leave()
                        }
                        dispatchGroup.notify(queue: .main){
                            if !isNeed && !isContribution {
                                print("delete")
                                usersMessagesRef.child(id).child(key).removeValue()
                            } else {
                                print("isNeed = \(isNeed) && isContribution = \(isContribution)")
                            }
                        }
                        }
                    }
                }
    }
}
