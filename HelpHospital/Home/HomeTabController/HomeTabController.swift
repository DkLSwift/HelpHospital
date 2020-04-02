//
//  HomeTabController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = MemberSession.share.isLogged ? createNavController(viewController: HospitalWorkerViewController(), title: "Santé", imageName: "doctor") : createNavController(viewController: HospitalWorkerDisconnectedViewController(), title: "Santé", imageName: "doctor")
        
        viewControllers = [
            vc1,
            createNavController(viewController: HospitalHelperViewController(), title: "Donner", imageName: "team"),
            createNavController(viewController: SettingsViewController(), title: "Paramètres", imageName: "settings")
        ]
        MemberSession.share.listenTo { member in
            self.viewControllers?[0] = member != nil ? self.createNavController(viewController: HospitalWorkerViewController(), title: "Santé", imageName: "doctor") : self.createNavController(viewController: HospitalWorkerDisconnectedViewController(), title: "Santé", imageName: "doctor")
        }
        
        tabBar.barTintColor = seaDarkBlue
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = seaWhite
        tabBar.tintColor = seaLightBlue
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title.capitalized
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barStyle = .black
//        navController.navigationBar.barTintColor = seaDarkBlue
//        navController.navigationBar.titleTextAttributes = [.foregroundColor: seaWhite]
       
        return navController
    }
}
