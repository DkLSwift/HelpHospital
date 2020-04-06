//
//  ConversationListController.swift
//  HelpHospital
//
//  Created by Eric DkL on 28/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class ConversationListController: UITableViewController {

    let chat = ChatMessageRepository()
    let service = Service()
    
    var conversationsId: [String]? = []
    var chatMessagesPreviews = [ChatMessagePreview]()
    
    let cellId = "cellId"
    
    var conversationsAndMessages = [String : [Message]]()
    let dateformatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        dateformatter.dateFormat = "HH:mm"
        setup()
        
        chat.getConversationMessages(conversationsId: conversationsId) { (conversationsAndMessages) in
            
            self.conversationsAndMessages = conversationsAndMessages
           
            self.chat.getLastMessagesPreviewData(conversations: conversationsAndMessages) { (chatMessagesPreviews) in
                self.chatMessagesPreviews = chatMessagesPreviews.sorted(by: { $0.timestamp < $1.timestamp })
                self.tableView.reloadData()
            }
        }
    }

    func setup() {
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationListCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationListCell
        
        let messagePreview = chatMessagesPreviews[indexPath.row]
        
        let previewDate = Date(timeIntervalSince1970: messagePreview.timestamp)
        let time = dateformatter.string(from: previewDate)
        let displayTime = time.replacingOccurrences(of: ":", with: "h")
        
        cell.pseudoLabel.text = "\(messagePreview.pseudo)  -  \(messagePreview.title)"
        cell.messageLabel.text = messagePreview.text
        cell.timeLabel.text = String(displayTime)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessagesPreviews.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = chatMessagesPreviews[indexPath.row].pseudo
        let messagesKey = chatMessagesPreviews[indexPath.row].key
        let messages = conversationsAndMessages[messagesKey]
        let toId = chatMessagesPreviews[indexPath.row].toId
        service.getNeeds(for: [messagesKey]) { (needs) in
            
            let vc = ChatController()
            vc.need = needs[0]
            vc.toId = toId
            vc.conversationId = messagesKey
            vc.title = title
            vc.modalPresentationStyle = .fullScreen
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
