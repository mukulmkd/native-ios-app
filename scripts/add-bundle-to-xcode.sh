#!/bin/bash
# Script to add main.jsbundle to Xcode project's Copy Bundle Resources

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
XCODE_PROJECT="$PROJECT_ROOT/ios/NativeIOSApp/NativeIOSApp.xcodeproj/project.pbxproj"
BUNDLE_PATH="$PROJECT_ROOT/ios/NativeIOSApp/NativeIOSApp/main.jsbundle"

if [ ! -f "$BUNDLE_PATH" ]; then
    echo "❌ Bundle file not found at: $BUNDLE_PATH"
    echo "   Run: cd js && npm run bundle"
    exit 1
fi

if [ ! -f "$XCODE_PROJECT" ]; then
    echo "❌ Xcode project not found at: $XCODE_PROJECT"
    exit 1
fi

echo "✅ Bundle file exists: $BUNDLE_PATH"
echo "✅ Xcode project found: $XCODE_PROJECT"
echo ""
echo "⚠️  This script cannot automatically modify the Xcode project file."
echo "   Please add the bundle manually in Xcode:"
echo ""
echo "   1. Open NativeIOSApp.xcworkspace in Xcode"
echo "   2. In Project Navigator, right-click 'NativeIOSApp' folder"
echo "   3. Select 'Add Files to NativeIOSApp...'"
echo "   4. Select 'main.jsbundle'"
echo "   5. UNCHECK 'Copy items if needed'"
echo "   6. CHECK 'Create groups'"
echo "   7. CHECK 'NativeIOSApp' target"
echo "   8. Click 'Add'"
echo ""
echo "   Or verify it's in Build Phases → Copy Bundle Resources"

