import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets for UI elements
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTableView: UITableView!

    var passwords: [(website: String, password: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTableView.delegate = self
        passwordTableView.dataSource = self

        loadPasswords()
    }
    
    

    // Action to save a new password
    @IBAction func savePasswordButtonTapped(_ sender: UIButton) {
        if let website = websiteTextField.text, !website.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {

            // Add the new password to the list
            let newPassword = (website: website, password: password)
            passwords.append(newPassword)

            // Save the updated password list to UserDefaults
            savePasswords()

            // Reload the table view to display the new password
            passwordTableView.reloadData()

            // Clear the text fields for new entries
            websiteTextField.text = ""
            passwordTextField.text = ""
        }
    }

    // MARK: - TableView DataSource Methods

    
    // How many rows (passwords) to show in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }

    // How to configure each cell in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath)
        
        let passwordInfo = passwords[indexPath.row]
        cell.textLabel?.text = passwordInfo.website
        

        cell.detailTextLabel?.text = "••••••••"
        
        return cell
    }

    // MARK: - Local Storage Methods

    // Save passwords to UserDefaults
    func savePasswords() {
        let passwordsData = passwords.map { ["website": $0.website, "password": $0.password] }
        UserDefaults.standard.set(passwordsData, forKey: "savedPasswords")
    }

    // Load passwords from UserDefaults
    func loadPasswords() {
        if let savedPasswords = UserDefaults.standard.array(forKey: "savedPasswords") as? [[String: String]] {
            passwords = savedPasswords.compactMap { dict in
                guard let website = dict["website"], let password = dict["password"] else { return nil }
                return (website, password)
            }
        }
    }
}

