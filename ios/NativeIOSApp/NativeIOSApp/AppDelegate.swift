import UIKit
import React

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bridge: RCTBridge?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize React Native bridge
        initializeReactNativeBridge()
        return true
    }
    
    private func initializeReactNativeBridge() {
        // Try to load bundled JavaScript, fallback to Metro bundler for development
        let fileManager = FileManager.default
        var jsCodeLocation: URL
        
        // First, try to find the bundle in the main bundle (production - when added to Copy Bundle Resources)
        if let bundleURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") {
            print("✅ Found bundled JavaScript in app bundle: \(bundleURL.path)")
            jsCodeLocation = bundleURL
        } else if let bundlePath = Bundle.main.path(forResource: "main", ofType: "jsbundle") {
            // Alternative method to find bundle
            jsCodeLocation = URL(fileURLWithPath: bundlePath)
            print("✅ Found bundled JavaScript: \(jsCodeLocation.path)")
        } else {
            // Check if bundle exists in the source directory (relative to app bundle)
            // This works when bundle is in the same directory as the app but not in Copy Bundle Resources
            let appBundlePath = Bundle.main.bundlePath
            let possiblePaths = [
                appBundlePath + "/../main.jsbundle",  // One level up from app bundle
                appBundlePath + "/../../main.jsbundle",  // Two levels up
                (appBundlePath as NSString).deletingLastPathComponent + "/main.jsbundle",  // Same directory as app bundle
            ]
            
            var foundBundle = false
            var sourceBundlePath: String? = nil
            
            for bundlePath in possiblePaths {
                if fileManager.fileExists(atPath: bundlePath) {
                    sourceBundlePath = bundlePath
                    foundBundle = true
                    break
                }
            }
            
            if foundBundle, let path = sourceBundlePath {
                jsCodeLocation = URL(fileURLWithPath: path)
                print("✅ Found bundled JavaScript in source directory: \(jsCodeLocation.path)")
            } else {
                // Last resort: use Metro bundler (requires Metro to be running)
                print("⚠️ Bundle not found in app bundle or source directory.")
                print("   Attempting to use Metro bundler (requires Metro on port 8081)...")
                print("   To fix: Add main.jsbundle to Xcode's 'Copy Bundle Resources' build phase")
                print("   Or start Metro: cd js && npx react-native start")
                jsCodeLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")!
            }
        }
        
        print("📦 Loading JavaScript from: \(jsCodeLocation.absoluteString)")
        bridge = RCTBridge(bundleURL: jsCodeLocation, moduleProvider: nil, launchOptions: nil)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
