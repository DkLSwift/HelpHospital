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
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Se connecter", for: .normal)
        btn.setTitleColor(bluePlus, for: .normal)
        btn.constrainHeight(constant: 50)
        btn.constrainWidth(constant: 200)
        btn.layer.borderColor = bluePlus.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let pseudoTx: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = bluePlus
        lbl.text = "Pseudo"
        lbl.alpha = 0.7
        return lbl
    }()
    
    let pseudoLabel: UILabel = {
           let lbl = UILabel()
           lbl.font = UIFont.systemFont(ofSize: 30)
           lbl.textColor = bluePlus
           lbl.textAlignment = NSTextAlignment.center
           return lbl
       }()
    let changePseudoBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Changer", for: .normal)
        btn.setTitleColor(bluePlus, for: .normal)
        return btn
    }()
    let HowItWorkBtn: UIButton = {
           let btn = UIButton()
           btn.backgroundColor = .clear
           btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
           btn.setTitle("Comment ça marche", for: .normal)
           btn.setTitleColor(bluePlus, for: .normal)
           return btn
       }()
    let disconnectBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btn.setTitle("Se déconnecter", for: .normal)
        btn.setTitleColor(bluePlus, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
            pseudoLabel.text = " ---- "
        }
        view.addSubview(pseudoTx)
        pseudoTx.anchor(top: nil, leading: view.leadingAnchor, bottom: hStack.topAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 10, right: 0), size: .init(width: 0, height: 30))
    
        changePseudoBtn.addTarget(self, action: #selector(handlePseudoChange), for: .touchUpInside)
        
        
        view.addSubview(disconnectBtn)
        disconnectBtn.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 150, right: 0), size: .init(width: 0, height: 44))
        
        disconnectBtn.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        
        view.addSubview(HowItWorkBtn)
        HowItWorkBtn.anchor(top: nil, leading: view.leadingAnchor, bottom: disconnectBtn.topAnchor, trailing: nil, padding: .init(top: 0, left: 30, bottom: 50, right: 0), size: .init(width: 0, height: 40))
        
        HowItWorkBtn.addTarget(self, action: #selector(showSlideVC), for: .touchUpInside)
    }
    
    @objc func showSlideVC() {
        let vc = OnBoardingPageController()
        vc.isDismissable = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
        [pseudoTx ,pseudoLabel, changePseudoBtn, disconnectBtn].forEach { $0.removeFromSuperview() }
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
