//
//  HelpyLabel.swift
//  HelpHospital
//
//  Created by Eric DkL on 02/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit



class HelpyLabel: UILabel {
    init(frame: CGRect = .zero, text: String, fontSize: CGFloat, alignment: NSTextAlignment = .left) {
        super.init(frame: frame)
        
        self.text = text
        font = UIFont.systemFont(ofSize: fontSize)
        textColor = seaWhite
        textAlignment = alignment
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

