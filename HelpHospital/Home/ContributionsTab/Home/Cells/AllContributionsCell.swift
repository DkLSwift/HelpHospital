//
//  AllContributionsCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 08/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


protocol AllContributionsCellProtocol {
    func favButtonPressed(id: String, doSub: Bool)
}

class AllContributionsCell: UITableViewCell {

    let insetView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.backgroundColor = .white
        v.layer.shadowColor = bluePlus.cgColor
        v.layer.shadowOffset = .init(width: -0.5, height: 0.5)
        v.layer.shadowRadius = 3
        v.layer.shadowOpacity = 0.5
        return v
    }()
    
    let pseudoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.textColor = bluePlus
        return lbl
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.textColor = bluePlus
        return lbl
    }()
    
    let fullStar = UIImage(named: "full-star")
    let emptyStar = UIImage(named: "empty-star")
    
    let favButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "empty-star"), for: .normal)
        return btn
    }()
    
    var delegate: AllContributionsCellProtocol?
    var id: String!
    var sub: Bool? {
        didSet {
            if sub == true {
                favButton.imageView?.image = fullStar
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(insetView)
        insetView.fillSuperview(padding: .init(top: 3, left: 12, bottom: 3, right: 12))
        
    
        addSubview(favButton)
        favButton.constrainWidth(constant: 40)
        favButton.constrainHeight(constant: 40)
        favButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        favButton.addTarget(self, action: #selector(handleFavButton), for: .touchUpInside)
        
        let hStack = UIStackView(arrangedSubviews: [pseudoLabel, titleLabel])
        addSubview(hStack)
        hStack.backgroundColor = clearBlue
        hStack.distribution = .fillEqually
        hStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: favButton.leadingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30), size: .init(width: 200, height: 0))
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       
    }
    
    @objc func handleFavButton() {
        if favButton.imageView?.image == emptyStar {
              favButton.setImage(fullStar, for: .normal)
            delegate?.favButtonPressed(id: id, doSub: true)
        } else {
            favButton.setImage(emptyStar, for: .normal)
            delegate?.favButtonPressed(id: id, doSub: false)
        }
    }
    
}
