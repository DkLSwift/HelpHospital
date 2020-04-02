//
//  Settings.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase


protocol SettingsViewProtocol: class {
    func didConnect()
    func didDisconnect()
}

class SettingsViewController: UIViewController {

    
    weak var delegate: SignInViewProtocol?
    
    let connectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = seaDarkBlue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Se connecter", for: .normal)
        btn.setTitleColor(seaWhite, for: .normal)
        btn.constrainHeight(constant: 50)
        btn.constrainWidth(constant: 200)
        btn.layer.borderColor = seaWhite.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let pseudoLabel: UILabel = {
           let lbl = UILabel()
           lbl.font = UIFont.systemFont(ofSize: 30)
           lbl.textColor = seaWhite
           lbl.textAlignment = NSTextAlignment.center
           return lbl
       }()
    let changePseudoBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = seaDarkBlue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Changer", for: .normal)
        btn.setTitleColor(seaWhite, for: .normal)
        return btn
    }()
    
    let disconnectBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = seaDarkBlue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitle("Se déconnecter", for: .normal)
        btn.setTitleColor(seaWhite, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = seaDarkBlue
        
        MemberSession.share.listenTo { _ in
            if !MemberSession.share.isLogged {
                self.setupConnect()
            } else {
                self.changeUI()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !MemberSession.share.isLogged {
                  self.setupConnect()
              } else {
                  self.changeUI()
              }
    }
    func setupConnect() {
        view.addSubview(connectButton)
//        connectButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 44))
        
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -140).isActive = true
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        connectButton.addTarget(self, action: #selector(handleConnection), for: .touchUpInside)
    }
    
    func setupUI() {
        [ pseudoLabel, changePseudoBtn].forEach { $0.constrainHeight(constant: 44) }
        let hStack = UIStackView(arrangedSubviews: [pseudoLabel, UIView(), changePseudoBtn])
        view.addSubview(hStack)
        hStack.axis = .horizontal
        hStack.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 200, left: 30, bottom: 0, right: 30))
        if MemberSession.share.member?.pseudo != "" {
            pseudoLabel.text = MemberSession.share.member?.pseudo
        } else {
            pseudoLabel.text = "Pseudo"
        }
    
        changePseudoBtn.addTarget(self, action: #selector(handlePseudoChange), for: .touchUpInside)
        
        view.addSubview(disconnectBtn)
        disconnectBtn.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 150, right: 20), size: .init(width: 150, height: 44))
        
        disconnectBtn.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
    }
    
    @objc func handlePseudoChange() {
        let ac = UIAlertController(title: "Nouveau Pseudo", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Valider", style: .default) { [unowned ac] _ in
            let input = ac.textFields![0]
            
            guard let pseudo = input.text else { return }
            if pseudo != "" {
                guard let id = MemberSession.share.member?.uuid else { return }
                self.pseudoLabel.text = pseudo
                MemberSession.share.member?.pseudo = pseudo
                
                usersRef.child(id).updateChildValues(["pseudo" : pseudo])
            }
            
        }

        ac.addAction(submitAction)

        self.present(ac, animated: true)
        
    }
    
    @objc func handleConnection() {
        let vc = LogInViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    @objc func handleLogOut() {
        LoginManager().logOut()
        do {
            try Auth.auth().signOut()
        } catch let err {
            Utils.callAlert(vc: self, title: "Erreur", message: err.localizedDescription, action: "Ok")
        }
        
        MemberSession.share.member = nil
        
        removeConnectedUI()
    }
    
    func removeConnectedUI() {
        [pseudoLabel, changePseudoBtn, disconnectBtn].forEach { $0.removeFromSuperview() }
        setupConnect()
    }
}

extension SettingsViewController: SignInViewProtocol {
    
    
    func didSignInAccount() {
        changeUI()
    }
    
    func changeUI() {
        connectButton.removeFromSuperview()
        setupUI()
    }
    
}
