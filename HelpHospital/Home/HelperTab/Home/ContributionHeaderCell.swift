//
//  ContributionHeaderCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 05/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.

import UIKit

class ContributionHeaderCell: UITableViewHeaderFooterView {

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
        lbl.text = "Voir les besoins dans un rayon d'1 kilomètre."
        return lbl
    }()
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = bluePlus
        lbl.text = "Ou proposer des contributions"
        return lbl
    }()

    let btn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(bluePlus, for: .normal)
        btn.setTitle(">>", for: .normal)
        return btn
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
        
        btn.constrainWidth(constant: 44)
        btn.constrainHeight(constant: 44)
        
        let hStack = UIStackView(arrangedSubviews: [label, btn])
        let vStack = UIStackView(arrangedSubviews: [desc, hStack])
        vStack.axis = .vertical
        
        container.addSubview(vStack)
        vStack.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }
}
