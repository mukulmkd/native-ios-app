import UIKit
import React

class ProductsViewController: UIViewController {
    
    var reactRootView: RCTRootView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products (RN)"
        loadReactNativeModule()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload persisted state when view appears to ensure cart count is up-to-date
        // This is especially important when navigating back from Cart after clearing items
        reloadPersistedState()
    }
    
    private func reloadPersistedState() {
        // Send an event to the React Native module to reload persisted state
        // The React Native module will listen for this and reload state from AsyncStorage
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let bridge = appDelegate.bridge else {
            return
        }
        
        // Use DeviceEventEmitter to send event to React Native
        bridge.eventDispatcher().sendDeviceEvent(
            withName: "ReloadPersistedState",
            body: nil
        )
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

