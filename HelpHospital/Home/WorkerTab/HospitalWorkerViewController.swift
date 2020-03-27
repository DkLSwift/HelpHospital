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

class HospitalWorkerViewController: UITableViewController, FormViewProtocol {
    
    let cellId = "cellId"
    let disconnectedCellId = "disconnectedCellId"
    
    var needs = [Need]()
    
    let service = Service()
    var locationManager = LocationManager()
    var geoFire: GeoFire?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        MemberSession.share.listenTo { _ in
            if MemberSession.share.isLogged {
                self.fetchCurrentUserNeedsAndReloadTVData()
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
        locationManager.setup()
        setupTableview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if MemberSession.share.isLogged {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.fetchCurrentUserNeedsAndReloadTVData()
        } else {
            needs = []
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func setupTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = clearBlue
        tableView.register(HospitalWorkerNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(WorkerNotLoggedCell.self, forCellReuseIdentifier: disconnectedCellId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    func fetchCurrentUserNeedsAndReloadTVData() {
        guard let id = MemberSession.share.member?.uuid else { return }
        needs = []
        
        service.fetchCurrentUserNeeds(id: id) { (needs) in
            self.needs = needs
            self.tableView.reloadData()
        }
    }
    
    @objc func handleAdd() {
//        let popUp = FormView(text: "Ajouter un besoin", acceptButtonTitle: "VALIDER", cancelButtonTitle: "ANNULER")
//        view.addSubview(popUp)
//        popUp.fillSuperview()
//        popUp.delegate = self
//        UIView.animate(withDuration: 0.3, animations: {
//            popUp.blur.alpha = 1
//            popUp.alpha = 1
//        }) { (success) in
//            //
//        }
        
        let vc = WorkerFormViewController()
        present(vc, animated: true, completion: nil)
    }
    
    func postNeeds(title: String, desc: String?, time: String?) {
        guard let location = locationManager.location, let id = MemberSession.share.member?.uuid, let key = needsRef.childByAutoId().key else { return }
        
        locationManager.postNeed(from: location, key: key, id: id, title: title, desc: desc, time: time)
        
        fetchCurrentUserNeedsAndReloadTVData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.needs.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: disconnectedCellId, for: indexPath) as! WorkerNotLoggedCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalWorkerNeedsCell
            
            let need = needs[indexPath.row]
            cell.titleLabel.text = need.title
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count > 0 ? needs.count : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return needs.count > 0 ? 100 : 300
    }
}
