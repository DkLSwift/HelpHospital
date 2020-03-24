//
//  LogInViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI


class LogInViewController: UIViewController, LoginViewProtocol {
    

    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.delegate = self
        view.addSubview(loginView)
        loginView.fillSuperview()
    }
    
    func createAccount() {
        let vc = CreateAccountViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func connect(mail: String, password: String) {
        
        if mail != "" && password != "" {
            
            let ref = Database.database().reference()
            
            Auth.auth().signIn(withEmail: mail, password: password){
                (authResult, error) in
                if error != nil {
                    Utils.callAlert(vc: self, title: "Erreur", message: "E-mail ou mot de passe invalide", action: "Ok")
                }else{
                    guard let id = authResult?.user.uid else { return }
                    ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        let user = Member(uuid: id)
                        user.pseudo = value?["pseudo"] as? String ?? ""
                        
                        let vc = HomeViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Un champs de texte est vide", action: "Ok")
        }
    }
    func fbLogin() {
        
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

