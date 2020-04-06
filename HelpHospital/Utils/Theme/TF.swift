//
//  TF.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class TF: UITextField {
    init(frame: CGRect = .zero, placeholder: String) {
        super.init(frame: frame)
        
        self.placeholder = placeholder
        autocorrectionType = .no
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        contentVerticalAlignment = .center
        textColor = bluePlus
        layer.borderColor = bluePlus.cgColor
        layer.borderWidth = 1
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: blueMinus])
        setLeftPaddingPoints(10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
