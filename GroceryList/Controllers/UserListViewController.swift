//
//  UserListViewController.swift
//  GroceryList
//
//  Created by administrator on 13/11/2021.
//

import UIKit

class UserListViewController: UIViewController {
    
    var users = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getData() {
        Helper.database.child("online").observe(.childAdded) { snapshot in
            print(snapshot)
            
            let post = snapshot.value as? String
            
            if let actualPost = post {
                print("⚠️ Reload! ⚠️ data added from realtime databse = \(actualPost)")
                self.users.append(actualPost)
                self.tableView.reloadData()
            }
            
        }
        
        Helper.database.child("online").observe(.childRemoved) { snapshot in
            print(snapshot)
            
            let post = snapshot.value as? String
            
            if let actualPost = post {
                print("⚠️ Reload! ⚠️ data deleted from realtime databse = \(actualPost)")
                self.users.removeAll { $0 == actualPost }
                self.tableView.reloadData()
            }
            
        }
        
        
    }
}

extension UserListViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("✅ tableView has \(users.count) cells")
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("⚠️ update a cell! #\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }


    
}
