//
//  ChatTableViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var need: Need?
    var toId: String?
    let chat = ChatMessageRepository()
    
    var messages = [Message]()
    var conversationId: String?
    
    var textfiedStackBottomAnchor: NSLayoutConstraint?
    
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
    
    var safeTopAnchor: NSLayoutYAxisAnchor?
    var safeBottomAnchor: NSLayoutYAxisAnchor?
    var botPadding: CGFloat = 0
    var hStack: UIStackView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupUI()
        
        if let convId = conversationId {
             observeLiveChat(id: convId)
        } else if let needId = need?.id {
            observeLiveChat(id: needId)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func observeLiveChat(id: String) {
        chat.observeLiveChat(conversationId: id) { (message) in
            self.messages.append(message)
            self.messages = self.messages.sorted(by: { $0.timestamp < $1.timestamp })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
   
    func setupUI() {
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        IQKeyboardManager.shared.enable = false
        
        self.messageTF.delegate = self
        
        if #available(iOS 11.0, *) {
            botPadding = -10
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            safeTopAnchor = view.topAnchor
            safeBottomAnchor = view.bottomAnchor
        }
        
        [messageTF, sendBtn].forEach( { $0.constrainHeight(constant: 44)})
        sendBtn.constrainWidth(constant: 44)
        
        hStack = UIStackView(arrangedSubviews: [messageTF, sendBtn])
        hStack?.spacing = 20
        view.addSubview(hStack!)
        hStack?.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 30, right: 30))
        textfiedStackBottomAnchor = hStack?.bottomAnchor.constraint(equalTo: safeBottomAnchor!, constant: botPadding)
        textfiedStackBottomAnchor?.isActive = true
        
        sendBtn.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        view.addSubview(tableView)
        let topBarHeight = self.topbarHeight
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: hStack?.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)  as! ChatCell
        
        let message = messages[indexPath.row]
        
        if MemberSession.share.member?.uuid == message.fromId {
            cell.setupRightBubble()
        } else {
            cell.setupLeftBubble()
        }
         cell.messageView.text = message.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 80
        
        let text =  messages[indexPath.row].text 
            height = estimateHeightForText(text: text).height + 40
        
        return height
    }

    private func estimateHeightForText(text: String) -> CGRect {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: CGSize(width: 250, height: 1000), options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)], context: nil)
    }
    
    @objc func handleSendMessage() {
        guard let text = messageTF.text, text != "" else {
            Utils.callAlert(vc: self, title: "Erreur", message: "Le champs de texte est vide", action: "Ok")
            return
        }
        
        guard let id = MemberSession.share.member?.uuid, let pseudo = MemberSession.share.member?.pseudo , let need = need else { return }
        let timestamp = Double(Date().timeIntervalSince1970)
        
        let message = Message(text: text, fromId: id, toId: toId ?? need.workerId, myPseudo: pseudo, toPseudo: need.pseudo, timestamp: timestamp)
        chat.postMessage(workerId: need.workerId, currentUserId: id, needId: need.id, message: message) {
            self.messageTF.text = ""
        }
    }
    
    deinit {
        print("CHAT VC Succcess Deinit     ****************")
    }
}

extension ChatController: UITextFieldDelegate {
    
    
    @objc func handle(keyboardShowNotification notification: Notification) {
       
        if let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
             self.textfiedStackBottomAnchor?.constant = -(keyboardRect.height - botPadding)

            UIView.animate(withDuration: duration ?? 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handle(keyboardHideNotification notification: Notification) {
        
        if let userInfo = notification.userInfo, let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            self.textfiedStackBottomAnchor?.constant = botPadding
            
            UIView.animate(withDuration: duration ?? 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
