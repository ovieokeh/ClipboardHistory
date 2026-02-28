import Foundation
import AppKit
import HotKey

class HotkeyManager: ObservableObject {
    private var hotKey: HotKey?
    
    // The action to perform when the hotkey is pressed
    var action: (() -> Void)?
    
    init() {
        setupHotkey()
    }
    
    private func setupHotkey() {
        // Control + Option + C
        // Note: Using Carbon modifiers: .control, .option
        hotKey = HotKey(key: .c, modifiers: [.control, .option])
        
        hotKey?.keyDownHandler = { [weak self] in
            self?.action?()
        }
    }
}
