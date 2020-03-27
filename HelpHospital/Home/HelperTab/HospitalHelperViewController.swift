//
//  HospitalHelperViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit

class HospitalHelperViewController: UITableViewController {

    var needs = [Need]()
    let cellId = "cellId"
    
    let locationManager = LocationManager()
    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        locationManager.setup()
        guard let location = locationManager.location else { return }
        locationManager.geoFireRequest(from: location, success: { (keys) in
            
            self.service.getNeeds(for: keys) { (needs) in
                self.needs = needs
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }) { (err) in
            
        }
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = clearBlue
        tableView.register(HospitalHelperTableviewCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalHelperTableviewCell

         let need = needs[indexPath.row]
        if let pseudo = need.pseudo {
            cell.pseudoLabel.text = "- \(pseudo) -"
        }
         
         cell.titleLabel.text = need.title

         return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MemberSession.share.isLogged {
            
        } else {
            Utils.callAlert(vc: self, title: "Attention", message: "Vous devez être connecté pour voir les détails et communiquer.", action: "Ok")
        }
    }
}
