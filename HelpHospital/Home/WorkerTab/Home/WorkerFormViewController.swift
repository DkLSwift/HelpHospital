//
//  WorkerFormViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 27/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import CoreLocation

class WorkerFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.text = "Vos Besoins seront visibles 1 kilomètre autour de la position à laquelle vous l'enregistrez."
        lbl.textColor = seaWhite
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let titleTF: TF = {
        let tf = TF(placeholder: "Titre")
        return tf
    }()
    let descTV: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = seaDarkBlue
        tv.layer.borderColor = seaWhite.cgColor
        tv.layer.borderWidth = 1
        tv.text = "  Description..."
        tv.textColor = seaWhite
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv
    }()
    
    let timeTF: TF = {
        let tf = TF(placeholder: "Heure approximative")
        return tf
    }()
    
    let acceptButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = seaDarkBlue
        btn.layer.borderColor = seaWhite.cgColor
        btn.constrainHeight(constant: 50)
        btn.constrainWidth(constant: 200)
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Valider", for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    var locationManager = LocationManager()
    var mainVC: HospitalWorkerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = seaDarkBlue
        
        self.hideKeyboardWhenTapOutsideTextField()
        [titleTF, timeTF].forEach({ $0.delegate = self })
        descTV.delegate = self
        
        locationManager.setup()
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
        
        
        [titleTF, timeTF, acceptButton].forEach( { $0.constrainHeight(constant: 44)} )
        descTV.constrainHeight(constant: 150)
        
        acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        
        let tfStack = UIStackView(arrangedSubviews: [titleTF, descTV, timeTF,])
        tfStack.axis = .vertical
        tfStack.spacing = 20
        
        let vStack = UIStackView(arrangedSubviews: [tfStack, acceptButton])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        view.addSubview(vStack)
        vStack.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 60, right: 20))
    }
    
    @objc func handleAccept() {
        
        guard let location = locationManager.location, let id = MemberSession.share.member?.uuid, let key = needsRef.childByAutoId().key else { return }
        
        if let title = titleTF.text {
            let desc = descTV.text
            let time = timeTF.text
            
            guard title != "" else {
                Utils.callAlert(vc: self, title: "Erreur", message: "Vous devez renseigner un titre", action: "Ok")
                return
            }
            locationManager.postNeed(from: location, key: key, id: id, title: title, desc: desc, time: time)
            mainVC?.fetchCurrentUserNeedsAndReloadTVData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "  Description..."
            textView.textColor = .lightGray
        }
    }
}
