//
//  NeedDetailViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 27/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class NeedDetailViewController: UIViewController {

    var need: Need!
    
    let pseudoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 34)
        lbl.textColor = seaWhite
        lbl.textAlignment = .center
        return lbl
    }()
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = seaWhite
        lbl.font = UIFont.systemFont(ofSize: 28)
        return lbl
    }()
    
    let descLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = seaWhite
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 24)
        lbl.textColor = seaWhite
        return lbl
    }()
    
    let contactBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.layer.borderColor = seaWhite.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("Contacter", for: .normal)
        btn.setTitleColor(seaWhite, for: .normal)
        btn.backgroundColor = seaDarkBlue
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = seaDarkBlue
        setup()
    }
    
    func setup() {
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        [pseudoLabel, titleLabel, timeLabel, contactBtn].forEach({$0.constrainHeight(constant: 44)})
        contactBtn.constrainWidth(constant: 200)
        
        view.addSubview(contactBtn)
        contactBtn.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 120, right: 0))
        contactBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let lStack = UIStackView(arrangedSubviews: [pseudoLabel, titleLabel, timeLabel])
        lStack.axis = .vertical
        lStack.spacing = 24
        
        let vStack = UIStackView(arrangedSubviews: [lStack, descLabel])
        vStack.axis = .vertical
        vStack.spacing = 20
        
        view.addSubview(vStack)
        vStack.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: contactBtn.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 40, left: 20, bottom: 40, right: 20))
        
        contactBtn.addTarget(self, action: #selector(handleContact), for: .touchUpInside)
        
        guard let need = need else { return }
        
        pseudoLabel.text = need.pseudo
        titleLabel.text = "Besoin : " + need.title
        
        if need.desc != "" {
            descLabel.text = need.desc
        }
        if need.time != "" {
            timeLabel.text = " Vers \(need.time!)"
        }
    }
    
    @objc func handleContact() {
        let vc = ChatController()
        vc.title = need.pseudo
        vc.need = need
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
