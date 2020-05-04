import UIKit
import Firebase
import SVProgressHUD

class ForgotPassword: UITableViewController {

    @IBOutlet weak var email: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.becomeFirstResponder()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        if (email.text == "") {
            showAlert(title: "Oops!", message: "You need to enter in your email in order to receive a password reset email.")
            
        }else {
            SVProgressHUD.show()
            Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                // reset email
                if (error != nil) {
                    self.showAlert(title: "Oops!", message: "There was an error while sending your password reset email.")
                    SVProgressHUD.dismiss()
                }else {
                    SVProgressHUD.show()
                    self.finishReset(title: "Congratulations!", message: "Please check your email and follow the prompt.")
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func finishReset(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
}
