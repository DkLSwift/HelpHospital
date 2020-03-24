//
//  LoginView.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseUI
import Firebase
import FirebaseAuth

protocol LoginViewProtocol {
    func createAccount()
    func connect(mail: String, password: String)
    func fbLogin()
}

class LoginView: UIView, UITextFieldDelegate {
    
    let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bienvenue sur l'application d'entraide contre le coco"
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = dark
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()
    
    let connectLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Se connecter"
        lbl.font = UIFont.systemFont(ofSize: 30)
        lbl.textColor = dark
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()
    
    let mailTF: TF = {
        let tf = TF(placeholder: "E-mail")
        return tf
    }()
    let passwordTF: TF = {
        let tf = TF(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    let connectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Connexion", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = dark.cgColor
        return btn
    }()
    
    let createAccountButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Créer un compte", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = dark.cgColor
        return btn
    }()
    
    var fbsdkButton: FBLoginButton?
    var delegate: LoginViewProtocol?
    var ref = Database.database().reference()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        var safeTopAnchor = topAnchor
        if #available(iOS 11.0, *) {
            safeTopAnchor = safeAreaLayoutGuide.topAnchor
        }
        
        addSubview(welcomeLabel)
        welcomeLabel.anchor(top: safeTopAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 34, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
    
        fbsdkButton = FBLoginButton()
        fbsdkButton?.removeConstraints(fbsdkButton!.constraints)
        connectButton.constrainWidth(constant: 250)
        [fbsdkButton!, mailTF, passwordTF, connectButton].forEach({ $0.constrainHeight(constant: 44)})
        
        let vStack = UIStackView(arrangedSubviews: [fbsdkButton!, mailTF, passwordTF, connectButton])
        addSubview(vStack)
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.spacing = 18
        vStack.anchor(top: welcomeLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 34, left: 30, bottom: 0, right: 30))
        connectButton.addTarget(self, action: #selector(handleConnect), for: .touchUpInside)
        
        let separator = UIView()
        separator.backgroundColor = dark
        addSubview(separator)
        separator.anchor(top: vStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 30, left: 60, bottom: 0, right: 60), size: .init(width: 0, height: 1))
        
        addSubview(createAccountButton)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.constrainHeight(constant: 44)
        createAccountButton.constrainWidth(constant: 194)
        createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createAccountButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 24).isActive = true
        createAccountButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
    }
    @objc func handleCreate() {
        delegate?.createAccount()
    }
    @objc func handleConnect(_ fbLogin: Bool = false) {
        guard let mail = mailTF.text, let password = passwordTF.text else { return }
        delegate?.connect(mail: mail, password: password)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}

extension LoginView {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton){
        print("User did disconnect ... ")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else{
            loginButton.permissions = ["public_profile", "email"]
            if AccessToken.current  != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) {  (authResult, error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        self.fetchUserInfo(AuthId: (authResult?.user.uid)!)
                    }
                }
            }
        }
    }
    
    func fetchUserInfo( AuthId : String) -> Void {
        
        if (AccessToken .current != nil) {
            let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,gender,birthday,email,first_name,last_name,name,picture.width(480).height(480)"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if let err = error {
                    print("Error: \(err.localizedDescription)")
                } else {
                    let user = Member(uuid: AuthId)
                    self.ref.child("users").child(AuthId).observeSingleEvent(of: .value) { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        user.pseudo = value?["pseudo"] as? String ?? ""
                        
                        self.delegate?.fbLogin()
                    }
                }
            })
        }
    }
}
