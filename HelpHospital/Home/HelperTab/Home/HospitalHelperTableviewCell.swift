//
//  HospitalHelperTableviewCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HospitalHelperTableviewCell: UITableViewCell {

    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = seaLightBlue
        return v
    }()
    let insetView: UIView = {
        let v = UIView()
        v.backgroundColor = seaDarkBlue
        return v
    }()
    
    let pseudoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.textColor = seaWhite
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = seaWhite
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
        
        addSubview(containerView)
        containerView.fillSuperview()
        
        containerView.addSubview(insetView)
        insetView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 2, right: 0))
        
        let hStack = UIStackView(arrangedSubviews: [pseudoLabel, titleLabel])
        addSubview(hStack)
        hStack.backgroundColor = clearBlue
        hStack.distribution = .fillEqually
        hStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30), size: .init(width: 200, height: 0))
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       
    }
    
    
}
