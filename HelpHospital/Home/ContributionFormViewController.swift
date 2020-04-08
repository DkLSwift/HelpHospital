//
//  ContributionFormViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import CoreLocation

class ContributionFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    let titleLabel: HelpyLabel = {
        let lbl = HelpyLabel(text: "Vos contributions seront visibles 1 kilomètre autour de la position à laquelle vous l'enregistrez.", fontSize: 28, alignment: .center)
        lbl.numberOfLines = 0
        return lbl
    }()
    let titleTF: TF = {
        let tf = TF(placeholder: "Nourriture, chambre, service...")
        return tf
    }()
    let descTV: UITextView = {
        let tv = UITextView()
//        tv.backgroundColor = seaDarkBlue
        tv.layer.borderColor = bluePlus.cgColor
        tv.layer.borderWidth = 1
        tv.text = " Je propose..."
        tv.textColor = blueMinus
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv
    }()
    
    
    let acceptButton = HelpyButton(title: "VALIDER")
    

    var locationManager = LocationManager()
    var mainVC: MyNeedsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.hideKeyboardWhenTapOutsideTextField()
        titleTF.delegate = self
        descTV.delegate = self
        
        locationManager.setup()
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
        
        
        [titleTF, acceptButton].forEach( { $0.constrainHeight(constant: 44)} )
        descTV.constrainHeight(constant: 150)
        
        acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        
        let tfStack = UIStackView(arrangedSubviews: [titleTF, descTV,])
        tfStack.axis = .vertical
        tfStack.spacing = 20
        
        let vStack = UIStackView(arrangedSubviews: [tfStack, acceptButton])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        view.addSubview(vStack)
        vStack.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 60, right: 20))
    }
    
    @objc func handleAccept() {
        
        guard let location = locationManager.location, let id = MemberSession.share.member?.uuid, let key = contributionsRef.childByAutoId().key else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Vérifiez votre réseau ou les autorisations d'accès à la géolocalisation de votre téléphone", action: "Ok")
            return
        }
        
        if let title = titleTF.text {
            let desc = descTV.text
            
            guard title != "" else {
                Utils.callAlert(vc: self, title: "Erreur", message: "Vous devez renseigner un titre", action: "Ok")
                return
            }
            
            let timestamp = Double(Date().timeIntervalSince1970)
            locationManager.postContribution(from: location, key: key, id: id, title: title, desc: desc, timestamp: timestamp)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == blueMinus {
            textView.text = nil
            textView.textColor = bluePlus
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = " Je propose..."
            textView.textColor = blueMinus
        }
    }
}
