# ClipboardHistory

A lightweight, native macOS menu bar application that keeps track of your copied text history. Built with pure SwiftUI and Swift Package Manager.

## Features

- Native macOS menu bar integration
- Keeps a running history of your clipboard text
- Quick restoration of previous clipboard items
- Auto-start at login capability
- Global hotkey support (Control + Option + C)

## Requirements

- macOS 13.0 or later
- Swift 5.9 or later (for building)

## Installation

### Building from Source

This project uses Swift Package Manager and includes a custom build script to generate a proper macOS `.app` bundle.

1. Clone or download the repository to your local machine.
2. Open Terminal and navigate to the project directory:
   ```bash
   cd path/to/ClipboardHistory
   ```
3. Run the build script:
   ```bash
   ./build_app.sh
   ```
4. The script will automatically compile the Swift code, process the app icons, and generate a `ClipboardHistory.app` bundle in the same directory.
5. Drag `ClipboardHistory.app` to your `/Applications` folder to install it.

### Usage

1. Launch `ClipboardHistory.app`. An icon will appear in your menu bar.
2. Click the icon or press `Control + Option + C` to view your clipboard history.
3. Click any item in the list to copy it back to your current clipboard.
4. To have the app start automatically when you log in, check the "Launch at Login" box in the top right corner of the history window.

## Built With

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [HotKey](https://github.com/soffes/HotKey) - Global keyboard shortcuts
