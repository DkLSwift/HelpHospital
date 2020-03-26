//
//  FormView.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

protocol FormViewProtocol: class {
    func postNeeds(title: String, desc: String?, time: String?)
}

class FormView: UIView, UITextFieldDelegate {
    
    let blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blur = UIVisualEffectView(effect: blurEffect)
        return blur
    }()
    
    let whiteView: UIView = {
        let wView = UIView()
        wView.backgroundColor = .white
        wView.layer.cornerRadius = 20
        return wView
    }()
    
    let descLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    let titleTF: TF = {
        let tf = TF(placeholder: "Titre")
        return tf
    }()
    
    let descTF: TF = {
        let tf = TF(placeholder: "Description brêve")
        return tf
    }()
    
    let timeTF: TF = {
        let tf = TF(placeholder: "Heure approximative")
        return tf
    }()
    
    let acceptButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = dark
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = dark
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(clearBlue, for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    weak var delegate: FormViewProtocol?
    
    init(frame: CGRect = .zero, text: String, acceptButtonTitle: String, cancelButtonTitle: String?) {
        super.init(frame: frame)
        
        alpha = 0
        setupUI()
        descLabel.text = text
        acceptButton.setTitle(acceptButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        addSubview(blur)
        blur.fillSuperview()
        blur.contentView.addSubview(whiteView)
        
        whiteView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        whiteView.constrainHeight(constant: 440)
        whiteView.constrainWidth(constant: UIScreen.main.bounds.width * 0.9)
        
        whiteView.addSubview(descLabel)
        cancelButton.constrainWidth(constant: 60)
        cancelButton.constrainHeight(constant: 40)
        acceptButton.constrainWidth(constant: 60)
        acceptButton.constrainHeight(constant: 40)
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, acceptButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        whiteView.addSubview(stackView)
        stackView.anchor(top: nil, leading: whiteView.leadingAnchor, bottom: whiteView.bottomAnchor, trailing: whiteView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 20, right: 10))
        
        descLabel.anchor(top: whiteView.topAnchor, leading: whiteView.leadingAnchor, bottom: nil, trailing: whiteView.trailingAnchor, padding: .init(top: 20, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 30))
        
        titleTF.delegate = self
        descTF.delegate = self
        timeTF.delegate = self
        
        [titleTF, descTF, timeTF].forEach { $0.constrainHeight(constant: 44) }
        let vStack = UIStackView(arrangedSubviews: [titleTF, descTF, timeTF])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        
        whiteView.addSubview(vStack)
        vStack.anchor(top: descLabel.bottomAnchor, leading: whiteView.leadingAnchor, bottom: stackView.topAnchor, trailing: whiteView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        
//        let separator = UIView()
//        separator.backgroundColor = clearBlue
//        addSubview(separator)
//        separator.anchor(top: descLabel.bottomAnchor, leading: whiteView.leadingAnchor, bottom: nil, trailing: whiteView.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 1))
        
        acceptButton.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    func dismissPopUpForm() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    @objc func handleAccept() {
        if titleTF.text != nil && titleTF.text != "" {
            guard let title = titleTF.text else { return }
            delegate?.postNeeds(title: title, desc: descTF.text, time: timeTF.text)
            dismissPopUpForm()
        }
        
        
    }
    @objc func handleCancel() {
        dismissPopUpForm()
    }
    
}
