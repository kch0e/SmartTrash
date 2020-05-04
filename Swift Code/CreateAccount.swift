import UIKit
import Firebase
import SVProgressHUD

class CreateAccount: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        
        name.becomeFirstResponder()
    }
    
    @IBAction func createAccount(_ sender: Any) {
        SVProgressHUD.show()
        if (name.text == "" || email.text == "" || phoneNumber.text == "" || password.text == "") {
            showAlert(title: "Oops!", message: "Please enter in all of the required information!")
            SVProgressHUD.dismiss()
        }else if (name.text != nil || email.text != nil || phoneNumber.text != nil || password.text != nil) {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
                //account created
                if (error != nil) {
                    self.showAlert(title: "Oops!", message: "There was an error while creating your account. Please ensure that your password is at least 6 characters and your email is valid")
                    SVProgressHUD.dismiss()
                }else {
                    SVProgressHUD.show()
                    self.saveAuthData(name: self.name.text!, email: self.email.text!, phone: self.phoneNumber.text!, password: self.password.text!)
                    
                    self.performSegueFunction(storyboardName: "Main")
                    SVProgressHUD.dismiss()
                    
                }
            }
        }
    }
    
    func saveAuthData(name: String, email: String, phone: String, password: String) {
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child(userID!).setValue(["fullName": name, "email": email, "phone":phone, "password":password])
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func performSegueFunction(storyboardName: String) {
        let viewController:UIViewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "authenticated") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
}
