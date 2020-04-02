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

class HospitalWorkerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "cellId"
    let tableView = UITableView()
    
    let addNeedBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "plus"), for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 30
        btn.backgroundColor = seaDarkBlue
        btn.layer.borderColor = seaLightBlue.cgColor
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
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        
        MemberSession.share.listenTo { _ in
            self.fetchCurrentUserNeedsAndReloadTVData()
        }
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            self.fetchCurrentUserNeedsAndReloadTVData()
    }
    
    func setupUI() {
//        tableView.backgroundView?.backgroundColor = seaDarkBlue
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HospitalWorkerNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = seaDarkBlue
        view.backgroundColor = seaDarkBlue
        
        view .addSubview(tableView)
        let tabBarHeight = self.tabBarHeight
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: tabBarHeight, right: 0))
        
        view.addSubview(addNeedBtn)
        addNeedBtn.constrainWidth(constant: 60)
        addNeedBtn.constrainHeight(constant: 60)
        addNeedBtn.contentEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        addNeedBtn.translatesAutoresizingMaskIntoConstraints = false
        addNeedBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight + 20)).isActive = true
        addNeedBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addNeedBtn.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
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
        self.tableView.reloadData()
    }
    
    @objc func handleAdd() {
        
        let vc = WorkerFormViewController()
        vc.mainVC = self
        present(vc, animated: true, completion: nil)
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalWorkerNeedsCell
            
            let need = needs[indexPath.row]
            cell.needId = need.id
            cell.titleLabel.text = need.title
//            cell.delegate = self
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        let key = needs[indexPath.row].id
        var conversationKeys = [String]()
        conversationKeys.append(key)

        let vc = ConversationListController()
        vc.conversationsId = conversationKeys
        vc.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in
            print("magical delete")
//            self.needs.remove(at: indexPath.row)
            self.deleteNeedPressed(needId: self.needs[indexPath.row].id, success: ({
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                complete(true)
            }))
           
        }
//        deleteAction.image = UIImage(named: "bin")
        deleteAction.title = "Supprimer"
        
        deleteAction.backgroundColor = seaLightBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
        }
    }
}


extension HospitalWorkerViewController {
    
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
