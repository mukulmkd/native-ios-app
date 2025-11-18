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
  - Check: `curl http://localhost:4873` should return HTML
  - If not running: `cd monorepo && npm run verdaccio:start`
- ✅ Packages are published to Verdaccio
  - Run in monorepo: `npm run verdaccio:publish-all`
  - Verify: `npm view @app/module-products --registry http://localhost:4873` should show version 0.1.8
- ✅ You're logged into Verdaccio
  - Check: `npm whoami --registry http://localhost:4873`
  - If not logged in: `npm adduser --registry http://localhost:4873` (use any username/password)

**Test Verdaccio is accessible:**
```bash
curl http://localhost:4873
```

If you see HTML output, Verdaccio is running. If not, go back to monorepo setup.

#### Step 2: Clone and Navigate

```bash
# Clone the repository (replace <repository-url> with actual URL)
git clone <repository-url>
cd native-ios-app

# Or if you already have the repository, just navigate to it
cd /path/to/native-ios-app
```

#### Step 3: Configure npm for Verdaccio

```bash
# Create .npmrc in the project root (if it doesn't exist)
if [ ! -f .npmrc ]; then
  cat > .npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF
  echo "✅ Created .npmrc in project root"
else
  echo "✅ .npmrc already exists in project root"
fi

# Also configure in js/ directory (required for npm install)
cd js
if [ ! -f .npmrc ]; then
  cat > .npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF
  echo "✅ Created .npmrc in js/ directory"
else
  echo "✅ .npmrc already exists in js/ directory"
fi
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

**Expected output**: You should see progress through each step:
- ✅ Step 1/5: Creating .xcode.env file
- ✅ Step 2/5: Installing JavaScript dependencies (may take 2-3 minutes)
- ✅ Step 3/5: Fixing Hermes headers
- ✅ Step 4/5: Installing CocoaPods dependencies (may take 3-5 minutes)
- ✅ Step 5/5: Bundling JavaScript for iOS
- ✅ Step 6/6: Adding bundle to Xcode project

**Total time**: The process may take 5-10 minutes on first run, depending on your internet connection and machine speed.

**⚠️ If you see errors about packages not found:**
- Verify Verdaccio is running: `curl http://localhost:4873`
- Verify packages are published: `npm view @app/module-products --registry http://localhost:4873`
- Check `.npmrc` files exist in both project root and `js/` directory
- Verify you're logged into Verdaccio: `npm whoami --registry http://localhost:4873`
- If not logged in: `npm adduser --registry http://localhost:4873` (use any username/password)

#### Step 5: Verify Setup

```bash
# Check that bundle was created (should be ~1.2MB)
ls -lh ios/NativeIOSApp/NativeIOSApp/main.jsbundle

# Check that CocoaPods installed
ls -d ios/Pods

# Check that .xcode.env exists
ls ios/.xcode.env

# Check that modules are installed
ls js/node_modules/@app/module-products
```

**Expected results:**
- ✅ Bundle file exists and is ~1.2MB
- ✅ `ios/Pods` directory exists
- ✅ `ios/.xcode.env` file exists
- ✅ `js/node_modules/@app/module-products` directory exists

If any of these are missing, see [Manual Setup](#manual-setup-if-postinstall-fails) below or [Troubleshooting](#troubleshooting).

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

**Common first-build issues:**
- If you see "Cannot find module" errors: Make sure the bundle was created (`ls ios/NativeIOSApp/NativeIOSApp/main.jsbundle`)
- If you see "Sandbox" errors: The postinstall script should have fixed this, but if not, see [Troubleshooting](#troubleshooting)
- If you see "Hermes" errors: Make sure `.xcode.env` exists in `ios/` directory

### ✅ Setup Complete!

Your native iOS app is now ready for development.

**Quick Verification Checklist:**
- ✅ Bundle file exists: `ls -lh ios/NativeIOSApp/NativeIOSApp/main.jsbundle` (should be ~1.2MB)
- ✅ CocoaPods installed: `ls -d ios/Pods` (should exist)
- ✅ .xcode.env exists: `ls ios/.xcode.env` (should exist)
- ✅ .npmrc files exist: `ls -la .npmrc js/.npmrc` (both should exist)
- ✅ Modules installed: `ls js/node_modules/@app/module-products` (should exist)

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
   npm install @app/module-products@latest @app/module-cart@latest @app/module-pdp@latest --legacy-peer-deps
   ```
4. **Rebundle**:
   ```bash
   npm run bundle
   ```
5. **Rebuild in Xcode** (⌘B)

### Current Module Versions

- `@app/module-products@^0.1.8` - Products listing module
- `@app/module-cart@^0.1.8` - Shopping cart module
- `@app/module-pdp@^0.1.8` - Product detail page module
- `@pkg/state@^0.1.5` - Redux state management with persistence

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
# Option 1: Run the setup script directly
npm run setup

# Option 2: Step by step (if script fails)
# 1. Create .npmrc files (if missing)
cat > .npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF
cat > js/.npmrc << EOF
@app:registry=http://localhost:4873
@pkg:registry=http://localhost:4873
EOF

# 2. Create .xcode.env
echo "export NODE_BINARY=$(command -v node)" > ios/.xcode.env

# 3. Install JavaScript dependencies
cd js && npm install --legacy-peer-deps && cd ..

# 4. Fix Hermes headers
cd js && bash scripts/fix-hermes-headers.sh && cd ..

# 5. Install CocoaPods
cd ios && pod install && cd ..

# 6. Bundle JavaScript
cd js && npm run bundle && cd ..

# 7. Add bundle to Xcode (if automatic script failed)
python3 scripts/add-bundle-to-xcode.py
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

If you see sandbox permission errors (e.g., "Sandbox: rsync(...) deny(1) file-read-data"), the postinstall script should have fixed this automatically. If not:

1. Open `ios/NativeIOSApp/NativeIOSApp.xcodeproj/project.pbxproj` in a text editor
2. Search for `ENABLE_USER_SCRIPT_SANDBOXING` and set it to `NO` for both Debug and Release configurations
3. Restart Xcode completely
4. Clean and rebuild: Product → Clean Build Folder (⇧⌘K), then rebuild

### Module Not Found Errors

If you see "Unable to resolve module @app/module-products" or similar:

1. **Verify Verdaccio is running**: `curl http://localhost:4873`
2. **Check .npmrc files exist**:
   ```bash
   ls -la .npmrc js/.npmrc
   ```
3. **Verify packages are published**:
   ```bash
   npm view @app/module-products --registry http://localhost:4873
   ```
4. **Reinstall dependencies**:
   ```bash
   cd js && rm -rf node_modules package-lock.json && npm install --legacy-peer-deps && cd ..
   ```
5. **Rebundle**:
   ```bash
   cd js && npm run bundle && cd ..
   ```

### Bundle Not Found

If Xcode can't find `main.jsbundle`:

1. **Check bundle exists**:
   ```bash
   ls -lh ios/NativeIOSApp/NativeIOSApp/main.jsbundle
   ```
2. **If missing, create it**:
   ```bash
   cd js && npm run bundle && cd ..
   ```
3. **Add to Xcode manually** (if automatic script failed):
   - Right-click 'NativeIOSApp' folder in Xcode
   - Select 'Add Files to NativeIOSApp...'
   - Select `main.jsbundle`
   - **UNCHECK** 'Copy items if needed'
   - **CHECK** 'Create groups' and 'NativeIOSApp' target
   - Click 'Add'

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
