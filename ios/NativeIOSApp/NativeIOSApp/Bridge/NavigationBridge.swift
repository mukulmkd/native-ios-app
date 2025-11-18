import Foundation
import React
import UIKit

@objc(NavigationBridge)
class NavigationBridge: NSObject, RCTBridgeModule {
    
    static func moduleName() -> String! {
        return "NavigationBridge"
    }
    
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func navigateToPDP(_ productId: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let navigationController = window.rootViewController as? UINavigationController else {
                print("⚠️ Error: Could not get navigation controller for PDP navigation")
                return
            }
            
            let pdpVC = PDPViewController(productId: productId)
            navigationController.pushViewController(pdpVC, animated: true)
        }
    }
    
    @objc
    func navigateToCart() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let navigationController = window.rootViewController as? UINavigationController else {
                print("⚠️ Error: Could not get navigation controller for Cart navigation")
                return
            }
            
            let cartVC = CartViewController()
            navigationController.pushViewController(cartVC, animated: true)
        }
    }
    
    @objc
    func navigateToProducts() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let navigationController = window.rootViewController as? UINavigationController else {
                print("⚠️ Error: Could not get navigation controller for Products navigation")
                return
            }
            
            // Check if ProductsViewController is already in the stack
            if let productsVC = navigationController.viewControllers.first(where: { $0 is ProductsViewController }) {
                navigationController.popToViewController(productsVC, animated: true)
            } else {
                // Push ProductsViewController
                let productsVC = ProductsViewController()
                navigationController.pushViewController(productsVC, animated: true)
            }
        }
    }
}

