# Native iOS App

Native iOS application consuming React Native modules from Verdaccio.

## 📋 Setup Order (For New Team Members)

**Follow this order when setting up for the first time:**

1. **✅ Monorepo** (set up first) - Must have Verdaccio running
2. **Native Android App** (set up second) - Optional, can be done in parallel
3. **✅ This Native iOS App** (set up third) - You are here

> **⚠️ Important**: You must set up the monorepo first and have Verdaccio running before setting up this app.

## Prerequisites

- **Node.js** >= 20
- **Xcode** (latest version recommended)
- **CocoaPods** (will be installed automatically if using Homebrew)
- **Homebrew** (optional, for easier CocoaPods installation)

## 🚀 First-Time Setup (For New Team Members)

> **⚠️ IMPORTANT**: You must set up the **monorepo first** and have Verdaccio running before setting up this native iOS app. See the monorepo README for setup instructions.

### Prerequisites

- **macOS** (required for iOS development)
- **Xcode** (latest version recommended) - [Download from App Store](https://apps.apple.com/us/app/xcode/id497799835)
- **Node.js** >= 20 - [Download](https://nodejs.org/)
- **npm** (comes with Node.js)
- **CocoaPods** (will be installed automatically if needed)
- **Monorepo set up** with Verdaccio running (see monorepo README)

### Step-by-Step Setup

Follow these steps **in order**:

#### Step 1: Verify Monorepo is Ready

**Before starting**, ensure:
- ✅ Monorepo is cloned and dependencies installed
- ✅ Verdaccio is running on `http://localhost:4873`
- ✅ Packages are published to Verdaccio (`npm run verdaccio:publish-all` in monorepo)
- ✅ You're logged into Verdaccio (`npm adduser --registry http://localhost:4873`)

**Test Verdaccio is accessible:**
```bash
curl http://localhost:4873
```

If you see HTML output, Verdaccio is running. If not, go back to monorepo setup.

#### Step 2: Clone and Navigate

```bash
# Clone the repository
git clone <repository-url>
cd native-ios-app
```

#### Step 3: Configure npm for Verdaccio

```bash
# Create .npmrc in the project root (if it doesn't exist)
cat > .npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF

# Also configure in js/ directory
cd js
cat > .npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF
cd ..
```

#### Step 4: Install Dependencies (Automatic Setup)

```bash
# Install all dependencies (this runs postinstall automatically)
npm install
```

**The `postinstall` script will automatically:**
- ✅ Create `.xcode.env` file with Node.js path
- ✅ Install JavaScript dependencies in `js/` directory (from Verdaccio)
- ✅ Fix Hermes headers
- ✅ Install CocoaPods dependencies
- ✅ Bundle JavaScript for iOS
- ✅ Add bundle to Xcode project

**Expected output**: You should see progress through each step. The process may take 5-10 minutes on first run.

**⚠️ If you see errors about packages not found:**
- Verify Verdaccio is running: `curl http://localhost:4873`
- Verify packages are published: `npm view @app/module-products --registry http://localhost:4873`
- Check `.npmrc` files exist and are correct

#### Step 5: Verify Setup

```bash
# Check that bundle was created
ls -lh ios/NativeIOSApp/NativeIOSApp/main.jsbundle

# Check that CocoaPods installed
ls -d ios/Pods
```

Both should exist. If not, see [Manual Setup](#manual-setup-if-postinstall-fails) below.

#### Step 6: Open in Xcode

```bash
# Open the workspace (NOT the .xcodeproj file!)
open ios/NativeIOSApp.xcworkspace
```

**⚠️ Important**: Always open `.xcworkspace`, never `.xcodeproj` directly.

#### Step 7: Build and Run

1. **Select Scheme**: 
   - Click the scheme dropdown (next to the Play button)
   - Select "NativeIOSApp"

2. **Select Simulator**: 
   - Next to the scheme dropdown
   - Select an iPhone simulator (e.g., "iPhone 15 Pro")

3. **Build and Run**: 
   - Click Play button (▶️) or press `⌘B` to build
   - Press `⌘R` to build and run

**Expected result**: The app should build and launch in the simulator.

**⚠️ First build may take 5-10 minutes** as Xcode compiles React Native and dependencies.

### ✅ Setup Complete!

Your native iOS app is now ready for development.

**Next Steps:**
- See [Daily Development](#daily-development-workflow) section below for daily workflows
- See [Troubleshooting](#troubleshooting) if you encounter issues

## 🔄 Daily Development Workflow

### Making Changes to React Native Modules

1. **Make changes** in the monorepo
2. **Publish updated packages** in monorepo: `npm run verdaccio:publish-all`
3. **Update dependencies** in this project:
   ```bash
   cd js
   npm install @app/module-products@latest --legacy-peer-deps
   ```
4. **Rebundle**:
   ```bash
   npm run bundle
   ```
5. **Rebuild in Xcode** (⌘B)

### Quick Commands

```bash
# Reinstall JavaScript dependencies
cd js && npm install --legacy-peer-deps && cd ..

# Reinstall CocoaPods
cd ios && pod install && cd ..

# Rebuild bundle
cd js && npm run bundle && cd ..
```

---

## Manual Setup (if postinstall fails)

If the automatic setup doesn't work, you can run it manually:

```bash
# Run the setup script
npm run setup

# Or step by step:
cd js && npm install --legacy-peer-deps && cd ..
cd ios && pod install && cd ..
cd js && npm run bundle && cd ..
```

## Troubleshooting

### CocoaPods Not Found

If you see `pod: command not found`:

```bash
# Option 1: Install via Homebrew (recommended)
brew install cocoapods

# Option 2: Install via RubyGems
sudo gem install cocoapods
```

### Build Errors

If you encounter build errors:

1. **Clean Build Folder**: In Xcode, Product → Clean Build Folder (⇧⌘K)
2. **Delete DerivedData**: 
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/NativeIOSApp-*
   ```
3. **Reinstall Pods**:
   ```bash
   npm run ios:clean
   ```

### Sandbox Errors

If you see sandbox permission errors, the postinstall script should have fixed this automatically. If not:

1. Check that `ENABLE_USER_SCRIPT_SANDBOXING = NO` in the Xcode project settings
2. Restart Xcode completely
3. Clean and rebuild

## Project Structure

```
native-ios-app/
├── ios/                    # iOS native code
│   ├── NativeIOSApp/       # Xcode project
│   ├── Podfile            # CocoaPods dependencies
│   └── .xcode.env         # Node.js path (auto-generated)
├── js/                     # JavaScript/React Native code
│   ├── index.js           # Entry point
│   ├── package.json       # JS dependencies
│   └── scripts/           # Build scripts
└── scripts/               # Setup scripts
    └── postinstall.sh     # Automatic setup script
```

## Available Scripts

- `npm install` - Install all dependencies and run postinstall
- `npm run setup` - Run the setup script manually
- `npm run ios:install` - Install CocoaPods dependencies
- `npm run ios:bundle` - Bundle JavaScript for iOS
- `npm run ios:clean` - Clean and reinstall CocoaPods

## Notes

- Always open `NativeIOSApp.xcworkspace` (NOT `.xcodeproj`)
- The `.xcode.env` file is auto-generated and should not be committed
- Most build warnings (200+) are normal for React Native projects
- CA Event errors in console are harmless (Apple's internal metrics)

## Project Structure Details

See `docs/PROJECT_STRUCTURE.md` for detailed information about the project layout and view controllers.
