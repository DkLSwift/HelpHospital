//
//  HospitalWorkerViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HospitalWorkerViewController: UIViewController {

    let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "C'est ici que le personnel soignant peut poster les besoins, connexion requise."
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = dark
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MemberSession.share.isLogged {
            
        } else {
            setupDisconnectedUI()
        }
        
    }
    func setupDisconnectedUI() {
        view.addSubview(topLabel)
         topLabel.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
    }
    
    func setupConnectedUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    }

    @objc func handleAdd() {
        
    }
}
