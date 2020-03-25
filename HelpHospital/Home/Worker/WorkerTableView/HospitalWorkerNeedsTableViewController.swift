//
//  HospitalWorkerNeedsTableViewController.swift
//  HelpHospital
//
//  Created by Eric DkL on 25/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


class HospitalWorkerNeedsTableViewController: UITableViewController {

    var needs = [Need]()
    let cellId = "cellId"

    weak var mainVC: HospitalWorkerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = clearBlue
        tableView.register(HospitalWorkerNeedsCell.self, forCellReuseIdentifier: cellId)
        tableView.showsVerticalScrollIndicator = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return needs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HospitalWorkerNeedsCell

       

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    deinit {
        print("Spot Suggestion TableViewController Successfully Deinited")
    }
}


