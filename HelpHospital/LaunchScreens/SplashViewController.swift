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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loginRepository.requestAutologin()
        
        
            let vc = HomeTabController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        
        
        
    }
}
