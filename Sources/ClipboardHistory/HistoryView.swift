import SwiftUI
import ServiceManagement

struct HistoryView: View {
    @ObservedObject var monitor: ClipboardMonitor
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Clipboard History")
                    .font(.headline)
                Spacer()
                LaunchAtLoginToggle()
                    .padding(.trailing, 8)
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Text("Quit")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .keyboardShortcut("q", modifiers: [.command])
            }
            .padding()
            
            Divider()
            
            if monitor.history.isEmpty {
                Text("No recent items copied.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(monitor.history, id: \.self) { item in
                        Button(action: {
                            monitor.restore(item: item)
                            onClose?()
                        }) {
                            Text(item)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 4)
                    }
                }
            }
        }
        .frame(width: 350, height: 450)
    }
}

struct LaunchAtLoginToggle: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    
    var body: some View {
        Toggle("Launch at Login", isOn: $launchAtLogin)
            .toggleStyle(.checkbox)
            .font(.caption)
            .onChange(of: launchAtLogin) { newValue in
                do {
                    if newValue {
                        if SMAppService.mainApp.status == .enabled {
                            try? SMAppService.mainApp.unregister()
                        }
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print("Failed to update SMAppService: \(error.localizedDescription)")
                    // Revert state if failed
                    launchAtLogin = SMAppService.mainApp.status == .enabled
                }
            }
            .onAppear {
                launchAtLogin = SMAppService.mainApp.status == .enabled
            }
    }
}
