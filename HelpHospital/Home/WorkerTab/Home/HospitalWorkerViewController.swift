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
    let disconnectedCellId = "disconnectedCellId"
    
    var needs = [Need]()
    
    let service = Service()
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
//        tableView.register(WorkerNotLoggedCell.self, forCellReuseIdentifier: disconnectedCellId)
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
            return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
