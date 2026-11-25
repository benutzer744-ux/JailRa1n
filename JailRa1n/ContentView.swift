
import SwiftUI
import UIKit

// MARK: - Themes

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

// MARK: - Device Information

enum JailRa1nDevice {
    static var name: String {
        UIDevice.current.name
    }

    static var iosVersion: String {
        UIDevice.current.systemVersion
    }

    static var identifier: String {
        var info = utsname()
        uname(&info)

        return withUnsafePointer(to: &info.machine) {
            $0.withMemoryRebound(
                to: CChar.self,
                capacity: MemoryLayout.size(
                    ofValue: info.machine
                )
            ) {
                String(cString: $0)
            }
        }
    }
}

// MARK: - Shared Card

struct JailRa1nCard<Content: View>: View {
    let accent: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            Color(red: 0.065, green: 0.085, blue: 0.075),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(accent.opacity(0.18))
        )
    }
}

struct JailRa1nInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .foregroundStyle(.gray)

            Spacer(minLength: 8)

            Text(value)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

// MARK: - Main View

struct ContentView: View {
    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

    @AppStorage("animationsEnabled")
    private var animationsEnabled = true

    @State private var pulse = false
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
                VStack(spacing: 24) {
                    header
                    logo
                    titleSection
                    deviceCard
                    engineCard
                    bootstrapButton
                    deviceCheckButton
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
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showBootstrap = false
                            }
                            .tint(accent)
                        }
                    }
            }
        }
        .onAppear {
            pulse = true
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JailRa1n")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Version 0.5")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundStyle(accent)
                    .frame(width: 48, height: 48)
                    .background(
                        Color.white.opacity(0.08),
                        in: Circle()
                    )
            }
        }
    }

    private var logo: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.18))
                .frame(width: 180, height: 180)
                .blur(radius: 30)

            Circle()
                .stroke(accent.opacity(0.30), lineWidth: 2)
                .frame(width: 180, height: 180)

            Image(systemName: "drop.fill")
                .font(.system(size: 135))
                .foregroundStyle(accent)
                .shadow(
                    color: accent.opacity(0.8),
                    radius: 25
                )
        }
        .frame(height: 210)
        .scaleEffect(
            animationsEnabled && pulse ? 1.05 : 0.95
        )
        .animation(
            animationsEnabled
                ? .easeInOut(duration: 1.8)
                    .repeatForever(autoreverses: true)
                : .none,
            value: pulse
        )
    }

    private var titleSection: some View {
        VStack(spacing: 10) {
            Text("JailRa1n")
                .font(.system(
                    size: 44,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(accent)

            Text("Sileo Installer Edition")
                .font(.subheadline)
                .foregroundStyle(.gray)

            Text("INTERFACE PREVIEW 0.5")
                .font(.system(
                    size: 11,
                    weight: .semibold,
                    design: .monospaced
                ))
                .tracking(2)
                .foregroundStyle(accent)
        }
    }

    private var deviceCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Device Information",
                systemImage: "iphone"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            JailRa1nInfoRow(
                title: "Device Name",
                value: JailRa1nDevice.name
            )

            JailRa1nInfoRow(
                title: "iPhone Model",
                value: JailRa1nDevice.identifier
            )

            JailRa1nInfoRow(
                title: "iOS Version",
                value: JailRa1nDevice.iosVersion
            )

            JailRa1nInfoRow(
                title: "Jailbreak",
                value: "Not Verified"
            )
        }
    }

    private var engineCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Jailbreak Engine",
                systemImage: "cpu"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            Label(
                "Unavailable",
                systemImage: "exclamationmark.circle.fill"
            )
            .foregroundStyle(.orange)

            Text(
                "No jailbreak or bootstrap engine is included."
            )
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
    }

    private var bootstrapButton: some View {
        Button {
            showBootstrap = true
        } label: {
            HStack {
                Image(systemName: "shippingbox.fill")

                Text("Bootstrap Manager")
                    .fontWeight(.bold)

                Spacer()

                Image(systemName: "chevron.right")
            }
            .font(.headline)
            .foregroundStyle(.black)
            .padding(18)
            .background(
                accent,
                in: RoundedRectangle(cornerRadius: 20)
            )
        }
    }

    private var deviceCheckButton: some View {
        VStack(spacing: 10) {
            Button {
                deviceChecked = true
            } label: {
                Label(
                    "Check Device",
                    systemImage: "checkmark.shield.fill"
                )
                .font(.headline)
                .foregroundStyle(accent)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    Color.white.opacity(0.06),
                    in: RoundedRectangle(cornerRadius: 20)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(accent.opacity(0.35))
                )
            }

            if deviceChecked {
                Text(
                    "Device identified. No compatible bootstrap engine is configured."
                )
                .font(.caption)
                .foregroundStyle(.orange)
                .multilineTextAlignment(.center)
            }
        }
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Text("JailRa1n • Version 0.5")
                .foregroundStyle(accent)

            Text("Sileo Installer Preview • No Exploit")
                .foregroundStyle(.gray)
        }
        .font(.caption)
    }

    private var settingsView: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 75))
                        .foregroundStyle(accent)
                        .padding(.top, 20)

                    Text("Customize JailRa1n")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
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
                                        .foregroundStyle(.white)

                                    Image(
                                        systemName:
                                            selectedTheme == theme.rawValue
                                            ? "checkmark.circle.fill"
                                            : "circle"
                                    )
                                    .foregroundStyle(theme.color)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(18)
                                .background(
                                    Color.white.opacity(0.07),
                                    in: RoundedRectangle(
                                        cornerRadius: 18
                                    )
                                )
                            }
                        }
                    }

                    Toggle(
                        "Neon Animations",
                        isOn: $animationsEnabled
                    )
                    .tint(accent)
                    .foregroundStyle(.white)
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showSettings = false
                    }
                    .tint(accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Bootstrap Manager

struct BootstrapView: View {
    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

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
            VStack(spacing: 22) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 75))
                    .foregroundStyle(accent)
                    .shadow(
                        color: accent.opacity(0.7),
                        radius: 20
                    )
                    .padding(.top, 20)

                Text("Bootstrap Manager")
                    .font(.title.bold())
                    .foregroundStyle(accent)

                Text("JailRa1n 0.5 • Sileo Installer")
                    .font(.caption)
                    .foregroundStyle(.gray)

                statusCard
                compatibilityCard
                sileoDetectionCard
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
        JailRa1nCard(accent: accent) {
            Label(
                "Bootstrap Status",
                systemImage: "cube.box.fill"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            JailRa1nInfoRow(
                title: "Bootstrap",
                value: "Not Installed"
            )

            JailRa1nInfoRow(
                title: "Engine",
                value: "Unavailable"
            )

            JailRa1nInfoRow(
                title: "Environment",
                value: "App Sandbox"
            )

            JailRa1nInfoRow(
                title: "System Access",
                value: "Not Available"
            )
        }
    }

    private var compatibilityCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Compatibility Check",
                systemImage: "checkmark.shield.fill"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            JailRa1nInfoRow(
                title: "Device",
                value: JailRa1nDevice.identifier
            )

            JailRa1nInfoRow(
                title: "iOS Version",
                value: JailRa1nDevice.iosVersion
            )

            if compatibilityChecked {
                Text(
                    "No supported bootstrap engine is configured."
                )
                .font(.caption)
                .foregroundStyle(.orange)
            }

            Button {
                compatibilityChecked = true

                logs.append(
                    "[INFO] Device: \(JailRa1nDevice.identifier)"
                )
                logs.append(
                    "[INFO] iOS: \(JailRa1nDevice.iosVersion)"
                )
                logs.append(
                    "[WARN] No supported bootstrap engine"
                )
            } label: {
                Label(
                    "Check Compatibility",
                    systemImage: "magnifyingglass"
                )
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    accent,
                    in: RoundedRectangle(cornerRadius: 15)
                )
            }
        }
    }

    private var sileoDetectionCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Sileo Detection",
                systemImage: "magnifyingglass"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            JailRa1nInfoRow(
                title: "Sileo Status",
                value: sileoChecked
                    ? (sileoDetected ? "Detected" : "Not Detected")
                    : "Not Checked"
            )

            Button {
                detectSileo()
            } label: {
                Label(
                    "Detect Sileo",
                    systemImage: "checkmark.shield"
                )
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    accent,
                    in: RoundedRectangle(cornerRadius: 15)
                )
            }

            if sileoDetected {
                Button {
                    if let url = URL(string: "sileo://") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label(
                        "Open Sileo",
                        systemImage: "arrow.up.right.square"
                    )
                    .foregroundStyle(accent)
                }
            }

            Text(
                "Checks whether iOS can open the Sileo URL scheme."
            )
            .font(.caption)
            .foregroundStyle(.gray)
        }
    }

    private var installerCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Sileo Installer Manager",
                systemImage: "square.and.arrow.down.fill"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            JailRa1nInfoRow(
                title: "Installer Status",
                value: "Unavailable"
            )

            JailRa1nInfoRow(
                title: "Bootstrap Engine",
                value: "Not Configured"
            )

            JailRa1nInfoRow(
                title: "System Permissions",
                value: "Unavailable"
            )

            if installerChecked {
                Label(
                    "Installation blocked: no compatible bootstrap engine.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.caption)
                .foregroundStyle(.orange)
            }

            Button {
                runInstallerCheck()
            } label: {
                Label(
                    "Check Installation Requirements",
                    systemImage: "shield.lefthalf.filled"
                )
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    accent,
                    in: RoundedRectangle(cornerRadius: 15)
                )
            }

            Label(
                "Install Sileo",
                systemImage: "lock.fill"
            )
            .font(.headline)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity)
            .padding(15)
            .background(
                Color.white.opacity(0.08),
                in: RoundedRectangle(cornerRadius: 15)
            )

            Text(
                "Installation remains disabled until a compatible bootstrap is available."
            )
            .font(.caption)
            .foregroundStyle(.gray)
        }
    }

    private var logsCard: some View {
        JailRa1nCard(accent: accent) {
            Label(
                "Installation Logs",
                systemImage: "terminal"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            ForEach(logs.indices, id: \.self) { index in
                Text(logs[index])
                    .font(.system(
                        size: 11,
                        design: .monospaced
                    ))
                    .foregroundStyle(
                        logs[index].contains("[WARN]")
                        ? Color.orange
                        : accent
                    )
            }

            Button("Clear Logs") {
                logs.removeAll()
            }
            .foregroundStyle(accent)
        }
    }

    private func detectSileo() {
        guard let url = URL(string: "sileo://") else {
            return
        }

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

        logs.append(
            "[INFO] Checking Sileo installation requirements"
        )
        logs.append(
            "[INFO] Device: \(JailRa1nDevice.identifier)"
        )
        logs.append(
            "[INFO] iOS: \(JailRa1nDevice.iosVersion)"
        )
        logs.append(
            "[WARN] Bootstrap engine unavailable"
        )
        logs.append(
            "[WARN] Installation safely blocked"
        )
    }
}
