//
//  HospitalWorkerNeedsCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class MyNeedsCell: UITableViewCell {

//       let containerView: UIView = {
//           let v = UIView()
//        v.backgroundColor = .white
//           return v
//       }()
       let insetView: UIView = {
           let v = UIView()
        v.layer.cornerRadius = 16
        v.backgroundColor = .white
        v.layer.shadowColor = bluePlus.cgColor
        v.layer.shadowOffset = .init(width: -0.5, height: 0.5)
        v.layer.shadowRadius = 3
        v.layer.shadowOpacity = 0.5
           return v
       }()
       
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 28)
//        lbl.minimumScaleFactor = 0.6
//        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = bluePlus
        return lbl
    }()
    
    let leftArrow: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.tintColor = seaWhite
        btn.setImage(UIImage(named: "left-arrow"), for: .normal)
        return btn
    }()
    
    var needId: String?
//    var delegate: WorkerNeedsCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
//        addSubview(containerView)
//        containerView.fillSuperview(padding: .init(top: 3, left: 6, bottom: 3, right: 6))
        
        addSubview(insetView)
        insetView.fillSuperview(padding: .init(top: 3, left: 12, bottom: 3, right: 12))
        
        addSubview(leftArrow)
               leftArrow.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 30), size: .init(width: 18, height: 18))
               leftArrow.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: leftArrow.leadingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30), size: .init(width: 200, height: 0))
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
       
        
        addFlicker()
    }
    
    func addFlicker() {
        
        let interval = Double(Int.random(in: 4...8))
        
        _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (_ ) in
            
            let alpha: CGFloat = CGFloat(Int.random(in: 50..<99)) / 100
            UIView.animate(withDuration: interval / 2, animations: {
                self.leftArrow.alpha = alpha
            }) { (_ ) in
                UIView.animate(withDuration: interval / 2) {
                    self.leftArrow.alpha = 0.10
                }
            }
        })
    }
}

