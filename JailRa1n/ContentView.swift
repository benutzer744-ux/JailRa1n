import SwiftUI
import UIKit

// MARK: - Color themes

enum JailRa1nTheme: String, CaseIterable, Identifiable {
    case green, blue, purple, pink, red, white
    var id: String { rawValue }

    var name: String {
        switch self {
        case .green: return "Neon Green"
        case .blue: return "Electric Blue"
        case .purple: return "Neon Purple"
        case .pink: return "Hot Pink"
        case .red: return "Fire Red"
        case .white: return "Arctic White"
        }
    }

    var color: Color {
        switch self {
        case .green: return Color(red: 0.49, green: 1, blue: 0)
        case .blue: return Color(red: 0, green: 0.75, blue: 1)
        case .purple: return Color(red: 0.70, green: 0.30, blue: 1)
        case .pink: return Color(red: 1, green: 0.24, blue: 0.60)
        case .red: return Color(red: 1, green: 0.27, blue: 0.27)
        case .white: return Color(red: 0.94, green: 0.96, blue: 0.98)
        }
    }
}

// MARK: - Device information

enum JailRa1nDevice {
    static var name: String { UIDevice.current.name }
    static var iosVersion: String { UIDevice.current.systemVersion }

    static var identifier: String {
        var info = utsname()
        uname(&info)
        return withUnsafeBytes(of: &info.machine) { bytes in
            let characters = bytes.prefix { $0 != 0 }
            return String(decoding: characters, as: UTF8.self)
        }
    }
}

// MARK: - Reusable UI

private struct JRCard<Content: View>: View {
    let accent: Color
    let content: Content

    init(accent: Color, @ViewBuilder content: () -> Content) {
        self.accent = accent
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            Color(red: 0.065, green: 0.085, blue: 0.075),
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(accent.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct JRInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title).foregroundColor(.gray)
            Spacer(minLength: 8)
            Text(value)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private struct JRActionButton: View {
    let title: String
    let symbol: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(15)
                .foregroundColor(.black)
                .background(accent, in: RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main screen

struct ContentView: View {
    @AppStorage("selectedTheme") private var selectedTheme = "green"
    @AppStorage("animationsEnabled") private var animationsEnabled = true

    @State private var pulsing = false
    @State private var showSettings = false
    @State private var showBootstrap = false
    @State private var deviceChecked = false

    private var accent: Color {
        JailRa1nTheme(rawValue: selectedTheme)?.color ?? .green
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 22) {
                    header
                    logo
                    titleSection
                    deviceCard
                    engineCard
                    JRActionButton(
                        title: "Bootstrap Manager",
                        symbol: "shippingbox.fill",
                        accent: accent
                    ) {
                        showBootstrap = true
                    }
                    deviceCheckCard
                    footer
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSettings) {
            settingsView
        }
        .sheet(isPresented: $showBootstrap) {
            NavigationStack {
                BootstrapView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { showBootstrap = false }
                                .tint(accent)
                        }
                    }
            }
        }
        .onAppear { pulsing = true }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JailRa1n").font(.headline).foregroundColor(.white)
                Text("Version 0.5").font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Button { showSettings = true } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(accent)
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.08), in: Circle())
            }
            .accessibilityLabel("Settings")
        }
    }

    private var logo: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.18))
                .frame(width: 180, height: 180)
                .blur(radius: 30)
            Circle()
                .stroke(accent.opacity(0.3), lineWidth: 2)
                .frame(width: 180, height: 180)
            Image(systemName: "drop.fill")
                .font(.system(size: 135))
                .foregroundColor(accent)
                .shadow(color: accent.opacity(0.8), radius: 25)
        }
        .frame(height: 210)
        .scaleEffect(animationsEnabled && pulsing ? 1.05 : 0.95)
        .animation(
            animationsEnabled
                ? .easeInOut(duration: 1.8).repeatForever(autoreverses: true)
                : .none,
            value: pulsing
        )
        .onChange(of: animationsEnabled) { enabled in
            pulsing = false
            if enabled {
                DispatchQueue.main.async { pulsing = true }
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("JailRa1n")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(accent)
            Text("Sileo Installer Edition")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("INTERFACE PREVIEW 0.5")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(accent)
        }
    }

    private var deviceCard: some View {
        JRCard(accent: accent) {
            Label("Device Information", systemImage: "iphone")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Device Name", value: JailRa1nDevice.name)
            JRInfoRow(title: "iPhone Model", value: JailRa1nDevice.identifier)
            JRInfoRow(title: "iOS Version", value: JailRa1nDevice.iosVersion)
            JRInfoRow(title: "Jailbreak", value: "Not Verified")
        }
    }

    private var engineCard: some View {
        JRCard(accent: accent) {
            Label("Jailbreak Engine", systemImage: "cpu")
                .font(.headline).foregroundColor(accent)
            Divider()
            Label("Unavailable", systemImage: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
            Text("No jailbreak or bootstrap engine is included.")
                .font(.subheadline).foregroundColor(.gray)
        }
    }

    private var deviceCheckCard: some View {
        VStack(spacing: 10) {
            JRActionButton(
                title: "Check Device",
                symbol: "checkmark.shield.fill",
                accent: accent
            ) {
                deviceChecked = true
            }
            if deviceChecked {
                Text("Device identified. No bootstrap engine is configured.")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 5) {
            Text("JailRa1n • Version 0.5").foregroundColor(accent)
            Text("Sileo Installer Preview • No Exploit")
                .foregroundColor(.gray)
        }
        .font(.caption)
    }

    private var settingsView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 75))
                        .foregroundColor(accent)
                        .padding(.top, 20)
                    Text("Customize JailRa1n")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 12
                    ) {
                        ForEach(JailRa1nTheme.allCases) { theme in
                            Button {
                                selectedTheme = theme.rawValue
                            } label: {
                                VStack(spacing: 10) {
                                    Circle()
                                        .fill(theme.color)
                                        .frame(width: 42, height: 42)
                                    Text(theme.name)
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                    Image(systemName:
                                        selectedTheme == theme.rawValue
                                        ? "checkmark.circle.fill" : "circle"
                                    )
                                    .foregroundColor(theme.color)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(18)
                                .background(
                                    Color.white.opacity(0.07),
                                    in: RoundedRectangle(cornerRadius: 18)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Toggle("Neon Animations", isOn: $animationsEnabled)
                        .tint(accent)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Color.white.opacity(0.07),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                }
                .padding(20)
            }
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showSettings = false }
                        .tint(accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Bootstrap and Sileo manager

struct BootstrapView: View {
    @AppStorage("selectedTheme") private var selectedTheme = "green"

    @State private var sileoChecked = false
    @State private var sileoDetected = false
    @State private var compatibilityChecked = false
    @State private var installerChecked = false
    @State private var logs: [String] = [
        "[INFO] JailRa1n 0.5 initialized",
        "[INFO] App sandbox available",
        "[WARN] No bootstrap engine configured"
    ]

    private var accent: Color {
        JailRa1nTheme(rawValue: selectedTheme)?.color ?? .green
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 75))
                    .foregroundColor(accent)
                    .shadow(color: accent.opacity(0.7), radius: 20)
                    .padding(.top, 20)
                Text("Bootstrap Manager")
                    .font(.title.bold())
                    .foregroundColor(accent)
                Text("JailRa1n 0.5 • Sileo Installer")
                    .font(.caption)
                    .foregroundColor(.gray)
                statusCard
                compatibilityCard
                sileoCard
                installerCard
                logsCard
            }
            .padding(20)
        }
        .background(Color.black)
        .navigationTitle("Bootstrap")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var statusCard: some View {
        JRCard(accent: accent) {
            Label("Bootstrap Status", systemImage: "cube.box.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Bootstrap", value: "Not Installed")
            JRInfoRow(title: "Engine", value: "Unavailable")
            JRInfoRow(title: "Environment", value: "App Sandbox")
            JRInfoRow(title: "System Access", value: "Not Available")
        }
    }

    private var compatibilityCard: some View {
        JRCard(accent: accent) {
            Label("Compatibility Check", systemImage: "checkmark.shield.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Device", value: JailRa1nDevice.identifier)
            JRInfoRow(title: "iOS Version", value: JailRa1nDevice.iosVersion)
            if compatibilityChecked {
                Text("No supported bootstrap engine is configured.")
                    .font(.caption).foregroundColor(.orange)
            }
            JRActionButton(
                title: "Check Compatibility",
                symbol: "magnifyingglass",
                accent: accent
            ) {
                compatibilityChecked = true
                logs.append("[INFO] Device: \(JailRa1nDevice.identifier)")
                logs.append("[INFO] iOS: \(JailRa1nDevice.iosVersion)")
                logs.append("[WARN] No supported bootstrap engine")
            }
        }
    }

    private var sileoCard: some View {
        JRCard(accent: accent) {
            Label("Sileo Detection", systemImage: "magnifyingglass")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(
                title: "Sileo Status",
                value: sileoChecked
                    ? (sileoDetected ? "Detected" : "Not Detected")
                    : "Not Checked"
            )
            JRActionButton(
                title: "Detect Sileo",
                symbol: "checkmark.shield",
                accent: accent
            ) {
                detectSileo()
            }
            if sileoDetected {
                Button {
                    if let url = URL(string: "sileo://") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label("Open Sileo", systemImage: "arrow.up.right.square")
                        .foregroundColor(accent)
                }
            }
            Text("Checks whether iOS can open the Sileo URL scheme. This does not verify a working bootstrap.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var installerCard: some View {
        JRCard(accent: accent) {
            Label("Sileo Installer Manager", systemImage: "square.and.arrow.down.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Installer Status", value: "Unavailable")
            JRInfoRow(title: "Bootstrap Engine", value: "Not Configured")
            JRInfoRow(title: "System Permissions", value: "Unavailable")
            if installerChecked {
                Label(
                    "Installation blocked: no compatible bootstrap engine.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.caption)
                .foregroundColor(.orange)
            }
            JRActionButton(
                title: "Check Installation Requirements",
                symbol: "shield.lefthalf.filled",
                accent: accent
            ) {
                runInstallerCheck()
            }
            Label("Install Sileo", systemImage: "lock.fill")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Color.white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 15)
                )
            Text("Installation is disabled: no compatible bootstrap is integrated.")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var logsCard: some View {
        JRCard(accent: accent) {
            Label("Installation Logs", systemImage: "terminal")
                .font(.headline).foregroundColor(accent)
            Divider()
            ForEach(logs.indices, id: \.self) { index in
                Text(logs[index])
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(
                        logs[index].contains("[WARN]") ? .orange : accent
                    )
            }
            Button("Clear Logs") { logs.removeAll() }
                .foregroundColor(accent)
        }
    }

    private func detectSileo() {
        guard let url = URL(string: "sileo://") else { return }
        sileoChecked = true
        sileoDetected = UIApplication.shared.canOpenURL(url)
        logs.append(
            sileoDetected
                ? "[INFO] Sileo URL scheme detected"
                : "[WARN] Sileo URL scheme not detected"
        )
    }

    private func runInstallerCheck() {
        installerChecked = true
        logs.append("[INFO] Checking Sileo installation requirements")
        logs.append("[INFO] Device: \(JailRa1nDevice.identifier)")
        logs.append("[INFO] iOS: \(JailRa1nDevice.iosVersion)")
        logs.append("[WARN] Bootstrap engine unavailable")
        logs.append("[WARN] Installation safely blocked")
    }
}
