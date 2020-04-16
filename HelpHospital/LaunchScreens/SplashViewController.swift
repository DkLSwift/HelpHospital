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
        logo.image = UIImage(named: "logo-clear")
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        logo.centerInSuperview()
        logo.constrainWidth(constant: 300)
        logo.constrainHeight(constant: 200)
        
        
        let HelpyLbl = UILabel()
        HelpyLbl.textColor = blue
        HelpyLbl.text = "HELPY"
        HelpyLbl.textAlignment = .center
        HelpyLbl.font = .systemFont(ofSize: 60)
        view.addSubview(HelpyLbl)
        HelpyLbl.anchor(top: logo.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 60))
        
           loginRepository.requestAutologin {
//               let vc = HomeTabController()
//               vc.modalPresentationStyle = .fullScreen
//               self.present(vc, animated: true, completion: nil)
           }
           
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
   
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            
            let vc = MemberSession.share.isLogged ? HomeTabController() : OnBoardingPageController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            
        })
        
            
        
        
        
    }
}
