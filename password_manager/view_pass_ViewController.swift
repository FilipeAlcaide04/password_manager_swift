import UIKit
import CoreData

class view_pass_ViewController: UIViewController {

    @IBOutlet weak var email: UIView!
    @IBOutlet weak var nome: UIView!
    @IBOutlet weak var password: UIView!
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!

    var accountItem: AccountValue?
    var isPasswordVisible = false
    var onDelete: (() -> Void)?  // Função que será chamada para atualizar a lista

    @objc func disableEditing() {
        passwordTextField.resignFirstResponder()  // Fecha o teclado imediatamente
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.addTarget(self, action: #selector(disableEditing), for: .editingDidBegin)

        
     
        email.layer.cornerRadius = 12
        nome.layer.cornerRadius = 12
        password.layer.cornerRadius = 12

        email.clipsToBounds = true
        nome.clipsToBounds = true
        password.clipsToBounds = true
        
        if let account = accountItem {
            nomeLabel.text = "\(account.name ?? "No name")"
            emailLabel.text = "\(account.email ?? "No email")"
            passwordTextField.text = "\(account.password ?? "No password")"
        }

        passwordTextField.isSecureTextEntry = true
        setupPasswordVisibilityToggle()
    }

    func setupPasswordVisibilityToggle() {
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        toggleButton.tintColor = UIColor.darkGray
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

    @IBAction func deleteAccount(_ sender: UIButton) {
        guard let account = accountItem else { return }

        let alert = UIAlertController(title: "Delete account",
                                      message: "Are you sure you want to delete this account",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteFromCoreData(account)
        }))

        present(alert, animated: true)
    }
    
    
    @IBAction func edit_pass(_ sender: Any) {
        
        performSegue(withIdentifier: "edit", sender: self)
        
    }
    

    func deleteFromCoreData(_ account: AccountValue) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        context.delete(account)

        do {
            try context.save()
            showSuccessMessage()
        } catch {
            print("Error in delete: \(error.localizedDescription)")
        }
    }

    func showSuccessMessage() {
        let successAlert = UIAlertController(title: "Success",
                                             message: "Account deleted successfully!",
                                             preferredStyle: .alert)

        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.onDelete?()  // 🔥 Atualiza a tabela na tela principal

            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)  // Voltar à tela anterior
            } else {
                self.dismiss(animated: true)  // Fechar modal
            }
        }))

        present(successAlert, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit",
           let destinationVC = segue.destination as? charlie_ViewController {
            destinationVC.accountItem = accountItem
            destinationVC.onSave = { [weak self] in
                self?.reloadData() // Atualiza os dados após edição
            }
        }
    }

    func reloadData() {
        if let account = accountItem {
            nomeLabel.text = account.name
            emailLabel.text = account.email
            passwordTextField.text = account.password
        }
    }



    
    
}



