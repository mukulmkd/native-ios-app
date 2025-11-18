import UIKit
import React

class CartViewController: UIViewController {
    
    var reactRootView: RCTRootView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart (RN)"
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
        
        // Create React Native root view with ModuleCart
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: "ModuleCart",
            initialProperties: nil
        )
        
        rootView.backgroundColor = .systemBackground
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rootView)
        self.reactRootView = rootView
        
        // Use safe area layout guide to respect safe area insets
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupFallbackView() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Loading Cart Module..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

