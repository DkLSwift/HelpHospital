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
                ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    let user = Member(uuid: id)
                    user.pseudo = value?["pseudo"] as? String ?? ""
                    
                    MemberSession.share.user = user
                    
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
                            let user = Member(uuid: id)
                            
                            let resDict = result as? NSDictionary
                            let firstName = resDict?["first_name"] as? String ?? ""
                            
                            ref.child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                                
                                let value = snapshot.value as? NSDictionary
                                user.pseudo = value?["pseudo"] as? String ?? ""
                                
                                if user.pseudo == "" {
                                    user.pseudo = firstName
                                    usersRef.child(id).updateChildValues([
                                        "pseudo" : firstName
                                    ])
                                }
                                MemberSession.share.user = user
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
                let user = Member(uuid: id)
                user.pseudo = pseudo
                MemberSession.share.user = user
                
                usersRef.child(id).updateChildValues([
                    "id": id,
                    "pseudo" : pseudo
                ])
                
                success()
            }
        }
    }
    
    
    func requestAutologin() {
        if let id = Auth.auth().currentUser?.uid {
            
            usersRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
                
                let user = Member(uuid: id)
                let value = snapshot.value as? NSDictionary
                user.pseudo = value?["pseudo"] as? String ?? ""
                MemberSession.share.user = user
            }
        } else {
            MemberSession.share.user = nil
        }
    }
}
