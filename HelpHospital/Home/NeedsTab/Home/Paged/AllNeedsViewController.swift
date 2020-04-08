//
//  HospitalHelperViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class AllNeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var needs = [Need]()
    let cellId = "cellId"
    let headerId = "headerId"
    
    let locationManager = LocationManager()
    let service = Service()
    let chat = ChatMessageRepository()
    var conversationKeys = [String]()
    
    var mySubs = [String]()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
//    let messageBtn: UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(named: "speak"), for: .normal)
//        btn.layer.borderWidth = 1
//        btn.backgroundColor = seaWhite
//        btn.layer.borderColor = dark.cgColor
//        btn.layer.shadowColor = UIColor.white.cgColor
//        btn.layer.shadowOffset = .init(width: -1, height: 1)
//        btn.layer.shadowRadius = 4
//        btn.layer.shadowOpacity = 1
//        return btn
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        locationManager.setup()
        
        
        
        service.fetchMySubs { (subs) in
            self.mySubs = subs
        }
        
        
        self.fetchNeedsFromGeofire(currentRequestKeys: nil)
        
        MemberSession.share.listenTo { _ in
            self.needs = []
            if MemberSession.share.isLogged {
                
                self.service.fetchCurrentRequestsKeys { (keys) in
                    
                    self.fetchNeedsFromGeofire(currentRequestKeys: keys)
                }
                self.chat.clearOldMessagesReferences()
            } else {
                 self.fetchNeedsFromGeofire(currentRequestKeys: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if MemberSession.share.isLogged {
//            messageBtn.isHidden = false
//        } else {
//            messageBtn.isHidden = true
//        }
        chat.observeRegistredTopic { keys in
            self.conversationKeys = keys
        }
    }
    
    func setup() {
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AllNeedsHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        let headerView = UIView()
               headerView.backgroundColor = blue
               view.addSubview(headerView)
               headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 350))
        
        view .addSubview(tableView)
        let tabBarHeight = self.tabBarHeight
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        
    }
    
    func fetchNeedsFromGeofire(currentRequestKeys: [String]?) {
        
        guard let location = locationManager.location else { return }
        
        locationManager.observeGeoFireNeeds(from: location, currentRequestsKeys: currentRequestKeys) { (key) in
            self.service.getNeeds(for: [key]) { (needs) in
                if needs[0].senderId != MemberSession.share.member?.uuid {
                    
                    var need = needs[0]
                    if self.mySubs.contains(needs[0].id) {
                        need.iSub = true
                    }
                    
                    self.needs.append(need)
                }
                
                DispatchQueue.main.async {
                    
                     self.needs = self.needs.sorted(by: { $0.timestamp < $1.timestamp })
//                    let notSubNeeds = self.needs.filter({ $0.iSub == false })
//                    self.needs.append(contentsOf: notSubNeeds)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func handleMessageBtn() {
//        let vc = ConversationListController()
//        vc.conversationsId = conversationKeys
//        vc.modalPresentationStyle = .fullScreen
//         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllNeedsCell
        
        let need = needs[indexPath.row]
        cell.pseudoLabel.text = "\(need.pseudo) -"
        cell.titleLabel.text = need.title
        cell.id = need.id
        cell.delegate = self
        cell.sub = need.iSub
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! AllNeedsHeaderCell
        
        return view
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MemberSession.share.isLogged {
            let vc = NeedDetailViewController()
            vc.need = needs[indexPath.row]
    
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        } else {
            Utils.callAlert(vc: self, title: "Attention", message: "Vous devez être connecté pour voir les détails et communiquer.", action: "Ok")
        }
    }
}


extension AllNeedsViewController: AllNeedsCellProtocol {
    
    
    func favButtonPressed(id: String, doSub: Bool) {
      
        if doSub {
            service.subscribeToNeed(needId: id)
        } else {
            service.unSubscribeToNeed(needId: id)
        }
    }
    
    
}
