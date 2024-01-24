import UIKit
import CoreML // import CoreML
import Vision // image analysis request

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
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            //launch the func detect
            detect(image: ciimage)
        }
        // dismiss the image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // This function is responsible for using a Core ML model (InceptionV3) to detect contours in a given CIImage.
    func detect(image: CIImage) {
        // Attempt to create a Core ML model instance using the InceptionV3 model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            // If the model creation fails, print an error message and terminate the app
            fatalError("Could not load the MLModel InceptionV3")
        }
        // Create a request for the Vision framework using the Core ML model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            // Completion block: This is executed after the request is processed
            // Ensure that the results can be cast to an array of VNClassificationObservation
            guard let results = request.results as? [VNClassificationObservation] else {
                // If casting fails, print an error message and terminate the app
                fatalError("Could not extract results from the request for processing")
            }
            // new variable with the first value of the results
            if let firstResult = results.first {
                //if the firstResult has on its identifier container the term hotdog
                if firstResult.identifier.contains("hotdog") {
                    // change the title to Hotdog
                    self.navigationItem.title = "Hotdog!"
                }
                else {
                    // if not not hotdog
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
        // Create an image request handler for processing the CIImage
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            // Perform the image request using the created handler and request
            try handler.perform([request])
        } catch {
            // If an error occurs during the request, print the error message to the console
            print(error)
        }
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

