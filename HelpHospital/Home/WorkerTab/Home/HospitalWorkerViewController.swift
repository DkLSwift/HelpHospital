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

class HospitalWorkerViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var needs = [Need]()
    
    let service = Service()
    let chat = ChatMessageRepository()
    
    var geoFire: GeoFire?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        MemberSession.share.listenTo { _ in
            self.fetchCurrentUserNeedsAndReloadTVData()
        }
        setupTableview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            self.fetchCurrentUserNeedsAndReloadTVData()
    }
    
    func setupTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HospitalWorkerNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    func fetchCurrentUserNeedsAndReloadTVData() {
        
        needs = []
        if MemberSession.share.isLogged {
             guard let id = MemberSession.share.member?.uuid else { return }
            service.fetchCurrentUserNeeds(id: id) { (needs) in
                self.needs = needs
                 self.tableView.reloadData()
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
             self.tableView.reloadData()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
       
    }
    
    @objc func handleAdd() {
        
        let vc = WorkerFormViewController()
        vc.mainVC = self
        present(vc, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalWorkerNeedsCell
            
            let need = needs[indexPath.row]
            cell.needId = need.id
            cell.titleLabel.text = need.title
            cell.delegate = self
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        let key = needs[indexPath.row].id
        var conversationKeys = [String]()
        conversationKeys.append(key)

        let vc = ConversationListController()
        vc.conversationsId = conversationKeys
        vc.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}


extension HospitalWorkerViewController: WorkerNeedsCellProtocol {
    func deleteNeedPressed(needId: String) {
        
        let alert = UIAlertController(title: "Attention", message: "Si vous cloturez ce besoin, toutes les discussions sur le sujet seront supprimées.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { (_ ) in
            
            needsRef.child(needId).removeValue()
            guard let uId = MemberSession.share.member?.uuid else { return }
            usersRef.child(uId).child(currentRequests).child(needId).removeValue()
            messagesRef.child(needId).removeValue()
            usersMessagesRef.child(uId).child(needId).removeValue()
        }
        
        let cancelAction = UIAlertAction(title: "Garder", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true)
       
    }
    
    
    
}
