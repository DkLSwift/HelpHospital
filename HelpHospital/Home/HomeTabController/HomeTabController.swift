//
//  HomeTabController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = MemberSession.share.isLogged ? createNavController(viewController: HospitalWorkerViewController(), title: "Santé", imageName: "☣︎") : createNavController(viewController: HospitalWorkerDisconnectedViewController(), title: "Santé", imageName: "☣︎")
        
        viewControllers = [
            vc1,
            createNavController(viewController: HospitalHelperViewController(), title: "Donner", imageName: "⚉"),
            createNavController(viewController: SettingsViewController(), title: "Paramètres", imageName: "✿")
        ]
        MemberSession.share.listenTo { member in
            self.viewControllers?[0] = member != nil ? self.createNavController(viewController: HospitalWorkerViewController(), title: "Santé", imageName: "☣︎") : self.createNavController(viewController: HospitalWorkerDisconnectedViewController(), title: "Santé", imageName: "☣︎")
        }
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
