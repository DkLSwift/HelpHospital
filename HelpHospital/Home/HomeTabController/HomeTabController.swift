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
//
//        let vc3 = MemberSession.share.isLogged ? createNavController(viewController: ConversationListController(), title: "Messages", imageName: "messages") : createNavController(viewController: NeedsDisconnectedViewController(), title: "Messages", imageName: "messages")
        
        viewControllers = [
            createNavController(viewController: NeedsPageViewController(), title: "Besoins", imageName: "doctor"),
            createNavController(viewController: ContributionPageViewController(), title: "Contributions", imageName: "team"),
            createNavController(viewController: ConversationListController(), title: "Messages", imageName: "messages"),
            createNavController(viewController: SettingsViewController(), title: "Paramètres", imageName: "settings")
        ]
//        MemberSession.share.listenTo { member in
//            self.viewControllers?[2] = member != nil ?  self.createNavController(viewController: ConversationListController(), title: "Messages", imageName: "messages") : self.createNavController(viewController: NeedsDisconnectedViewController(), title: "Messages", imageName: "messages")
//        }
        
        tabBar.barTintColor = bluePlus
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = blueMinus
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
//        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barStyle = .black
        navController.navigationBar.barTintColor = blue
//        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navController.navigationBar.tintColor = .white
        
        return navController
    }
}
