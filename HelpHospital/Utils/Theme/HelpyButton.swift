//
//  HelpyButton.swift
//  HelpHospital
//
//  Created by Eric DkL on 02/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit



class HelpyButton: UIButton {
    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.borderColor = bluePlus.cgColor
        constrainHeight(constant: 50)
        constrainWidth(constant: 200)
        layer.borderWidth = 1
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setTitleColor(bluePlus, for: .normal)
        setTitle(title, for: .normal)
        layer.cornerRadius = 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
