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
        lbl.font = UIFont.systemFont(ofSize: 36)
        return lbl
    }()
    
    weak var delegate: HospitalWorkerNeedsCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleGoButton() {
        
    }
}

