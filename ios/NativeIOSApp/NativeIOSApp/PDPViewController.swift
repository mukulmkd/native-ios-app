import UIKit
import React

class PDPViewController: UIViewController {

    private let productId: String
    var reactRootView: RCTRootView?

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
        loadReactNativeModule()
    }
    
    private func loadReactNativeModule() {
        // Get the shared bridge from AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let bridge = appDelegate.bridge else {
            print("⚠️ React Native bridge not initialized")
            setupFallbackView()
            return
        }
        
        // Prepare initial properties for the React Native module
        let initialProperties: [String: Any] = [
            "productId": productId
        ]
        
        // Create React Native root view with ModulePDP
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: "ModulePDP",
            initialProperties: initialProperties
        )
        
        rootView.backgroundColor = .systemBackground
        rootView.frame = view.bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(rootView)
        self.reactRootView = rootView
    }
    
    private func setupFallbackView() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let label = UILabel()
        label.text = "Loading PDP Module..."
        label.textAlignment = .center
        
        let productIdLabel = UILabel()
        productIdLabel.text = "Product ID: \(productId)"
        productIdLabel.font = .systemFont(ofSize: 16, weight: .medium)
        productIdLabel.textColor = .systemBlue
        productIdLabel.textAlignment = .center
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(productIdLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Cleanup if needed
    }
    
    deinit {
        reactRootView?.removeFromSuperview()
        reactRootView = nil
    }
}

