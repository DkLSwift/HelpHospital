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
            ref.child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                user.pseudo = value?["pseudo"] as? String ?? ""
                
                UserDefaults.standard.set(user.uuid, forKey: "UserId")
                UserDefaults.standard.set(user.pseudo, forKey: "pseudo")
                
                
                DispatchQueue.main.async {
                    let vc = HomeViewController()
                    vc.user = user
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        } else {
            let vc = LogInViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
