//
//  charlie_ViewController.swift
//  password_manager
//
//  Created by Filipe Alcaide on 09/03/2025.
//

import UIKit

class charlie_ViewController: UIViewController {
    @IBOutlet weak var image_meme: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var UpdateAccount: UIButton!  // Link to your UIButton in the storyboard

    @IBOutlet weak var pass_changed: UILabel!
    
    var isPasswordVisible = false
    var accountItem: AccountValue?  // Item a ser editado
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emoji.text = randomEmoji()
        
        setupUI()
        loadItemData()
        
        // Remove the save button from the navigation bar since you're using UpdateAccount button
        navigationItem.rightBarButtonItem = nil
        
        // Set up the action for the UpdateAccount button
        UpdateAccount.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
    }

    func setupUI() {
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
        
        styleTextField(nameTextField)
        styleTextField(emailTextField)
        styleTextField(passwordTextField)
    }

    func loadItemData() {
        // Preenche os campos com os dados do item a ser editado
        if let item = accountItem {
            nameTextField.text = item.name
            emailTextField.text = item.email
            passwordTextField.text = item.password
        }
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
    
    var onSave: (() -> Void)?  // Callback to reload items in alfa_ViewController
        
    @objc func saveChanges() {
        guard let item = accountItem else {
            print("Account item is nil")  // Debugging: Ensure the item is not nil
            return
        }

        // Check for empty fields
        if nameTextField.text?.isEmpty ?? true || emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "All fields must be filled out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        // Check if the fields have changed
        let isNameChanged = item.name != nameTextField.text
        let isEmailChanged = item.email != emailTextField.text
        let isPasswordChanged = item.password != passwordTextField.text

        if !isNameChanged && !isEmailChanged && !isPasswordChanged {
            let alert = UIAlertController(title: "No Changes", message: "No changes were made to the account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        // Update the account if there were changes
        item.name = nameTextField.text ?? ""
        item.email = emailTextField.text ?? ""
        item.password = passwordTextField.text ?? ""

        // Debugging: Check if the item values are correctly updated
        print("Updated Account: \(item.name ?? "") | \(item.email ?? "") | \(item.password ?? "")")

        // Show an alert that the password was updated successfully
        let alert = UIAlertController(title: "Password Updated", message: "Password updated successfully", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // After the user presses OK, save the context and go back to the previous view
            do {
                try self.context.save()
                print("Context saved successfully!")  // Debugging: Ensure context.save() is called

                // Trigger onSave closure (if present) to refresh the list in the previous view
                self.onSave?()
                
                // Navigate back to the previous view controller
                self.dismiss(animated: true)

                
            } catch {
                print("Error saving item: \(error)")
            }
        }))
        present(alert, animated: true)
    }

    


}
