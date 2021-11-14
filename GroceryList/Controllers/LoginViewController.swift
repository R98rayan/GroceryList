//
//  ViewController.swift
//  GroceryList
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.font = UIFont(name: Helper.fontStyle, size: 32)
        loginButton.titleLabel?.font = UIFont(name: Helper.fontStyle, size: 32)
        registerButton.titleLabel?.font = UIFont(name: Helper.fontStyle, size: 24)
        registerLabel.font = UIFont(name: Helper.fontStyle, size: 12)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        FirebaseAuth.Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!, completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                Helper.alertUserError(title: "🔴 Error!", message: "wrong email or password!", view: self)
                return
            }
            let user = result.user
            
            let key = Helper.database.child("online").childByAutoId().key
            Helper.setOnlineID(onlineID: key!)
            Helper.database.child("online").child(key!).setValue(user.email)
            print("✅ [Login] upload to Realtime Database Online List")
            
            print("✅ Successfully logged in user: \(user)")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func fastLoginAction(_ sender: Any) {
        FirebaseAuth.Auth.auth().signIn(withEmail: "r98rayan@gmail.com", password: "123456", completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                Helper.alertUserError(title: "🔴 Error!", message: error!.localizedDescription, view: self)
                return
            }
            let user = result.user
            
            let key = Helper.database.child("online").childByAutoId().key
            Helper.setOnlineID(onlineID: key!)
            Helper.database.child("online").child(key!).setValue(user.email)
            print("✅ [Login] upload to Realtime Database Online List")
            
            print("✅ [Login] Successfully logged in user: \(user)")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

