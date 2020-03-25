//
//  UIViewController_ext.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0.0
    }
}
