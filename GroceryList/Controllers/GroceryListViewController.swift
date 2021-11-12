//
//  GroceryListViewController.swift
//  GroceryList
//
//  Created by administrator on 11/11/2021.
//

import UIKit
import FirebaseAuth

class GroceryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avtiveUserButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        print("🔴 check if there is a user...")
        // current user is set automatically when you log a user in
        if FirebaseAuth.Auth.auth().currentUser == nil {
            print("🔴 there is no user, pushing the Login View!")
            self.performSegue(withIdentifier: "AuthenticationSegue", sender: self)
        }
        else {
            print("🔴 we found a user with a name: \(FirebaseAuth.Auth.auth().currentUser!.email!)")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AuthenticationSegue", sender: self)
    }
}

extension GroceryListViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }


    
}
