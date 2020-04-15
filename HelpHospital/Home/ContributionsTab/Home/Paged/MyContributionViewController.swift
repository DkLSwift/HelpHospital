//
//  MyContributionViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class MyContributionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyContributionHeaderCellProtocol {
   
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    var contributions = [Contribution]()
    
    let service = Service()
    let chat = ChatMessageRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        MemberSession.share.listenTo { _ in
            self.fetchCurrentUserContributionsAndReloadTVData()
//        }
        setupUI()
    }
    
    
    func setupUI() {
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyContributionsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(MyContributionHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delaysContentTouches = false
        view.backgroundColor = .white
        
        let tabBarHeight = self.tabBarHeight
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        let headerView = UIView()
        headerView.backgroundColor = blue
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 350))
        
        view.addSubview(tableView)
        
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        
    }
    
    
    
    func fetchCurrentUserContributionsAndReloadTVData() {
        
        
        contributions = []
        if MemberSession.share.isLogged {
            guard let id = MemberSession.share.member?.uuid else { return }
            service.fetchCurrentUserContributions(id: id) { (contributions) in
                self.contributions = contributions.sorted(by:  { $0.timestamp < $1.timestamp })
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyContributionsCell
        
        let contribution = contributions[indexPath.row]
        cell.contributionId = contribution.id
        cell.titleLabel.text = contribution.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let key = contributions[indexPath.row].id
        var conversationKeys = [String]()
        conversationKeys.append(key)
        
        let vc = ConversationListController()
        vc.conversationsId = conversationKeys
        vc.isSingleTopic = true
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! MyContributionHeaderCell
         view.delegate = self
         return view
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 170
        }
    
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in
                
//                self.deleteNeedPressed(needId: self.needs[indexPath.row].id, success: ({
//                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                    complete(true)
//                }))
               
            }
            deleteAction.title = "Supprimer"
            
            deleteAction.backgroundColor = blueMinus
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            
            return configuration
            
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                print("delete")
            }
        }
    
    
    func addContributionButtonPressed() {
        let vc = ContributionFormViewController()
        present(vc, animated: true, completion: nil)
    }
       
    
    
     func deleteContributionPressed(contribId: String, success: @escaping () -> Void) {
            
            let alert = UIAlertController(title: "Attention", message: "Si vous cloturez cette contribution, toutes les discussions sur le sujet seront supprimées.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { (_ ) in
                
                contributionsRef.child(contribId).removeValue()
                guard let uId = MemberSession.share.member?.uuid else { return }
                usersRef.child(uId).child(currentContributions).child(contribId).removeValue()
                messagesRef.child(contribId).removeValue()
                usersMessagesRef.child(uId).child(contribId).removeValue()
                
                self.contributions.removeAll { $0.id == contribId }
                success()
    //            self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "Garder", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
           
        }
    
}
