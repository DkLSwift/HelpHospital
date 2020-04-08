//
//  HospitalWorkerDisconnectedViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 27/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class NeedsDisconnectedViewController: UIViewController {
    
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 40)
        lbl.text = "Vous devez être connecté pour pouvoir poster vos besoins."
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = bluePlus
        lbl.backgroundColor = .white
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(messageLabel)
        messageLabel.fillSuperview(padding: .init(top: 0, left: 30, bottom: 0, right: 30))
    }
}
