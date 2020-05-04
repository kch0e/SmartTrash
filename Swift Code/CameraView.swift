import Foundation
import UIKit

//ML libraries
import Vision
import CoreML

import StatusBarMessage

//Firebase libraries
import Firebase
import SVProgressHUD

class CameraView: UIViewController {
    
    let image_classifier = ImageClassifier()
    var ref:DatabaseReference!
    var observations:[String] = []
    
    var pickerController = UIImagePickerController()
    
    public var capturedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    var detectedObject: String = ""
    var objectName: String = ""
    var confidence: Int = 0
    var databaseHandle:DatabaseHandle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "SmartTrash"
        
        
        imageView.image = capturedImage
        if let image = capturedImage {
            processPic(image: image)
        }
        
        SVProgressHUD.show()
        
        if Reachability.isConnectedToNetwork() == false {
            dismiss(animated: true, completion: nil)
            SVProgressHUD.dismiss()
            StatusBarMessage.show(with: "No Network Connection", style: .error, duration: 4.0)
            
        }else {
            SVProgressHUD.dismiss()
        }
        
        imageView.contentMode = .scaleToFill
        
        ref = Database.database().reference()
    }
    
    func processPic(image: UIImage){
        if let model = try? VNCoreMLModel(for: image_classifier.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation]{
                    self.detectedObject = results[0].identifier
                    let obj_classification = self.detectedObject
                    SVProgressHUD.show(withStatus: obj_classification)
                    
                }
            }
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
        
    }
    
    func saveObj_Class(classification: String) {
        
        //Getting current date
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        
        let dateString = dateFormatter.string(from: date)
        
        let userID = Auth.auth().currentUser?.uid
        
        if classification == "O" {
            self.ref.child("eBin").child(userID!).child(classification).child(dateString).setValue(objectName)
        }else if classification == "R" {
            self.ref.child("eBin").child(userID!).child(dateString).setValue(objectName)
        }
        
    }
    
    func openPopUp(further_class: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            let alertController = UIAlertController(title: "Namee This Object", message: "Please name this object", preferredStyle: UIAlertController.Style.alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Object Name..."
            }
            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                self.objectName = firstTextField.text!
                
                    // Put your code which should be executed with a delay here
                self.saveObj_Class(classification: further_class)
                
                SVProgressHUD.showSuccess(withStatus: "Success!")
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                
            }
            
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }

}

// EXTENSIONS
// MARK: - IBActions
extension CameraView {
    
    @IBAction func pickImage(_ sender: Any) {
        SVProgressHUD.show()
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .savedPhotosAlbum
        self.present(pickerController, animated: true)
        
        SVProgressHUD.dismiss()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraView: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Couldn't load image from Photos")
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Methods
extension CameraView {
    
    func detectScene(image: CIImage) {
        
        SVProgressHUD.show(withStatus: "Classifying Object...")
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: image_classifier.model) else {
            SVProgressHUD.showError(withStatus: "Unable to load model")
            fatalError("Unable to load model")
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    SVProgressHUD.showError(withStatus: "Unexpected result type from VNCoreMLRequest")
                    fatalError("Unexpected reult type from VNCoreMLRequest")
            }
            
            self!.detectedObject = topResult.identifier
            self!.confidence = Int(topResult.confidence * 100)
            
            let CONF = (topResult.confidence * 100)
            let DETECTED_OBJECT = topResult.identifier
            
            // Update UI on main queue
            DispatchQueue.main.async { [weak self] in
                
                if DETECTED_OBJECT == "O" {
                    SVProgressHUD.showInfo(withStatus: "\(CONF) it's non-recyclable")
                    
                }else if DETECTED_OBJECT == "R" {
                    SVProgressHUD.showInfo(withStatus: "\(CONF) it's Recylable")
                }else {
                    SVProgressHUD.showInfo(withStatus: "\(CONF) it's \(DETECTED_OBJECT)")
                }
                
                
                self!.openPopUp(further_class: DETECTED_OBJECT)
                

                
            }
        }
        
        // Run the Core ML Image Classifier classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }

    }
}

// MARK: - UINavigationControllerDelegate
extension CameraView: UINavigationControllerDelegate {
}
