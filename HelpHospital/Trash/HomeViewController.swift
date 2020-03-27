////
////  HomeViewController.swift
////  HelpHospital
////
////  Created by Eric DkL on 24/03/2020.
////  Copyright © 2020 Eric DkL. All rights reserved.
////
//
//import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Firebase
//import FirebaseDatabase
//
//class HomeViewController: UIViewController {
//
//    var user: Member?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        print("id : \(user?.uuid)")
//        
//        let disconnectbtn = UIButton()
//        disconnectbtn.constrainHeight(constant: 44)
//        disconnectbtn.constrainWidth(constant: 100)
//        disconnectbtn.layer.borderColor = UIColor.black.cgColor
//        disconnectbtn.layer.borderWidth = 2
//        disconnectbtn.setTitle("DECO", for: .normal)
//        disconnectbtn.setTitleColor(.black, for: .normal)
//        view.addSubview(disconnectbtn)
//        disconnectbtn.centerInSuperview()
//        
//        disconnectbtn.addTarget(self, action: #selector(handleDisconnection), for: .touchUpInside)
//    }
//    
//    @objc func handleDisconnection() {
//        LoginManager().logOut()
//        UserDefaults.standard.set(nil, forKey: "UserId")
//        UserDefaults.standard.set(nil, forKey: "pseudo")
//        
//        dismiss(animated: true, completion: nil)
//        
//        let vc = LogInViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
//    
//    deinit {
//        print("HomeVC deinit success ****")
//    }
//}
