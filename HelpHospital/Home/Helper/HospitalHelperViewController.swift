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
                self.tableView.reloadData()
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
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }
}
