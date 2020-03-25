//
//  SplashViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let defaults = UserDefaults.standard
        
        if let id = defaults.value(forKey: "UserId") as? String {
            
            let user = Member(uuid: id)
            
            if let pseudo = defaults.value(forKey: "pseudo") as? String {
                user.pseudo = pseudo
            }
            MemberSession.share.isLogged = true
            MemberSession.share.user = user
        }
        
        let vc = HomeTabController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
