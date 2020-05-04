import UIKit
import Firebase
import SVProgressHUD
import Alertify
import StatusBarMessage

class MyProfile: UITableViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.title = "My Profile"
        navigationController?.navigationBar.tintColor = UIColor.white
        
        SVProgressHUD.show()
        
        if Reachability.isConnectedToNetwork() == false {
            dismiss(animated: true, completion: nil)
            SVProgressHUD.dismiss()
            StatusBarMessage.show(with: "No Network Connection", style: .error, duration: 4.0)
            email.text = "nil"
            name.text = "nil"
            phone.text = "nil"
            
        }else {
            retrieveUserInformation()
            SVProgressHUD.dismiss()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func retrieveUserInformation() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["fullName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String ?? ""
            
            self.name.text = name
            self.email.text = email
            self.phone.text = phone
            
            // ...
        }) { (error) in
            self.showAlertView(title: "Oops!", message: error.localizedDescription)
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Alertify.ActionSheet(title: "Logout", message: "To logout from your account, please select the 'Logout' option")
            .action(.destructive("Logout"))
            .action(.cancel("Cancel"))
            
            .finally { (action, index) in
                if action.style == .cancel {
                    return
                }else if action.style == .destructive {
                    SVProgressHUD.show()
                    try! Auth.auth().signOut()
                    self.logoutNavigation()
                    SVProgressHUD.dismiss()
                }
            }
            .show(on: self, completion: nil)
        
    }
    
    func logoutNavigation() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "logout")
        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
