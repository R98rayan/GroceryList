//
//  GroceryListViewController.swift
//  GroceryList
//
//  Created by administrator on 11/11/2021.
//

import UIKit
import FirebaseAuth

struct Item {
    var name: String
    var sender: String
    var id: String
    
    func delete() {
        Helper.database.child("items").child(id).removeValue()
    }
    
    mutating func update(name: String) {
        self.sender = Helper.currentUser().email!
        Helper.database.child("items").child(id).updateChildValues(["name": name, "sender": sender])
    }
}

class GroceryListViewController: UIViewController {

    var items = [Item]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avtiveUserButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
    }
    
    func getData() {
        print("🔴 [GroceryList] runing items observe!")
        Helper.database.child("items").observe(.childAdded) { snapshot in
            let post = snapshot.value as? [String: String]
            if let actualPost = post {
                print("⚠️ Reload! ⚠️ added data to realtime databse [items] = \(actualPost)")
                let key = snapshot.key
                let item = Item(name: post!["name"]!, sender: post!["sender"]!, id: key)
                self.items.append(item)
                self.tableView.reloadData()
            }
            
        }
        
        Helper.database.child("items").observe(.childRemoved) { snapshot in
            let post = snapshot.value as? [String: String]
            if let actualPost = post {
                print("⚠️ Reload! ⚠️ deleted data from realtime databse [items] = \(actualPost)")
                let key = snapshot.key
                
                for i in 0...self.items.count {
                    if self.items[i].id == key {
                        self.items.remove(at: i)
                        break
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        Helper.database.child("items").observe(.childChanged) { snapshot in
            let post = snapshot.value as? [String: String]
            if let actualPost = post {
                print("⚠️ Reload! ⚠️ changed data from realtime databse [items] = \(actualPost)")
                let key = snapshot.key
                
                for i in 0...self.items.count {
                    if self.items[i].id == key {
                        self.items[i].name = post!["name"]!
                        self.items[i].sender = post!["sender"]!
                        break
                    }
                }
                self.tableView.reloadData()
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("🔴 [GroceryList] check if there is a user...")
        // current user is set automatically when you log a user in
        if FirebaseAuth.Auth.auth().currentUser == nil {
            print("❎ [GroceryList] there is no user, pushing the Login View!")
            self.performSegue(withIdentifier: "AuthenticationSegue", sender: self)
        }
        else {
            print("✅ [GroceryList] we found a user with a name: \(FirebaseAuth.Auth.auth().currentUser!.email!)")
            tableView.reloadData()
        }

    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        showInputDialog(subtitle: "Add Item")
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("🔴 [GroceryList] successfully logout")
            
            Helper.database.child("online").child(Helper.getOnlineID()).removeValue()
            self.performSegue(withIdentifier: "AuthenticationSegue", sender: self)
        }
        catch {
            print("🔴 [GroceryList] failed to logout")
        }
        
    }
    
    func addItemToRealTimeDatabase(name: String){
        Helper.database.child("items").childByAutoId().setValue(["name": name, "sender": Helper.currentUser().email])
        print("✅ added item to realtime database -> \(name)")
    }
    
    private func showInputDialog(title: String? = nil,
                                     subtitle: String? = nil,
                                     actionTitle: String? = "Add",
                                     cancelTitle: String? = "Cancel",
                                     name: String? = nil,
                                     inputPlaceholder: String? = nil,
                                     cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                     actionHandler: ((_ text: String?) -> Void)? = nil ) {

            let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
            alert.addTextField { (textField:UITextField) in
                textField.text = name
                textField.placeholder = "Enter Grocery Name"
            }

            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
                guard let nameTextField = alert.textFields?[0]

                else {
                    actionHandler?(nil)
                    return
                }
                actionHandler?(nameTextField.text)
                
                self.addItemToRealTimeDatabase(name: nameTextField.text!)
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

            self.present(alert, animated: true, completion: nil)
        }
    
    private func showInputDialogUpdate(index: Int, title: String? = nil,
                                     subtitle: String? = nil,
                                     actionTitle: String? = "Update",
                                     cancelTitle: String? = "Cancel",
                                     name: String? = nil,
                                     inputPlaceholder: String? = nil,
                                     cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                     actionHandler: ((_ text: String?) -> Void)? = nil ) {

            let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
            alert.addTextField { (textField:UITextField) in
                textField.text = name
                textField.placeholder = "Update Grocery Name"
            }

            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
                guard let nameTextField = alert.textFields?[0]

                else {
                    actionHandler?(nil)
                    return
                }
                self.items[index].update(name: nameTextField.text!)
                
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

            self.present(alert, animated: true, completion: nil)
        }
    
}


extension GroceryListViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("✅ tableView has \(items.count) cells")
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("⚠️ update a cell! #\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.detailTextLabel?.text = "by: \(items[indexPath.row].sender)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items[indexPath.row].delete()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showInputDialogUpdate(index: indexPath.row, subtitle: "Update Item", name: items[indexPath.row].name)
//    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showInputDialogUpdate(index: indexPath.row, subtitle: "Update Item", name: items[indexPath.row].name)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }


    
}
