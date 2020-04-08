//
//  HospitalWorkerViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit
import GeoFire
import CoreLocation
import FirebaseDatabase

 class MyNeedsViewController: UIViewController, NeedHeaderCellProtocol {
  
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let addNeedBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus"), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 30
        btn.backgroundColor = blue
        btn.layer.borderColor = bluePlus.cgColor
        btn.layer.shadowColor = seaWhite.cgColor
        btn.layer.shadowOffset = .init(width: -1, height: 1)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 1
        return btn
    }()
   
    var needs = [Need]()
    
    let service = Service()
    let chat = ChatMessageRepository()
    
    var geoFire: GeoFire?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MemberSession.share.listenTo { _ in
            self.fetchCurrentUserNeedsAndReloadTVData()
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            self.fetchCurrentUserNeedsAndReloadTVData()
    }
    
    func setupUI() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(NeedHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
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
    
    func fetchCurrentUserNeedsAndReloadTVData() {
        
        needs = []
        if MemberSession.share.isLogged {
             guard let id = MemberSession.share.member?.uuid else { return }
            service.fetchCurrentUserNeeds(id: id) { (needs) in
                
                self.needs = needs.sorted(by: { $0.timestamp < $1.timestamp })
                 self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    
    func addNeedButtonPressed() {
        let vc = NeedsFormViewController()
        vc.mainVC = self
        present(vc, animated: true, completion: nil)
    }
    
}


extension MyNeedsViewController: UITableViewDataSource, UITableViewDelegate {
    

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyNeedsCell
                
                let need = needs[indexPath.row]
                cell.needId = need.id
                cell.titleLabel.text = need.title
                return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! NeedHeaderCell
            view.delegate = self
            return view
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
                
            let key = needs[indexPath.row].id
            var conversationKeys = [String]()
            conversationKeys.append(key)

            let vc = ConversationListController()
            vc.conversationsId = conversationKeys
            vc.isSingleTopic = true
            vc.modalPresentationStyle = .fullScreen
             self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return needs.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 170
        }
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in
    //            self.needs.remove(at: indexPath.row)
                self.deleteNeedPressed(needId: self.needs[indexPath.row].id, success: ({
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    complete(true)
                }))
               
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
    
    func deleteNeedPressed(needId: String, success: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Attention", message: "Si vous cloturez ce besoin, toutes les discussions sur le sujet seront supprimées.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { (_ ) in
            
            needsRef.child(needId).removeValue()
            guard let uId = MemberSession.share.member?.uuid else { return }
            usersRef.child(uId).child(currentRequests).child(needId).removeValue()
            messagesRef.child(needId).removeValue()
            usersMessagesRef.child(uId).child(needId).removeValue()
            
            self.needs.removeAll { $0.id == needId }
            success()
//            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Garder", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
       
    }
    
    
    
}
