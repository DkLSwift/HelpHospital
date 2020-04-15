//
//  SecondVC.swift
//  HelpHospital
//
//  Created by Eric DkL on 15/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class SecondSlideVC: UIViewController {
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "see-post")
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let descLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pacourrez / Sauvegardez les besoins et contributions et discutez avec les auteurs"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.textColor = bluePlus
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setup()
    }
    
    func setup() {
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        view.addSubview(descLabel)
        descLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 100, right: 20), size: .init(width: 0, height: 80))
        
        view.addSubview(imgView)
        imgView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: descLabel.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 40, left: 10, bottom: 30, right: 10))
    }
}


