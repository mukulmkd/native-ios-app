#!/bin/bash
# Verification script to check if setup completed successfully

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Verifying setup..."

ERRORS=0

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "${RED}❌ Node.js not found${NC}"
  ERRORS=$((ERRORS + 1))
else
  NODE_VERSION=$(node --version)
  echo "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
fi

# Check .xcode.env
if [ -f "ios/.xcode.env" ]; then
  echo "${GREEN}✅ .xcode.env file exists${NC}"
else
  echo "${YELLOW}⚠️  .xcode.env file not found (will be created on postinstall)${NC}"
fi

# Check JS dependencies
if [ -d "js/node_modules" ]; then
  echo "${GREEN}✅ JavaScript dependencies installed${NC}"
else
  echo "${RED}❌ JavaScript dependencies not installed${NC}"
  ERRORS=$((ERRORS + 1))
fi

# Check CocoaPods
if ! command -v pod &> /dev/null && [ ! -f "/opt/homebrew/bin/pod" ]; then
  echo "${YELLOW}⚠️  CocoaPods not found (will be installed on postinstall)${NC}"
else
  echo "${GREEN}✅ CocoaPods available${NC}"
fi

# Check Pods
if [ -d "ios/Pods" ]; then
  echo "${GREEN}✅ CocoaPods dependencies installed${NC}"
else
  echo "${YELLOW}⚠️  CocoaPods dependencies not installed (will be installed on postinstall)${NC}"
fi

# Check bundle
if [ -f "ios/NativeIOSApp/NativeIOSApp/main.jsbundle" ]; then
  echo "${GREEN}✅ JavaScript bundle exists${NC}"
else
  echo "${YELLOW}⚠️  JavaScript bundle not found (will be created on postinstall)${NC}"
fi

# Check workspace
if [ -f "ios/NativeIOSApp.xcworkspace/contents.xcworkspacedata" ]; then
  echo "${GREEN}✅ Xcode workspace exists${NC}"
else
  echo "${RED}❌ Xcode workspace not found${NC}"
  ERRORS=$((ERRORS + 1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "${GREEN}✅ Setup verification complete!${NC}"
  echo ""
  echo "You can now:"
  echo "1. Open ios/NativeIOSApp.xcworkspace in Xcode"
  echo "2. Select the 'NativeIOSApp' scheme"
  echo "3. Build and run!"
else
  echo "${RED}❌ Setup incomplete. Please run: npm install${NC}"
  exit 1
fi

