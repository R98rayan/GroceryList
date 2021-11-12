//
//  Helper.swift
//  GroceryList
//
//  Created by administrator on 10/11/2021.
//

import Foundation
import UIKit
import FirebaseDatabase

class Helper {
    static let fontStyle = "Avenir Black Oblique"
    static let database = Database.database().reference()
    
    static func alertUserError(title: String, message: String, view: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        view.present(alert, animated: true)
    }
    
    static func getSafeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
