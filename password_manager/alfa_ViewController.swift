import UIKit
import CoreData

class alfa_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddPasswordDelegate {
    
    @IBOutlet weak var new_pass: UIButton!
    @IBOutlet weak var gen_pass: UIButton!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var emoji_bar: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var view_table: UIView!
    @IBOutlet weak var frase: UILabel!
    
    var items: [AccountValue] = []
    var selectedAccountItem: AccountValue?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func randomEmoji() -> String {
        let emojis = ["🦖", "🌞", "🚀", "🌝", "🤓", "🧠", "🫠", "🐉", "🎩", "🎸",
                      "🍕", "🌊", "🐧", "🔥", "🎃", "💡", "🦄", "⚡", "📸", "🎮"]
        return emojis.randomElement() ?? "error"
    }

    func didSavePassword() {
        print("Senha salva, atualizando a lista...") // 🔍 Depuração
        getAllItems()
        table.reloadData()
    }



    
    func randomPhrase() -> String {
        let securityQuotes = [
            "Freedom without security is a jail.",
            "Ignored risks are the deadliest.",
            "Protection demands vigilance.",
            "Nothing is truly secure.",
            "Caution prevents disaster.",
            "Blind trust is vulnerability.",
            "Security stems from preparation.",
            "Fear weakens defense.",
            "Controlled risk is power.",
            "Illusion never protects anyone."
        ]

        return securityQuotes.randomElement() ?? "error"
    }

    
    @objc func searchTextChanged() {
        if let searchText = search.text?.lowercased(), !searchText.isEmpty {
            items = items.filter { item in
                return item.name?.lowercased().contains(searchText) ?? false
            }
        } else {
            getAllItems()
        }
        table.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.separatorStyle = .none
        
        search.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        self.navigationItem.hidesBackButton = true
        emoji_bar.text = randomEmoji()
        frase.text = randomPhrase()
        
        view_table.layer.cornerRadius = 12
        view_table.clipsToBounds = true

        let placeholderColor = UIColor(red: 161/255, green: 161/255, blue: 165/255, alpha: 1.0)
        search.attributedPlaceholder = NSAttributedString(
            string: "🔎  Search for names",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )

        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100

        styleTextField(search)
        addPadding(to: search)

        table.register(AccountTableViewCell.self, forCellReuseIdentifier: "AccountCell")
        table.delegate = self
        table.dataSource = self

        
        navigationController?.navigationBar.isHidden = true
        table.contentInsetAdjustmentBehavior = .never

        getAllItems()
    }

    func getAllItems() {
        do {
            items = try context.fetch(AccountValue.fetchRequest())
            print("Itens carregados: \(items.count)") // Para depuração
            DispatchQueue.main.async {
                self.table.reloadData()  // 🔥 Atualiza a interface gráfica na thread principal
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    @IBAction func reload(_ sender: Any) {
        getAllItems();
    }
    
    func createItem(name: String, email: String, password: String) {
        let newItem = AccountValue(context: context)
        newItem.name = name
        newItem.email = email
        newItem.password = password

        do {
            try context.save()
            print("Item saved successfully.")
            getAllItems()
        } catch {
            print("Failed to save item: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func pontos(_ password: String?) -> String {
        // Just an example of what you could do with the password
        guard let password = password else { return "No Password" }
        // Example: Masking part of the password for security
        let maskedPassword = String(repeating: "*", count: password.count)
        return maskedPassword
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountTableViewCell
        let item = items[indexPath.row]
        
        cell.delegate = self

        let customFont = UIFont(name: "Galvji", size: 15) ?? UIFont.systemFont(ofSize: 15)

        cell.nameLabel.text = "Name: \(item.name ?? "No Name")"
        cell.nameLabel.font = customFont
        cell.nameLabel.textColor = UIColor(hex: "#E0E0E0")
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .byWordWrapping

        cell.emailLabel.text = "Email: \(item.email ?? "No Email")"
        cell.emailLabel.font = customFont
        cell.emailLabel.textColor = UIColor(hex: "#E0E0E0")
        cell.emailLabel.numberOfLines = 0
        cell.emailLabel.lineBreakMode = .byWordWrapping

        cell.passwordLabel.text = "Password: \(pontos(item.password))"

        cell.passwordLabel.font = customFont
        cell.passwordLabel.textColor = UIColor(hex: "#E0E0E0")
        cell.passwordLabel.numberOfLines = 0
        cell.passwordLabel.lineBreakMode = .byWordWrapping

        cell.contentView.backgroundColor = UIColor(hex: "#2C2B2E")
        cell.backgroundColor = UIColor.clear

        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 5
        
        let separatorView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.height - 2, width: cell.contentView.frame.width, height: 2))
        separatorView.backgroundColor = UIColor(hex: "#121212") // Custom color
        separatorView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        cell.contentView.addSubview(separatorView)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Verifique se a segue tem o identificador correto "showAddPassword"
        if segue.identifier == "showAddPassword",
             let destinationVC = segue.destination as? add_pass_ViewController {
              destinationVC.delegate = self // 🔥 Passando a responsabilidade de atualizar a lista
          }
        // Verifica a segue de edição da conta
        else if segue.identifier == "showEditAccount", let destinationVC = segue.destination as? charlie_ViewController {
            destinationVC.accountItem = selectedAccountItem
            destinationVC.onSave = {
                self.getAllItems()  // Atualiza a lista após a edição
            }
        }
        // Verifica a segue para visualização da senha
        else if segue.identifier == "showViewPass", let destinationVC = segue.destination as? view_pass_ViewController {
            destinationVC.accountItem = selectedAccountItem
            destinationVC.onDelete = {
                self.getAllItems()  // Atualiza a lista após excluir a conta
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllItems() // Recarregar os itens ao aparecer a tela
        table.reloadData()
    }

    func updateItem(item: AccountValue, newName: String, newEmail: String, newPassword: String) {
        item.name = newName
        item.email = newEmail
        item.password = newPassword

        do {
            try context.save()
            getAllItems()
        } catch {
            print("Failed to update item: \(error)")
        }
    }

    func styleTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
    }

    func addPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
    }
}

extension alfa_ViewController: AccountTableViewCellDelegate {
    func didTapArrowButton(on cell: AccountTableViewCell) {
        if let indexPath = table.indexPath(for: cell) {
            let selectedItem = items[indexPath.row]
            selectedAccountItem = selectedItem
            performSegue(withIdentifier: "showViewPass", sender: self)
        }
    }
    


}

