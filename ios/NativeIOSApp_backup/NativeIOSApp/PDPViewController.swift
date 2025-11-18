import UIKit

class PDPViewController: UIViewController {

    private let productId: String

    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PDP (RN)"
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
        iconLabel.text = "📦"
        iconLabel.font = .systemFont(ofSize: 64)
        iconLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.text = "Product Detail Module"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center

        let productIdLabel = UILabel()
        productIdLabel.text = "Product ID: \(productId)"
        productIdLabel.font = .systemFont(ofSize: 16, weight: .medium)
        productIdLabel.textColor = .systemBlue
        productIdLabel.textAlignment = .center

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
        stackView.addArrangedSubview(productIdLabel)
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

