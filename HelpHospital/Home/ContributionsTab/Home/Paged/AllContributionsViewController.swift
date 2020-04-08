//
//  AllContributionsViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 07/04/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class AllContributionsViewController: UIViewController {
    
    var contributions = [Contribution]()
    let cellId = "cellId"
    let headerId = "headerId"
    
    let locationManager = LocationManager()
    let service = Service()
    let chat = ChatMessageRepository()
    
    var mySubs = [String]()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        locationManager.setup()
        
        service.fetchMySubs { (subs) in
            self.mySubs = subs
        }
        self.contributions = []
        if MemberSession.share.isLogged {
            
            self.service.fetchCurrentContributionsKeys { (keys) in
                
                self.fetchContributionsFromGeofire(currentRequestKeys: keys)
            }
            self.chat.clearOldMessagesReferences()
        } else {
             self.fetchContributionsFromGeofire(currentRequestKeys: nil)
        }
    }
    
    
    func setup() {
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllContributionsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(AllContributionsHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerId)
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
    
    func fetchContributionsFromGeofire(currentRequestKeys: [String]?) {
        
        guard let location = locationManager.location else { return }
        
        locationManager.observeGeoFireContributions(from: location, currentRequestsKeys: currentRequestKeys) { (key) in
            self.service.getContributions(for: [key]) { (contributions) in
                if contributions[0].senderId != MemberSession.share.member?.uuid {
                    
                    var contribution = contributions[0]
                    if self.mySubs.contains(contributions[0].id) {
                        contribution.iSub = true
                    }
                    
                    self.contributions.append(contribution)
                }
                
                DispatchQueue.main.async {
                    
                    self.contributions = self.contributions.sorted(by: { $0.timestamp < $1.timestamp })
                    //                    let notSubNeeds = self.needs.filter({ $0.iSub == false })
                    //                    self.needs.append(contentsOf: notSubNeeds)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


extension AllContributionsViewController: UITableViewDataSource, UITableViewDelegate, AllContributionsCellProtocol {
  
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllContributionsCell
        
        let contribution = contributions[indexPath.row]
        cell.pseudoLabel.text = "\(contribution.pseudo) -"
        cell.titleLabel.text = contribution.title
        cell.id = contribution.id
        cell.delegate = self
        cell.sub = contribution.iSub
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! AllContributionsHeaderCell
        
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MemberSession.share.isLogged {
            let vc = ContributionDetailViewController()
            vc.contribution = contributions[indexPath.row]

            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        } else {
            Utils.callAlert(vc: self, title: "Attention", message: "Vous devez être connecté pour voir les détails et communiquer.", action: "Ok")
        }
    }
    
    
    func favButtonPressed(id: String, doSub: Bool) {
          if doSub {
                     service.subscribeToTopic(needId: id)
                 } else {
                     service.unSubscribeToTopic(needId: id)
                 }
      }
    
    
}
