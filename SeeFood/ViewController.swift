import UIKit
import CoreML
import Vision

// simulation won't work will need a physical device to test and access camera

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // new variable that manages the system interfaces for taking pictures, recording movies, and choosing items from the user’s media library.
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assign the delegate to itself
        imagePicker.delegate = self
        // assign the sourceType as camera
        imagePicker.sourceType = .camera
        // don't allows editing
        imagePicker.allowsEditing = false
    }
    // This function is called when the user finishes picking an image using UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Extract the picked image from the info dictionary using the .originalImage key and downcast it as UIImage
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // assign the image to the valueimageView.image
            imageView.image = userPickedImage
        }
        // dismiss the image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // This is a function that gets called when the camera button is tapped
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        // We use the 'present' function to display the imagePicker
        // 'imagePicker' is assumed to be an instance of UIImagePickerController
        // This function animates the presentation of the imagePicker on the screen
        // 'animated: true' means the presentation is animated, and 'completion: nil' means there's no completion handler after the animation
        present(imagePicker, animated: true, completion: nil)
    }
    
}

