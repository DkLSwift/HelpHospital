//
//  HomeTabController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HomeTabController: UITabBarController {
    
    var user: Member?

//    init(user: Member) {
//        super.init()
//        self.user = user
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: HospitalWorkerViewController(), title: "Santé", imageName: "☣︎"),
            createNavController(viewController: HospitalHelperViewController(), title: "Donneur", imageName: "⚉"),
            createNavController(viewController: SettingsViewController(), title: "Paramètres", imageName: "✿")
        ]
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
