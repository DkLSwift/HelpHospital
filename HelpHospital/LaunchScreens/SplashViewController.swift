//
//  SplashViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    
    
    let loginRepository = LoginRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        let logo = UIImageView()
        logo.image = UIImage(named: "owl-2")
        view.addSubview(logo)
        logo.centerInSuperview()
        logo.constrainWidth(constant: 300)
        logo.constrainHeight(constant: 200)
        
        view.backgroundColor = seaDarkBlue
           loginRepository.requestAutologin {
//               let vc = HomeTabController()
//               vc.modalPresentationStyle = .fullScreen
//               self.present(vc, animated: true, completion: nil)
           }
           
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
   
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            let vc = HomeTabController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
        
            
        
        
        
    }
}
