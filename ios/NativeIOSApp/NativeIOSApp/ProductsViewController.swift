import UIKit
import React

class ProductsViewController: UIViewController {
    
    var reactRootView: RCTRootView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products (RN)"
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
        
        // Create React Native root view with ModuleProducts
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: "ModuleProducts",
            initialProperties: nil
        )
        
        rootView.backgroundColor = .systemBackground
        rootView.frame = view.bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(rootView)
        self.reactRootView = rootView
    }
    
    private func setupFallbackView() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Loading Products Module..."
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

