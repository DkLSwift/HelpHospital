//
//  ChatTableViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var need: Need!
    let chat = ChatMessageRepository()
    
    let messageTF: TF = {
        let tf = TF(placeholder: "Envoyer un message")
        return tf
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "send"), for: .normal)
        return btn
    }()
    
    let cellId = "cellId"
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupUI()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    func setupUI() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        [messageTF, sendBtn].forEach( { $0.constrainHeight(constant: 44)})
        sendBtn.constrainWidth(constant: 44)
        
        let hStack = UIStackView(arrangedSubviews: [messageTF, sendBtn])
        hStack.spacing = 20
        view.addSubview(hStack)
        hStack.anchor(top: nil, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 30, right: 30))
        
        sendBtn.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        view.addSubview(tableView)
        let topBarHeight = self.topbarHeight
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: hStack.topAnchor, trailing: view.trailingAnchor, padding: .init(top: topbarHeight, left: 0, bottom: 0, right: 0))
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)  as! ChatCell
        
        return cell
    }

    
    @objc func handleSendMessage() {
        guard let text = messageTF.text, text != "" else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Le champs de texte est vide", action: "Ok")
            return
        }
        
        guard let id = MemberSession.share.member?.uuid else { return }
        let timestamp = Date().timeIntervalSince1970
        
        let message = Message(text: text, fromId: id, toId: need.workerId, timestamp: timestamp)
        chat.postMessage(workerId: need.workerId, currentUserId: id, needId: need.id, message: message) {
            self.messageTF.text = ""
            // RELOAD TB
        }
    }
}
