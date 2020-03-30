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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setup()
        
        chat.getConversationMessages(conversationsId: conversationsId) { (conversationsAndMessages) in
            
            self.conversationsAndMessages = conversationsAndMessages
           
            self.chat.getLastMessagesPreviewData(conversations: conversationsAndMessages) { (chatMessagesPreviews) in
                self.chatMessagesPreviews = chatMessagesPreviews
                self.tableView.reloadData()
            }
        }
    }

    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationListCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationListCell
        
        let messagePreview = chatMessagesPreviews[indexPath.row]
        
        cell.pseudoLabel.text = "\(messagePreview.pseudo)  -  \(messagePreview.title)"
        cell.messageLabel.text = messagePreview.text
        cell.timeLabel.text = String(messagePreview.timestamp)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatMessagesPreviews.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesKey = chatMessagesPreviews[indexPath.row].key
        let messages = conversationsAndMessages[messagesKey]
         
        service.getNeeds(for: [messagesKey]) { (needs) in
            
            let vc = ChatController()
//            vc.messages = messages?.sorted(by: { $0.timestamp < $1.timestamp })
            vc.need = needs[0]
            vc.conversationId = messagesKey
            vc.modalPresentationStyle = .fullScreen
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
