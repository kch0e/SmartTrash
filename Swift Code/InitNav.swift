import UIKit

class InitNav: UIViewController {
    
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        signUp.layer.cornerRadius = 5
        
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    

}
