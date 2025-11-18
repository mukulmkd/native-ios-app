# Project Structure

## Directory Layout

```
native-ios-app/
├── ios/
│   ├── NativeIOSApp/
│   │   └── NativeIOSApp/
│   │       ├── AppDelegate.swift          # App lifecycle delegate
│   │       ├── SceneDelegate.swift        # Scene lifecycle delegate
│   │       ├── MainViewController.swift   # Main menu with 6 cards
│   │       ├── HomeViewController.swift   # Native Home screen
│   │       ├── ProfileViewController.swift # Native Profile screen
│   │       ├── SettingsViewController.swift # Native Settings screen
│   │       ├── ProductsViewController.swift # RN Products (placeholder)
│   │       ├── CartViewController.swift   # RN Cart (placeholder)
│   │       ├── PDPViewController.swift    # RN PDP (placeholder)
│   │       └── Info.plist                 # App configuration
│   └── Podfile                            # CocoaPods dependencies
├── js/                                    # JavaScript workspace (for RN modules)
├── docs/                                  # Documentation
├── scripts/                               # Setup scripts
├── README.md                              # Project overview
├── QUICK_START.md                         # Quick setup guide
└── package.json                           # Root package.json
```

## View Controllers

### MainViewController
- **Purpose**: Main menu screen with 6 cards
- **Cards**:
  1. Home (Native)
  2. Profile (Native)
  3. Settings (Native)
  4. Products (RN) - Placeholder
  5. Cart (RN) - Placeholder
  6. PDP (RN) - Placeholder

### Native View Controllers
- **HomeViewController**: Simple native screen
- **ProfileViewController**: Simple native screen
- **SettingsViewController**: Simple native screen

### React Native Placeholders
- **ProductsViewController**: Placeholder for React Native Products module
- **CartViewController**: Placeholder for React Native Cart module
- **PDPViewController**: Placeholder for React Native PDP module

These will be replaced with React Native integration later.

## Navigation Flow

```
MainViewController (Menu)
├── HomeViewController
├── ProfileViewController
├── SettingsViewController
├── ProductsViewController (RN - Placeholder)
├── CartViewController (RN - Placeholder)
└── PDPViewController (RN - Placeholder)
```

## Next Steps

1. ✅ Create Xcode project
2. ✅ Add Swift files to project
3. ✅ Configure project settings
4. ⏳ Integrate React Native
5. ⏳ Add modules from Verdaccio
6. ⏳ Replace placeholders with RN modules

