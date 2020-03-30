//
//  ConversationListCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {
    
    let pseudoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = .lightGray
//        lbl.minimumScaleFactor = 0.6
//        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22)
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
       
    
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)

          setup()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    func setup() {
        
        pseudoLabel.constrainHeight(constant: 30)
        let vStack = UIStackView(arrangedSubviews: [pseudoLabel, messageLabel])
        vStack.axis = .vertical
        
        timeLabel.constrainWidth(constant: 70)
        let hStack = UIStackView(arrangedSubviews: [vStack, timeLabel])
        
        
        addSubview(hStack)
        hStack.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
    }

}
