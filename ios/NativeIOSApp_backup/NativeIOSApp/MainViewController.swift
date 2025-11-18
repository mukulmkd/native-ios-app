import UIKit

class MainViewController: UIViewController {

    private let cardTitles = [
        "Home",
        "Profile",
        "Settings",
        "Products (RN)",
        "Cart (RN)",
        "PDP (RN)"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Native iOS App"
        view.backgroundColor = .systemBackground
        setupCards()
    }

    private func setupCards() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // Create cards
        for (index, title) in cardTitles.enumerated() {
            let card = createCard(title: title, index: index)
            stackView.addArrangedSubview(card)
        }

        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        // Set card heights
        for card in stackView.arrangedSubviews {
            card.heightAnchor.constraint(equalToConstant: 120).isActive = true
        }
    }

    private func createCard(title: String, index: Int) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        // Add subtitle for RN modules
        if title.contains("(RN)") {
            let subtitleLabel = UILabel()
            subtitleLabel.text = "React Native Module (Placeholder)"
            subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.textAlignment = .center
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -10),

                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                subtitleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
            ])
        }

        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.tag = index
        cardView.isUserInteractionEnabled = true

        return cardView
    }

    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        let index = cardView.tag
        let title = cardTitles[index]

        switch title {
        case "Home":
            navigateToHome()
        case "Profile":
            navigateToProfile()
        case "Settings":
            navigateToSettings()
        case "Products (RN)":
            navigateToProducts()
        case "Cart (RN)":
            navigateToCart()
        case "PDP (RN)":
            navigateToPDP()
        default:
            break
        }
    }

    private func navigateToHome() {
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }

    private func navigateToProfile() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func navigateToSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    private func navigateToProducts() {
        let productsVC = ProductsViewController()
        navigationController?.pushViewController(productsVC, animated: true)
    }

    private func navigateToCart() {
        let cartVC = CartViewController()
        navigationController?.pushViewController(cartVC, animated: true)
    }

    private func navigateToPDP() {
        let pdpVC = PDPViewController(productId: "placeholder")
        navigationController?.pushViewController(pdpVC, animated: true)
    }
}

