import Foundation
import AppKit
import Combine

class ClipboardMonitor: ObservableObject {
    @Published var history: [String] = []
    
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?
    
    init() {
        self.lastChangeCount = pasteboard.changeCount
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        // Poll the pasteboard changeCount every 0.5s
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkForChanges()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForChanges() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount
        
        if let newString = pasteboard.string(forType: .string) {
            let trimmed = newString.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                add(item: trimmed)
            }
        }
    }
    
    private func add(item: String) {
        // Remove the item if it already exists so we can move it to the top
        if let index = history.firstIndex(of: item) {
            history.remove(at: index)
        }
        
        // Insert at the beginning
        history.insert(item, at: 0)
        
        // Optional: truncate history if it gets too long, e.g., max 50 items
        if history.count > 50 {
            history.removeLast()
        }
    }
    
    func restore(item: String) {
        pasteboard.clearContents()
        pasteboard.setString(item, forType: .string)
    }
}
