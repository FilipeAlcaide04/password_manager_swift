import UIKit
import CoreData

class testing_db_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var label: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [AccountValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register UITableViewCell class for reuse
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        // Set table view data source and delegate
        table.delegate = self
        table.dataSource = self
        
        // Fetch items to display
        getAllItems()
    }
    
    // Button action to refresh the table with all items
    @IBAction func btn(_ sender: Any) {
        getAllItems()
    }
    
    // Create a new item
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
    
    // Fetch all items and reload the table
    func getAllItems() {
        do {
            items = try context.fetch(AccountValue.fetchRequest())
            table.reloadData()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    // UITableViewDataSource methods
    
    // Return number of rows in section (number of items)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Configure the cell for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        if let name = item.name, let email = item.email, let password = item.password {
            cell.textLabel?.text = "Name: \(name)\nEmail: \(email)\nPassword: \(password)"
        }
        
        // Add Edit and Delete buttons
        let editButton = UIButton(type: .system)
        editButton.frame = CGRect(x: cell.frame.width - 100, y: 10, width: 40, height: 30)
        editButton.setTitle("Edit", for: .normal)
        editButton.tag = indexPath.row
        editButton.addTarget(self, action: #selector(editItem(_:)), for: .touchUpInside)
        cell.contentView.addSubview(editButton)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.frame = CGRect(x: cell.frame.width - 60, y: 10, width: 40, height: 30)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: #selector(deleteItem(_:)), for: .touchUpInside)
        cell.contentView.addSubview(deleteButton)
        
        return cell
    }
    
    // Edit item action
    @objc func editItem(_ sender: UIButton) {
        let item = items[sender.tag]
        
        // Here you would show a new screen or an alert to edit the item
        print("Editing item: \(item.name ?? "Unknown")")
        
        // For now, just update the item with some new data for testing
        updateItem(item: item, newName: "Updated Name", newEmail: "updated@test.com", newPassword: "newpassword")
    }
    
    // Delete item action
    @objc func deleteItem(_ sender: UIButton) {
        let item = items[sender.tag]
        
        // Delete the item
        context.delete(item)
        
        do {
            try context.save()
            print("Item deleted successfully.")
            getAllItems()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
    // Update item
    func updateItem(item: AccountValue, newName: String, newEmail: String, newPassword: String) {
        item.name = newName
        item.email = newEmail
        item.password = newPassword
        
        do {
            try context.save()
            print("Item updated successfully.")
            getAllItems()
        } catch {
            print("Failed to update item: \(error)")
        }
    }
}

