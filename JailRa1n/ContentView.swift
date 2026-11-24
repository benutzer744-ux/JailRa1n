import SwiftUI
import UIKit
import Darwin

private enum Theme {
    static let green = Color(red: 0.47, green: 1.0, blue: 0.02)
    static let panel = Color(red: 0.07, green: 0.11, blue: 0.08)
}

struct ContentView: View {
    @State private var showingSettings = false
    @AppStorage("glowEnabled") private var glowEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 76, weight: .medium))
                        .foregroundStyle(Theme.green)
                        .shadow(color: glowEnabled ? Theme.green.opacity(0.7) : .clear, radius: 22)
                        .accessibilityHidden(true)

                    VStack(spacing: 6) {
                        Text("JailRa1n")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.green)
                        Text("Untethered Jailbreak • Concept")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        Label("Device Information", systemImage: "iphone.gen3")
                            .font(.headline)
                            .foregroundStyle(Theme.green)
                        Divider().overlay(Theme.green.opacity(0.2))
                        detail("Device Name", UIDevice.current.name)
                        detail("iPhone Model", DeviceInfo.modelName)
                        detail("iOS Version", UIDevice.current.systemVersion)
                        detail("Target iOS", "27.0.1")
                        detail("Jailbreak", "Not Jailbroken")
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Theme.panel, in: RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Jailbreak Engine").font(.headline)
                            Spacer()
                            Text("Unavailable")
                                .font(.caption.bold())
                                .foregroundStyle(.orange)
                        }
                        Text("No jailbreak engine is included in this preview.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Theme.panel, in: RoundedRectangle(cornerRadius: 20))

                    Button("Jailbreak") { }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Color.gray.opacity(0.23), in: RoundedRectangle(cornerRadius: 15))
                        .foregroundStyle(.gray)
                        .disabled(true)
                        .accessibilityHint("Not available in this version")

                    Text("Coming Soon • Interface Preview 0.1")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(22)
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(Theme.green)
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .tint(Theme.green)
    }

    private func detail(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(title).foregroundStyle(.gray)
            Spacer(minLength: 8)
            Text(value)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
        }
        .font(.subheadline)
    }
}

private struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("glowEnabled") private var glowEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Neon glow", isOn: $glowEnabled)
                }
                Section("About") {
                    LabeledContent("App", value: "JailRa1n")
                    LabeledContent("Version", value: "0.1")
                    LabeledContent("Target", value: "iOS 27.0.1")
                    LabeledContent("Engine", value: "Not implemented")
                }
                Section {
                    Text("This is a UI prototype. It does not jailbreak or modify your iPhone.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .tint(Theme.green)
        .preferredColorScheme(.dark)
    }
}

private enum DeviceInfo {
    static var modelName: String {
        var info = utsname()
        uname(&info)
        let identifier = withUnsafePointer(to: &info.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 256) {
                String(cString: $0)
            }
        }
        // Model identifiers remain accurate even when a new iPhone is not yet in the lookup.
        return identifier == "x86_64" || identifier == "arm64" ? "iPhone Simulator" : identifier
    }
}
