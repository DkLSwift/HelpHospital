//
//  Utils.swift
//  HelpHospital
//
//  Created by Eric DkL on 24/03/2020.
//  Copyright © 2020 Eric DkL. All rights reserved.
//

import UIKit


public class Utils {
    
    public static func checkMail(mail : String) -> Bool {
           
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: mail)
       }
       
//       public static func checkPassword(password: String) -> Bool {
//           if password.count > 6 {
//               return true
//           } else {
//               return false
//           }
//       }

    public static func callAlert(vc: UIViewController, title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
}
