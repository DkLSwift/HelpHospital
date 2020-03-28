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



protocol SignInViewProtocol: class {
    func didSignInAccount()
}


class LogInViewController: UIViewController, LoginViewProtocol {
    

    let loginRepository = LoginRepository()
    
    let loginView = LoginView()
    weak var delegate: SignInViewProtocol?
    
    
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
        
        guard mail != "" && password != "" else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Un champs de texte est vide", action: "Ok")
            return
        }
        
        loginRepository.requestLogin(mail: mail, password: password, success: {
            self.loginView.mailTF.text = ""
            self.loginView.passwordTF.text = ""
            
            self.delegate?.didSignInAccount()
            self.dismiss(animated: true, completion: nil)
        }) { (err) in
            Utils.callAlert(vc: self, title: "Erreur", message: err.localizedDescription, action: "Ok")
        }
    }
    
    func fbLogin() {
        self.delegate?.didSignInAccount()
        self.dismiss(animated: true, completion: nil)
    }
}

