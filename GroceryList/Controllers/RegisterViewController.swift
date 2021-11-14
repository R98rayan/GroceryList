import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.font = UIFont(name: Helper.fontStyle, size: 32)
        registerButton.titleLabel?.font = UIFont(name: Helper.fontStyle, size: 24)
        loginLabel.font = UIFont(name: Helper.fontStyle, size: 12)
        loginButton.titleLabel?.font = UIFont(name: Helper.fontStyle, size: 24)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!, completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                Helper.alertUserError(title: "🔴 Error!", message: error!.localizedDescription, view: self)
                return
            }
            let user = result.user
            print("🔴 Created User: \(user)")

//            Helper.database.child( Helper.getSafeEmail(email: self.emailLabel.text!) ).setValue(["first_name": self.firstNameLabel.text,"last_name": self.lastNameLabel.text])
            
            Helper.database.child("users").child(user.uid).setValue(["email": self.emailLabel.text, "first_name": self.firstNameLabel.text,"last_name": self.lastNameLabel.text])
            
            let key = Helper.database.child("online").childByAutoId().key
            Helper.setOnlineID(onlineID: key!)
            Helper.database.child("online").child(key!).setValue(user.email)
            
            print("🔴 upload data to realtime database, child = '\(user.uid)'")
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        
        
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
