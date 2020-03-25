//
//  Extensions.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        
        let pView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = pView
        self.leftViewMode = .always
    }
}
