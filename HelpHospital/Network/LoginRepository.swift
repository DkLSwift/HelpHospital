//
//  LoginRepository.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKCoreKit

protocol LoginRepositoryProtocol {
    
    func requestLogin(mail: String, password: String, success: @escaping () -> Void, error: @escaping (Error) -> Void)
    func requestThidPartyLogin(success: @escaping () -> Void, error: @escaping (Error) -> Void)
    func requestAccountCreation(mail: String, password: String, pseudo: String ,success: @escaping () -> Void,  error: @escaping (Error) -> Void)
}


class LoginRepository: LoginRepositoryProtocol {
    
    
    func requestLogin(mail: String, password: String, success: @escaping () -> Void, error: @escaping (Error) -> Void) {
        
        Auth.auth().signIn(withEmail: mail, password: password){
            (authResult, err) in
            if let err = err {
                error(err)
            }else{
                guard let id = authResult?.user.uid else { return }
                usersRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let member = Member(uuid: id)
                    member.pseudo = value?["pseudo"] as? String ?? ""
                    
                    MemberSession.share.member = member
                    
                    success()
                    
                }) { (err) in
                    error(err)
                }
            }
        }
    }
    
    
    func requestThidPartyLogin(success: @escaping () -> Void,  error: @escaping (Error) -> Void) {
        
        if AccessToken.current != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) {  (authResult, err) in
                if let err = err {
                    error(err)
                    
                } else {
                    let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,first_name"])
                    graphRequest.start(completionHandler: { (connection, result, err) -> Void in
                        
                        if let err = err {
                            error(err)
                        } else {
                            guard let id = authResult?.user.uid else { return }
                            let member = Member(uuid: id)
                            
                            let resDict = result as? NSDictionary
                            let firstName = resDict?["first_name"] as? String ?? ""
                            
                            usersRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                                
                                let value = snapshot.value as? NSDictionary
                                member.pseudo = value?["pseudo"] as? String ?? ""
                                
                                if member.pseudo == "" {
                                    member.pseudo = firstName
                                    usersRef.child(id).updateChildValues([
                                        "pseudo" : firstName
                                    ])
                                }
                                MemberSession.share.member = member
                                success()
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func requestAccountCreation(mail: String, password: String, pseudo: String ,success: @escaping () -> Void,  error: @escaping (Error) -> Void) {
        
        Auth.auth().createUser(withEmail: mail, password: password) {
            (authResult, err) in
            if let err = err {
                error(err)
            }else{
                guard let id = authResult?.user.uid else { return }
                let member = Member(uuid: id)
                member.pseudo = pseudo
                MemberSession.share.member = member
                
                usersRef.child(id).updateChildValues([
                    "id": id,
                    "pseudo" : pseudo
                ])
                
                success()
            }
        }
    }
    
    
    func requestAutologin(success: @escaping () -> Void) {
        if let id = Auth.auth().currentUser?.uid {
            
            usersRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                
                let member = Member(uuid: id)
                let value = snapshot.value as? NSDictionary
                member.pseudo = value?["pseudo"] as? String ?? ""
                MemberSession.share.member = member
                success()
            }
        } else {
            MemberSession.share.member = nil
            success()
        }
    }
}
