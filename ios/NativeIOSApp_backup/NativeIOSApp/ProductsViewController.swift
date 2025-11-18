import UIKit

class ProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products (RN)"
        view.backgroundColor = .systemBackground
        setupPlaceholder()
    }

    private func setupPlaceholder() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let iconLabel = UILabel()
        iconLabel.text = "⚛️"
        iconLabel.font = .systemFont(ofSize: 64)
        iconLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.text = "Products Module"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "React Native module will be integrated here"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        let descriptionLabel = UILabel()
        descriptionLabel.text = "This placeholder will be replaced with the React Native module from Verdaccio."
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .tertiaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        stackView.addArrangedSubview(iconLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

