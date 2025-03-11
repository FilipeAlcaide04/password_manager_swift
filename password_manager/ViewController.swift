import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        codeTextField.delegate = self // Set the UITextField delegate
    }

    @IBAction func checkCode(_ sender: UIButton) {
        let enteredCode = codeTextField.text ?? ""
        
        if enteredCode == "1234" {
            errorLabel.text = "Greetings"
            errorLabel.textColor = .green
            animateErrorLabel(shouldShow: true) // Success animation

            // Show alert and transition to the next screen after dismissal
            showAlert(title: "Success", message: "Welcome, Filipe!") {
                self.performSegue(withIdentifier: "main", sender: self)
            }

        } else {
            let errorMessage = enteredCode.isEmpty ? "Invalid code" : "Incorrect code"
            errorLabel.text = errorMessage
            errorLabel.textColor = .red
            animateErrorLabel(shouldShow: true) // Error animation
            
            // Show error alert
            showAlert(title: "Error", message: "Incorrect code. Please try again.")
        }
    }
    
    // Method to display alerts with an optional completion handler
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?() // Executes the action after the alert is dismissed
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // Error label animation
    func animateErrorLabel(shouldShow: Bool) {
        if shouldShow {
            errorLabel.isHidden = false
            errorLabel.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.errorLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.errorLabel.alpha = 0
            }) { _ in
                self.errorLabel.isHidden = true
            }
        }
    }
    
    // Dismiss the keyboard when pressing "Enter"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // Hide the keyboard
        return true
    }
}

