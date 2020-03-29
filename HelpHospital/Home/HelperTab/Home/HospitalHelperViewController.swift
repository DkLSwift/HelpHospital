//
//  HospitalHelperViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HospitalHelperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var needs = [Need]()
    let cellId = "cellId"
    
    let locationManager = LocationManager()
    let service = Service()
    let chat = ChatMessageRepository()
    var conversationKeys = [String]()
    
    let tableView = UITableView()
    
    let messageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "speak"), for: .normal)
        btn.layer.borderWidth = 1
        btn.backgroundColor = .white
        btn.layer.borderColor = dark.cgColor
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = .init(width: -2, height: 2)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 1
        return btn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        locationManager.setup()
        
//        self.fetchNeedsFromGeofire(currentRequestKeys: nil)
        MemberSession.share.listenTo { _ in
            self.service.fetchCurrentRequestsKeys { (keys) in
                
                self.fetchNeedsFromGeofire(currentRequestKeys: keys)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        chat.observeRegistredTopic { keys in
            self.conversationKeys = keys
        }
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HospitalHelperTableviewCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
        
        view .addSubview(tableView)
        let topBarHeight = self.topbarHeight
        let tabBarHeight = self.tabBarHeight
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        tableView.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: topBarHeight, left: 0, bottom: tabBarHeight, right: 0))
        
        view.addSubview(messageBtn)
        messageBtn.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        messageBtn.anchor(top: nil, leading: nil, bottom: safeBottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: tabBarHeight + 40, right: 40), size: .init(width: 60, height: 60))
        messageBtn.layer.cornerRadius = 30
        messageBtn.addTarget(self, action: #selector(handleMessageBtn), for: .touchUpInside)
    }
    
    func fetchNeedsFromGeofire(currentRequestKeys: [String]?) {
        
        guard let location = locationManager.location else { return }
        needs = []
        
        locationManager.geoFireRequest(from: location, currentRequestsKeys: currentRequestKeys, success: { (keys) in
            
           
            self.service.getNeeds(for: keys) { (needs) in
                self.needs = needs
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }) { (err) in
            
        }
        
    }
  
    @objc func handleMessageBtn() {
        let vc = ConversationListController()
        vc.conversationsId = conversationKeys
        vc.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalHelperTableviewCell

         let need = needs[indexPath.row]
        cell.pseudoLabel.text = "- \(need.pseudo) -"
        
         
         cell.titleLabel.text = need.title

         return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
