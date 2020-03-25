//
//  HospitalWorkerNeedsCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

protocol HospitalWorkerNeedsCellProtocol: class {
    
}

class HospitalWorkerNeedsCell: UITableViewCell {

    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let deleteNeedBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.layer.cornerRadius = 6
        btn.layer.borderColor = dark.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    weak var delegate: HospitalWorkerNeedsCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0), size: .init(width: 200, height: 0))
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(deleteNeedBtn)
        deleteNeedBtn.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 30), size: .init(width: 44, height: 44))
        deleteNeedBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
}

