//
//  CreateAccountViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol CreateAccountViewProtocol: class {
    func didCreateAccount()
}

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Création de compte"
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.numberOfLines = 0
        lbl.textColor = dark
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()

    let pseudoTF: TF = {
        let tf = TF(placeholder: "Pseudonyme")
        return tf
    }()
    let mailTF: TF = {
        let tf = TF(placeholder: "E-mail")
        tf.keyboardType = .emailAddress
        return tf
    }()
    let passwordTF: TF = {
        let tf = TF(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    let confirmPasswordTF: TF = {
        let tf = TF(placeholder: "Confirmez le password")
        tf.isSecureTextEntry = true
        return tf
    }()
    let createAccountButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Créer", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = dark.cgColor
        return btn
    }()
    
    var ref = Database.database().reference()
    weak var delegate: CreateAccountViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup()
    }
    
    func setup() {
        
        var safeTopAnchor = view.topAnchor
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
        }
        
        view.addSubview(topLabel)
        topLabel.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 34, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
        
        [pseudoTF, mailTF, passwordTF, confirmPasswordTF, createAccountButton].forEach { $0.constrainHeight(constant: 44)}
        let vStack = UIStackView(arrangedSubviews: [pseudoTF, mailTF, passwordTF, confirmPasswordTF, createAccountButton])
        view.addSubview(vStack)
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 18
        vStack.anchor(top: topLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 34, left: 30, bottom: 0, right: 30))
        
        createAccountButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
    }
    
    func createUser(mail: String, password: String, pseudo: String) {
        
        Auth.auth().createUser(withEmail: mail, password: password) {
            (authResult, error) in
            if error != nil {
                print(error!)
            }else{
                guard let id = authResult?.user.uid else { return }
                let user = Member(uuid: id)
                user.pseudo = pseudo
                
                UserDefaults.standard.set(user.uuid, forKey: "UserId")
                UserDefaults.standard.set(user.pseudo, forKey: "pseudo")
                
                self.ref.child("users").child(id).updateChildValues([
                    "id": id,
                    "pseudo" : pseudo
                ])
                
                MemberSession.share.isLogged = true
                MemberSession.share.user = user
                self.delegate?.didCreateAccount()
                
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleCreate() {
        guard let mail = mailTF.text, let pseudo = pseudoTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text else { return }
        
        if mail != "" && pseudo != "" && password != "" && confirmPassword != "" {
            if Utils.checkMail(mail: mail) {
                if password == confirmPassword {
                    
                    if password.count >= 6 {
                        createUser(mail: mail, password: password, pseudo: pseudo)
                    } else {
                        Utils.callAlert(vc: self, title: "Erreur", message: "Le password doit contenir au moins 6 caractères.", action: "Ok")
                    }
                } else {
                    Utils.callAlert(vc: self, title: "Erreur", message: "Les passwords entrés sont différents.", action: "Ok")
                }
            } else {
                Utils.callAlert(vc: self, title: "Erreur", message: "L'e-mail est invalide.", action: "Ok")
            }
        } else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Un champs de texte est vide.", action: "Ok")
        }
    }
    
}
