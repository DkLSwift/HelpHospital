//
//  AllContributionsHeaderCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class AllContributionsHeaderCell: UITableViewHeaderFooterView {

    let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        return v
    }()
    
    let desc: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 40)
        lbl.textColor = bluePlus
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.text = "Parcourir les contributions alentours"
        return lbl
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        addSubview(container)
        container.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 12))
        
        
        container.addSubview(desc)
        desc.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))

    }
}
