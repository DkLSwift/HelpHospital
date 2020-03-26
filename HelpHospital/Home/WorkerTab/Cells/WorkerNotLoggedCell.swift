//
//  WorkerNotLoggedCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 26/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


class WorkerNotLoggedCell: UITableViewCell {

    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 34)
        lbl.text = "Vous devez être connecté pour pouvoir poster vos besoins."
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
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
        addSubview(label)
        label.fillSuperview()
    }
    
    
}
