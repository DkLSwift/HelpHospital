//
//  WorkerFormViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 27/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import CoreLocation

class WorkerFormViewController: UIViewController {

    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.text = "Vos Besoins"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let titleTF: TF = {
        let tf = TF(placeholder: "Titre")
        return tf
    }()
    let descTF: TF = {
        let tf = TF(placeholder: "Description")
        
        return tf
    }()
    let timeTF: TF = {
        let tf = TF(placeholder: "Heure approximative")
        return tf
    }()
    
    let acceptButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = dark
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("VALIDER", for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    
    var locationManager = LocationManager()
    var mainVC: HospitalWorkerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        locationManager.setup()
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 150))
        
        
        [titleTF, timeTF, acceptButton].forEach( { $0.constrainHeight(constant: 44)} )
        descTF.constrainHeight(constant: 150)
        acceptButton.constrainWidth(constant: 200)
        
        acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        
        let tfStack = UIStackView(arrangedSubviews: [titleTF, descTF, timeTF,])
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
            let desc = descTF.text
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
}
