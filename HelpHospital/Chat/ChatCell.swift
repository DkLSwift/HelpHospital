//
//  ChatCell.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let messageView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 22)
        return tv
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = seaDarkBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLeftBubble() {
        
        addSubview(containerView)
        containerView.backgroundColor = seaLightBlue
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 20, bottom: 10, right: 0), size: .init(width: 270, height: 0))
        
        addSubview(messageView)
        messageView.textColor = seaWhite
        messageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 30, bottom: 10, right: 0), size: .init(width: 250, height: 0))
    }
    
    func setupRightBubble() {
        
        addSubview(containerView)
        
        containerView.backgroundColor = seaWhite
        containerView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 20), size: .init(width: 270, height: 0))
        
        addSubview(messageView)
        messageView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 20), size: .init(width: 250, height: 0))
    }
    
}
