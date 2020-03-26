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

class HospitalWorkerViewController: UIViewController, CLLocationManagerDelegate, FormViewProtocol {
    
    
    let topLabel: UILabel? = {
        let lbl = UILabel()
        lbl.text = "C'est ici que le personnel soignant peut poster les besoins, connexion requise."
        lbl.font = UIFont.systemFont(ofSize: 36)
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.6
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = dark
        lbl.textAlignment = NSTextAlignment.center
        return lbl
    }()
    
    var containerView: UIView?
    var tableViewController: HospitalWorkerNeedsTableViewController?
    
    var needs = [Need]()
    
    var locationManager: CLLocationManager? = CLLocationManager()
    var geoFire: GeoFire?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
//        if MemberSession.share.isLogged {
//            setupConnectedUI()
//        } else {
//            setupDisconnectedUI()
//        }
        setupLocationManager()
    }
    func setupLocationManager() {
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager?.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if MemberSession.share.isLogged {
            topLabel?.removeFromSuperview()
            setupConnectedUI()
        } else {
            navigationItem.rightBarButtonItem = nil
            setupDisconnectedUI()
        }
    }
    
    func setupDisconnectedUI() {
        guard topLabel != nil else { return }
        view.addSubview(topLabel!)
        topLabel?.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
    }
    
    func setupConnectedUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        var safeTopAnchor = view.topAnchor
        var safeBottomAnchor = view.bottomAnchor
        if #available(iOS 11.0, *) {
            safeTopAnchor = view.safeAreaLayoutGuide.topAnchor
            safeBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
//        let topPadding = self.topbarHeight
//        let botPadding = self.tabBarHeight
        containerView = UIView()
        view.addSubview(containerView!)
        containerView?.backgroundColor = clearBlue
        containerView?.anchor(top: safeTopAnchor, leading: view.leadingAnchor, bottom: safeBottomAnchor, trailing: view.trailingAnchor)
//        containerView?.fillSuperview(padding: .init(top: topPadding, left: 0, bottom: botPadding, right: 0))
        
        tableViewController = HospitalWorkerNeedsTableViewController()
        containerView?.addSubview(tableViewController!.view)
        tableViewController?.view.fillSuperview()
        
        fetchCurrentUserNeedsAndReloadTVData()
    }

    func fetchCurrentUserNeedsAndReloadTVData() {
        guard let id = MemberSession.share.user?.uuid else { return }
        
        var keys = [String]()
        
        usersRef.child(id).child(currentRequests).observeSingleEvent(of: .value) { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                values.forEach({
                    guard let key = $0.key as? String else { return }
                    keys.append(key)
                })
                print(keys)
                // work to do
            }
        }
        
        
        needsRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let valueDict = snapshot.value as? NSDictionary {
                valueDict.forEach { (key, value) in
                    if let data = value as? NSDictionary {
                        guard let title = data["title"] as? String else { return }
                        let desc = data["desc"] as? String
                        let time = data["time"] as? String
                        
                        let need = Need(title: title, time: time, desc: desc)
                        self.needs.append(need)
                    }
                }
            }
            self.tableViewController?.needs = self.needs
            self.tableViewController?.tableView.reloadData()
        }
    }
    
    @objc func handleAdd() {
        let popUp = FormView(text: "Ajouter un besoin", acceptButtonTitle: "VALIDER", cancelButtonTitle: "ANNULER")
        view.addSubview(popUp)
        popUp.fillSuperview()
        popUp.delegate = self
        UIView.animate(withDuration: 0.3, animations: {
            popUp.blur.alpha = 1
            popUp.alpha = 1
        }) { (success) in
            //
        }
    }
    
    func postNeeds(title: String, desc: String?, time: String?) {
        guard let location = locationManager?.location, let id = MemberSession.share.user?.uuid, let key = needsRef.childByAutoId().key else { return }
        
        geoFire = GeoFire(firebaseRef: needsRef)
        
        print("key : ",key)
        geoFire?.setLocation(location, forKey: key)
        needsRef.child(key).updateChildValues([
            "title": title,
            "desc": desc ?? "",
            "time": time ?? "",
            "workerId": id
        ])
  
        usersRef.child(id).child(currentRequests).updateChildValues([key : key])
        fetchCurrentUserNeedsAndReloadTVData()
    }
}
