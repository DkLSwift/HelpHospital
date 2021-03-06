//
//  MyContributionHeaderCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


protocol MyContributionHeaderCellProtocol: class {
    func addContributionButtonPressed()
}

class MyContributionHeaderCell: UITableViewHeaderFooterView {

    let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        return v
    }()
    
    let desc: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 34)
        lbl.textColor = bluePlus
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.text = "Poster vos contributions."
        return lbl
    }()
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.borderWidth = 1
        btn.layer.borderColor = bluePlus.cgColor
        btn.layer.shadowColor = blueMinus.cgColor
        btn.layer.shadowOffset = .init(width: -1, height: 1)
        btn.layer.shadowRadius = 4
        return btn
    }()
    
    var delegate: MyContributionHeaderCellProtocol?
    
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
        
        container.addSubview(addBtn)
        
        addBtn.constrainWidth(constant: 50)
        addBtn.constrainHeight(constant: 50)
        addBtn.contentEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)

        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        addBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: 30).isActive = true
        addBtn.addTarget(self, action: #selector(handleAddPressed), for: .touchUpInside)
        container.addSubview(desc)
        desc.anchor(top: addBtn.bottomAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
 
    
    @objc func handleAddPressed() {
        delegate?.addContributionButtonPressed()
    }
}
