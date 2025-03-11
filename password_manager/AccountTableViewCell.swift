import UIKit

protocol AccountTableViewCellDelegate: AnyObject {
    func didTapArrowButton(on cell: AccountTableViewCell)
}

class AccountTableViewCell: UITableViewCell {

    let customFont = UIFont(name: "Galvji", size: 15) ?? UIFont.systemFont(ofSize: 15)
    

    weak var delegate: AccountTableViewCellDelegate?

    @objc func arrowButtonTapped() {
        delegate?.didTapArrowButton(on: self)
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#E0E0E0")
        label.numberOfLines = 1
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#E0E0E0")
        label.numberOfLines = 1
        return label
    }()

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#E0E0E0")
        label.numberOfLines = 1
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#2C2B2E")
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        let arrowImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        button.setImage(arrowImage, for: .normal)
        button.tintColor = UIColor(hex: "#E0E0E0")
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
        
        backgroundColor = .clear
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero

        nameLabel.font = customFont
        emailLabel.font = customFont
        passwordLabel.font = customFont

        containerView.addSubview(nameLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(arrowButton)
        contentView.addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -10),

            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            emailLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -10),

            passwordLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            passwordLabel.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -10),
            passwordLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),

            arrowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            arrowButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 20),
            arrowButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

