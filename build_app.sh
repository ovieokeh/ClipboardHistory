#!/bin/bash

# Configuration
APP_NAME="ClipboardHistory"
EXECUTABLE_NAME="ClipboardHistory"
BUNDLE_ID="com.nerdylegs.ClipboardHistory"
VERSION="1.0.0"

echo "🔨 Building release executable..."
swift build -c release

echo "📦 Creating .app bundle structure..."
rm -rf "$APP_NAME.app"
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

echo "🚚 Copying executable..."
cp ".build/release/$EXECUTABLE_NAME" "$APP_NAME.app/Contents/MacOS/"

echo "🖼️ Compiling Assets..."
actool Assets.xcassets --compile "$APP_NAME.app/Contents/Resources" --platform macosx --minimum-deployment-target 13.0 --app-icon AppIcon --output-partial-info-plist .build/PartialInfo.plist

echo "📄 Generating Info.plist..."
cat > "$APP_NAME.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$EXECUTABLE_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF


echo "🔐 Codesigning app..."
codesign --force --deep --sign - "$APP_NAME.app"

echo "✅ Done! $APP_NAME.app has been created in the current directory."
