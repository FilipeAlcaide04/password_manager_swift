import UIKit
import CoreData

protocol AddPasswordDelegate: AnyObject {
    func didSavePassword()
}

class add_pass_ViewController: UIViewController {
    
    weak var delegate: AddPasswordDelegate?
    
    @IBOutlet weak var image_meme: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emoji: UILabel!

    var isPasswordVisible = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emoji.text = randomEmoji()
        
        let placeholderColor = UIColor(red: 161/255, green: 161/255, blue: 165/255, alpha: 1.0)
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "📖 Name (e.g., Facebook)",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "📧 Email/Phone Number/Username",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "🔒 Password",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )

        addPadding(to: nameTextField)
        addPadding(to: emailTextField)
        addPadding(to: passwordTextField)
        
        setupPasswordVisibilityToggle()
        
        styleTextField(passwordTextField)
        styleTextField(emailTextField)
        styleTextField(nameTextField)
    }

    func addPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
    
    func styleTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
    }
    
    func setupPasswordVisibilityToggle() {
        let toggleButton = UIButton(type: .custom)
        
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        toggleButton.tintColor = UIColor(red: 161/255, green: 161/255, blue: 165/255, alpha: 1.0)
        
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let buttonWidth: CGFloat = 30
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth + 15, height: passwordTextField.frame.height))
        
        passwordTextField.rightView = rightPaddingView
        passwordTextField.rightViewMode = .always
        
        toggleButton.frame = CGRect(x: 5, y: 0, width: buttonWidth, height: passwordTextField.frame.height)
        rightPaddingView.addSubview(toggleButton)
    }

    @objc func togglePasswordVisibility(sender: UIButton) {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        sender.isSelected = isPasswordVisible
    }

    func randomEmoji() -> String {
        let emojis = ["🦖", "🌞", "🚀", "🌝", "🤓", "🧠", "🫠", "🐉", "🎩", "🎸",
                      "🍕", "🌊", "🐧", "🔥", "🎃", "💡", "🦄", "⚡", "📸", "🎮"]
        return emojis.randomElement() ?? "error"
    }

    func savePassword() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please fill in all fields.")
            return
        }

        let newItem = AccountValue(context: context)
        newItem.name = name
        newItem.email = email
        newItem.password = password

        do {
            try context.save()
            print("Senha salva com sucesso!") // 🔍 Depuração

            showSuccessAlert() // ✅ Chamar alerta de sucesso antes de fechar a tela
        } catch {
            print("Failed to save password: \(error)")
        }
    }

    func showSuccessAlert() {
        let successAlert = UIAlertController(title: "Success",
                                             message: "Password saved successfully!",
                                             preferredStyle: .alert)
        
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.didSavePassword() // ✅ Atualiza a lista na tela anterior
            self.dismissOrPopViewController()
        }))

        present(successAlert, animated: true)
    }



    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func dismissOrPopViewController() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        savePassword()
        
    }
    
    
}

