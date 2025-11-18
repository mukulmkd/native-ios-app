#!/bin/bash
set -e

echo "🚀 Running postinstall setup for native-ios-app..."

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "${GREEN}Step 1/5: Creating .xcode.env file${NC}"
IOS_DIR="$PROJECT_ROOT/ios"
if [ ! -f "$IOS_DIR/.xcode.env" ]; then
  NODE_BINARY=$(command -v node)
  if [ -z "$NODE_BINARY" ]; then
    echo "${YELLOW}⚠️  Warning: Node.js not found in PATH. Please install Node.js or set NODE_BINARY manually.${NC}"
  else
    echo "export NODE_BINARY=$NODE_BINARY" > "$IOS_DIR/.xcode.env"
    echo "✅ Created .xcode.env with Node path: $NODE_BINARY"
  fi
else
  echo "✅ .xcode.env already exists"
fi

echo ""
echo "${GREEN}Step 2/5: Installing JavaScript dependencies${NC}"
if [ -d "$PROJECT_ROOT/js" ]; then
  cd "$PROJECT_ROOT/js"
  
  # Check if Verdaccio is running
  if ! curl -s http://localhost:4873 > /dev/null 2>&1; then
    echo "${YELLOW}⚠️  Warning: Verdaccio is not running on localhost:4873${NC}"
    echo "   Starting Verdaccio is required to install @app/* and @pkg/* packages"
    echo "   Run in monorepo: npm run verdaccio:start"
    echo "   Or install packages manually after starting Verdaccio"
  fi
  
  if [ ! -d "node_modules" ] || [ "package.json" -nt "node_modules" ]; then
    echo "📦 Running npm install in js/ directory..."
    # Use --legacy-peer-deps to handle peer dependency conflicts
    npm install --legacy-peer-deps || {
      echo "${YELLOW}⚠️  npm install failed, trying with --legacy-peer-deps...${NC}"
      npm install --legacy-peer-deps
    }
    echo "✅ JavaScript dependencies installed"
  else
    echo "✅ JavaScript dependencies already installed"
  fi
  
  # Verify @app/module-products is installed
  if [ ! -d "node_modules/@app/module-products" ]; then
    echo "${YELLOW}⚠️  Warning: @app/module-products not found in node_modules${NC}"
    echo "   This might be because Verdaccio is not running or package is not published"
    echo "   To fix:"
    echo "   1. Start Verdaccio: cd monorepo && npm run verdaccio:start"
    echo "   2. Publish packages: cd monorepo && npm run publish:verdaccio"
    echo "   3. Run: cd js && npm install"
  fi
  
  cd "$PROJECT_ROOT"
else
  echo "${YELLOW}⚠️  Warning: js/ directory not found${NC}"
fi

echo ""
echo "${GREEN}Step 3/5: Fixing Hermes headers${NC}"
if [ -f "$PROJECT_ROOT/js/scripts/fix-hermes-headers.sh" ]; then
  cd "$PROJECT_ROOT/js"
  bash scripts/fix-hermes-headers.sh || echo "${YELLOW}⚠️  Warning: Hermes header fix script failed (this is OK if headers are already fixed)${NC}"
  cd "$PROJECT_ROOT"
else
  echo "${YELLOW}⚠️  Warning: fix-hermes-headers.sh not found${NC}"
fi

echo ""
echo "${GREEN}Step 4/5: Installing CocoaPods dependencies${NC}"
if [ -d "$IOS_DIR" ] && [ -f "$IOS_DIR/Podfile" ]; then
  cd "$IOS_DIR"
  
  # Check if CocoaPods is installed
  if ! command -v pod &> /dev/null; then
    echo "${YELLOW}⚠️  Warning: CocoaPods not found. Installing via Homebrew...${NC}"
    if command -v brew &> /dev/null; then
      brew install cocoapods
    else
      echo "${YELLOW}⚠️  Error: Homebrew not found. Please install CocoaPods manually:${NC}"
      echo "   sudo gem install cocoapods"
      echo "   or"
      echo "   brew install cocoapods"
      exit 1
    fi
  fi
  
  # Use Homebrew pod if available, otherwise system pod
  POD_CMD="pod"
  if [ -f "/opt/homebrew/bin/pod" ]; then
    POD_CMD="/opt/homebrew/bin/pod"
  fi
  
  echo "📦 Running pod install..."
  $POD_CMD install
  echo "✅ CocoaPods dependencies installed"
  cd "$PROJECT_ROOT"
else
  echo "${YELLOW}⚠️  Warning: ios/Podfile not found${NC}"
fi

echo ""
echo "${GREEN}Step 5/5: Bundling JavaScript for iOS${NC}"
if [ -d "$PROJECT_ROOT/js" ] && [ -f "$PROJECT_ROOT/js/package.json" ]; then
  cd "$PROJECT_ROOT/js"
  if command -v react-native &> /dev/null || [ -f "node_modules/.bin/react-native" ]; then
    echo "📦 Bundling JavaScript..."
    if npm run bundle; then
      echo "✅ JavaScript bundled"
      
      # Automatically add bundle to Xcode project
      echo ""
      echo "${GREEN}Step 6/6: Adding bundle to Xcode project${NC}"
      if [ -f "$PROJECT_ROOT/scripts/add-bundle-to-xcode.py" ]; then
        python3 "$PROJECT_ROOT/scripts/add-bundle-to-xcode.py" || echo "${YELLOW}⚠️  Could not automatically add bundle to Xcode (you can add it manually)${NC}"
      else
        echo "${YELLOW}⚠️  add-bundle-to-xcode.py script not found${NC}"
      fi
    else
      echo "${YELLOW}⚠️  Warning: Bundle step failed${NC}"
      echo "   Make sure @app/module-products is installed: cd js && npm install --legacy-peer-deps"
      echo "   And that Verdaccio is running: npm run verdaccio:start (in monorepo)"
    fi
  else
    echo "${YELLOW}⚠️  Warning: react-native CLI not found. Skipping bundle step.${NC}"
    echo "   You can run it manually later with: cd js && npm run bundle"
  fi
  cd "$PROJECT_ROOT"
else
  echo "${YELLOW}⚠️  Warning: js/ directory or package.json not found${NC}"
fi

echo ""
echo "${GREEN}✅ Postinstall setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Open ios/NativeIOSApp.xcworkspace in Xcode (NOT the .xcodeproj file)"
echo "2. Select the 'NativeIOSApp' scheme"
echo "3. Select an iPhone simulator"
echo "4. Click the Play button (▶️) or press ⌘B to build"
echo ""
echo "If the bundle wasn't automatically added to Xcode:"
echo "  Run: python3 scripts/add-bundle-to-xcode.py"
echo ""

