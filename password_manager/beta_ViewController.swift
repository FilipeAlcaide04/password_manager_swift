import UIKit

class beta_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker_number: UIPickerView!
    @IBOutlet weak var include_symbols: UISwitch!
    
    @IBOutlet weak var pass_generated: UILabel!
    
    let passwordLengths = Array(8...16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar o PickerView
        picker_number.delegate = self
        picker_number.dataSource = self
    }
    
    // Número de colunas no PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Número de linhas no PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return passwordLengths.count
    }
    
    // Estilizar o PickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.text = "\(passwordLengths[row])"
        label.textColor = UIColor(hex: "#E0E0E0") // Cor cinza claro
        label.font = UIFont(name: "Galvji", size: 20) ?? UIFont.systemFont(ofSize: 20)
        return label
    }
    
    // Método para gerar uma senha forte
    func generateStrongPassword(length: Int, includeSymbols: Bool) -> String {
        let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
        let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let specialCharacters = "!@#$%^&*()_+[]{}|;:,.<>?/`~"
        
        // Definir os caracteres disponíveis com base no switch
        let allCharacters = lowercaseLetters + uppercaseLetters + digits + (includeSymbols ? specialCharacters : "")
        
        var password = ""
        
        // Garante pelo menos um caractere de cada tipo necessário
        password.append(lowercaseLetters.randomElement()!)
        password.append(uppercaseLetters.randomElement()!)
        password.append(digits.randomElement()!)
        
        if includeSymbols {
            password.append(specialCharacters.randomElement()!)
        }
        
        // Preencher o restante da senha com caracteres aleatórios
        while password.count < length {
            password.append(allCharacters.randomElement()!)
        }
        
        // Embaralhar os caracteres para evitar previsibilidade
        return String(password.shuffled())
    }
    
    @IBAction func generate_password(_ sender: Any) {
        // Obtém o tamanho da senha escolhido no PickerView
        let selectedRow = picker_number.selectedRow(inComponent: 0)
        let passwordLength = passwordLengths[selectedRow]
        
        // Verifica se deve incluir símbolos
        let includeSymbols = include_symbols.isOn
        
        // Gera a senha
        let password = generateStrongPassword(length: passwordLength, includeSymbols: includeSymbols)
        
        // Exibe ou usa a senha gerada
        print("Generated Password: \(password)")
        
        // Copiar a senha para a área de transferência
        UIPasteboard.general.string = password
        
        // Atualizar o rótulo para mostrar que a senha foi copiada
        pass_generated.textColor = .green
        pass_generated.text = "Password copied to clipboard"
    }
}

// Extensão para criar UIColor a partir de um código hexadecimal
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

