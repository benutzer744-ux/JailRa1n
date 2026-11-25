
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
        case .green:
            return Color(red: 0.49, green: 1, blue: 0)
        case .blue:
            return Color(red: 0, green: 0.75, blue: 1)
        case .purple:
            return Color(red: 0.70, green: 0.30, blue: 1)
        case .pink:
            return Color(red: 1, green: 0.24, blue: 0.60)
        case .red:
            return Color(red: 1, green: 0.27, blue: 0.27)
        case .white:
            return Color(red: 0.94, green: 0.96, blue: 0.98)
        }
    }
}

// MARK: - Device

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

        let bytes = Mirror(reflecting: info.machine)
            .children
            .compactMap { $0.value as? Int8 }

        let result = bytes
            .prefix(while: { $0 != 0 })
            .map { UInt8(bitPattern: $0) }

        return String(
            bytes: result,
            encoding: .utf8
        ) ?? UIDevice.current.model
    }
}

// MARK: - Main Screen

struct ContentView: View {

    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

    @AppStorage("animationsEnabled")
    private var animationsEnabled = true

    @State private var pulsing = false
    @State private var showSettings = false
    @State private var showBootstrap = false
    @State private var checking = false
    @State private var checkCompleted = false

    private var accent: Color {
        JailRa1nTheme(rawValue: selectedTheme)?.color ?? .green
    }

    private let cardColor = Color(
        red: 0.065,
        green: 0.085,
        blue: 0.075
    )

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 23) {
                    header
                    logo
                    titleSection
                    deviceCard
                    engineCard
                    bootstrapButton
                    checkButton
                    footer
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 30)
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
                        ToolbarItem(
                            placement: .navigationBarTrailing
                        ) {
                            Button("Done") {
                                showBootstrap = false
                            }
                            .tint(accent)
                        }
                    }
            }
        }
        .onAppear {
            pulsing = true
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JailRa1n")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Version 0.4")
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
                    .frame(width: 46, height: 46)
                    .background(
                        Color.white.opacity(0.08),
                        in: Circle()
                    )
            }
            .accessibilityLabel("Settings")
        }
    }

    private var logo: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.16))
                .frame(width: 180, height: 180)
                .blur(radius: 35)

            Circle()
                .stroke(accent.opacity(0.25), lineWidth: 2)
                .frame(width: 175, height: 175)

            Image(systemName: "drop.fill")
                .font(.system(size: 140))
                .foregroundStyle(accent)
                .shadow(
                    color: accent.opacity(0.8),
                    radius: 25
                )
        }
        .frame(height: 210)
        .scaleEffect(
            animationsEnabled && pulsing ? 1.06 : 0.94
        )
        .animation(
            animationsEnabled
                ? .easeInOut(duration: 1.8)
                    .repeatForever(autoreverses: true)
                : .none,
            value: pulsing
        )
        .onChange(of: animationsEnabled) { enabled in
            pulsing = false

            if enabled {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.05
                ) {
                    pulsing = true
                }
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("JailRa1n")
                .font(.system(
                    size: 42,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(accent)

            Text("Sileo Detection Edition")
                .font(.subheadline)
                .foregroundStyle(.gray)

            HStack(spacing: 7) {
                Circle()
                    .fill(accent)
                    .frame(width: 7, height: 7)

                Text("INTERFACE PREVIEW 0.4")
                    .font(.system(
                        size: 10,
                        weight: .semibold,
                        design: .monospaced
                    ))
                    .tracking(2)
                    .foregroundStyle(accent)
            }
            .padding(.top, 5)
        }
    }

    private var deviceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                "Device Information",
                systemImage: "iphone"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()
                .overlay(accent.opacity(0.2))

            infoRow("Device Name", JailRa1nDevice.name)
            infoRow("iPhone Model", JailRa1nDevice.identifier)
            infoRow("iOS Version", JailRa1nDevice.iosVersion)
            infoRow("Jailbreak", "Not Checked")
        }
        .jailRa1nCard(cardColor, accent)
    }

    private var engineCard: some View {
        VStack(alignment: .leading, spacing: 14) {
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
            .font(.subheadline.bold())
            .foregroundStyle(.orange)

            Text(
                "No jailbreak engine is included in this preview."
            )
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .jailRa1nCard(cardColor, accent)
    }

    private var bootstrapButton: some View {
        Button {
            showBootstrap = true
        } label: {
            HStack(spacing: 12) {
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

    private var checkButton: some View {
        VStack(spacing: 12) {
            Button {
                runDeviceCheck()
            } label: {
                HStack(spacing: 10) {
                    if checking {
                        ProgressView()
                            .tint(accent)
                    } else {
                        Image(
                            systemName: "checkmark.shield.fill"
                        )
                    }

                    Text(
                        checking
                        ? "Checking Device..."
                        : "Check Device"
                    )
                }
                .font(.headline)
                .foregroundStyle(accent)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    cardColor,
                    in: RoundedRectangle(cornerRadius: 20)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(accent.opacity(0.4))
                )
            }
            .disabled(checking)

            if checkCompleted {
                Text(
                    "Device information loaded. Jailbreak engine unavailable."
                )
                .font(.caption)
                .foregroundStyle(.orange)
                .multilineTextAlignment(.center)
            }
        }
    }

    private func runDeviceCheck() {
        guard !checking else { return }

        checking = true
        checkCompleted = false

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.5
        ) {
            checking = false
            checkCompleted = true
        }
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Text("JailRa1n • Version 0.4")
                .foregroundStyle(accent)

            Text("Sileo Detection • No Exploit Included")
                .foregroundStyle(.gray)
        }
        .font(.caption2)
    }

    private var settingsView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 10) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 75))
                            .foregroundStyle(accent)
                            .shadow(
                                color: accent.opacity(0.7),
                                radius: 20
                            )

                        Text("Customize JailRa1n")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("Choose your neon style")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                    Text("COLOR THEMES")
                        .font(.caption.bold())
                        .tracking(2)
                        .foregroundStyle(.gray)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 12
                    ) {
                        ForEach(JailRa1nTheme.allCases) { item in
                            themeButton(item)
                        }
                    }

                    Text("ANIMATIONS")
                        .font(.caption.bold())
                        .tracking(2)
                        .foregroundStyle(.gray)

                    Toggle(
                        "Neon Animations",
                        isOn: $animationsEnabled
                    )
                    .tint(accent)
                    .foregroundStyle(.white)
                    .padding(18)
                    .background(
                        cardColor,
                        in: RoundedRectangle(cornerRadius: 18)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ABOUT")
                            .font(.caption.bold())
                            .foregroundStyle(.gray)

                        Text("JailRa1n 0.4")
                            .foregroundStyle(.white)

                        Text(
                            "Sileo detection preview. No jailbreak or bootstrap installation engine is included."
                        )
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(18)
                    .background(
                        cardColor,
                        in: RoundedRectangle(cornerRadius: 18)
                    )
                }
                .padding(20)
            }
            .background(Color.black)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button("Done") {
                        showSettings = false
                    }
                    .tint(accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func themeButton(
        _ item: JailRa1nTheme
    ) -> some View {
        let isSelected = selectedTheme == item.rawValue

        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedTheme = item.rawValue
            }
        } label: {
            VStack(spacing: 12) {
                Circle()
                    .fill(item.color)
                    .frame(width: 42, height: 42)
                    .shadow(
                        color: item.color.opacity(0.5),
                        radius: isSelected ? 14 : 0
                    )

                Text(item.name)
                    .font(.caption.bold())
                    .foregroundStyle(.white)

                Image(
                    systemName: isSelected
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .foregroundStyle(
                    isSelected ? item.color : .gray
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                cardColor,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected
                        ? item.color
                        : Color.white.opacity(0.08),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func infoRow(
        _ title: String,
        _ value: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(title)
                .foregroundStyle(.gray)

            Spacer(minLength: 0)

            Text(value)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

// MARK: - Bootstrap Manager

struct BootstrapView: View {

    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

    @State private var hasChecked = false

    @State private var logs: [String] = [
        "[INFO] Bootstrap Manager initialized",
        "[INFO] App sandbox available",
        "[WARN] No bootstrap engine configured"
    ]

    private var accent: Color {
        JailRa1nTheme(rawValue: selectedTheme)?.color ?? .green
    }

    private let cardColor = Color(
        red: 0.065,
        green: 0.085,
        blue: 0.075
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(accent)
                    .shadow(
                        color: accent.opacity(0.6),
                        radius: 20
                    )
                    .padding(.top, 20)

                Text("Bootstrap Manager")
                    .font(.title.bold())
                    .foregroundStyle(accent)

                Text("JailRa1n 0.4 • Sileo Detection")
                    .font(.caption)
                    .foregroundStyle(.gray)

                bootstrapStatus
                compatibilityCard
                sileoCard
                SileoDetectionView()
                logsCard
            }
            .padding(20)
        }
        .background(Color.black)
        .navigationTitle("Bootstrap")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var bootstrapStatus: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label(
                "Bootstrap Status",
                systemImage: "cube.box.fill"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            infoRow("Bootstrap", "Not Installed")
            infoRow("Engine", "Unavailable")
            infoRow("Environment", "App Sandbox")
            infoRow("System Access", "Not Available")
        }
        .jailRa1nCard(cardColor, accent)
    }

    private var compatibilityCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label(
                "Compatibility Check",
                systemImage: "checkmark.shield.fill"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            infoRow("Device", JailRa1nDevice.identifier)
            infoRow("iOS Version", JailRa1nDevice.iosVersion)

            if hasChecked {
                Label(
                    "No compatible bootstrap engine is configured.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.caption)
                .foregroundStyle(.orange)
            }

            Button {
                checkCompatibility()
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
        .jailRa1nCard(cardColor, accent)
    }

    private var sileoCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label(
                "Sileo Package Manager",
                systemImage: "shippingbox"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            infoRow("Installer", "Unavailable")

            Text(
                "Sileo installation requires a compatible bootstrap and system permissions."
            )
            .font(.footnote)
            .foregroundStyle(.gray)

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

            Text("Installation is disabled in this preview.")
                .font(.caption)
                .foregroundStyle(.orange)
        }
        .jailRa1nCard(cardColor, accent)
    }

    private var logsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(
                "Bootstrap Logs",
                systemImage: "terminal"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            ForEach(logs.indices, id: \.self) { index in
                Text(logs[index])
                    .font(.system(
                        size: 12,
                        design: .monospaced
                    ))
                    .foregroundStyle(
                        logs[index].contains("[WARN]")
                        ? Color.orange
                        : accent
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }

            Button("Clear Logs") {
                logs.removeAll()
            }
            .font(.caption.bold())
            .foregroundStyle(accent)
        }
        .jailRa1nCard(cardColor, accent)
    }

    private func checkCompatibility() {
        hasChecked = true

        logs.append(
            "[INFO] Device: \(JailRa1nDevice.identifier)"
        )

        logs.append(
            "[INFO] iOS: \(JailRa1nDevice.iosVersion)"
        )

        logs.append(
            "[WARN] No bootstrap engine configured"
        )
    }

    private func infoRow(
        _ title: String,
        _ value: String
    ) -> some View {
        HStack(alignment: .top, spacing: 10) {
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

// MARK: - Sileo Detection

struct SileoDetectionView: View {

    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

    @State private var sileoDetected = false
    @State private var hasChecked = false

    private var accent: Color {
        JailRa1nTheme(rawValue: selectedTheme)?.color ?? .green
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Sileo Detection",
                systemImage: "magnifyingglass"
            )
            .font(.headline)
            .foregroundStyle(accent)

            Divider()

            HStack {
                Text("Sileo Status")
                    .foregroundStyle(.gray)

                Spacer()

                Text(
                    hasChecked
                    ? (sileoDetected ? "Detected" : "Not Detected")
                    : "Not Checked"
                )
                .foregroundStyle(
                    sileoDetected ? .green : .orange
                )
            }

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
                    guard let url = URL(
                        string: "sileo://"
                    ) else {
                        return
                    }

                    UIApplication.shared.open(url)
                } label: {
                    Label(
                        "Open Sileo",
                        systemImage: "arrow.up.right.square"
                    )
                    .frame(maxWidth: .infinity)
                    .padding(15)
                }
                .foregroundStyle(accent)
            }

            Text(
                "Checks whether the Sileo URL scheme is available. Does not verify jailbreak access."
            )
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .padding(20)
        .background(
            Color(
                red: 0.065,
                green: 0.085,
                blue: 0.075
            ),
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(accent.opacity(0.16))
        )
    }

    private func detectSileo() {
        guard let url = URL(
            string: "sileo://"
        ) else {
            return
        }

        hasChecked = true
        sileoDetected = UIApplication.shared.canOpenURL(url)
    }
}

// MARK: - Shared Card Style

private struct JailRa1nCardModifier: ViewModifier {
    let backgroundColor: Color
    let accentColor: Color

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(20)
            .background(
                backgroundColor,
                in: RoundedRectangle(cornerRadius: 24)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(accentColor.opacity(0.16))
            )
    }
}

private extension View {
    func jailRa1nCard(
        _ background: Color,
        _ accent: Color
    ) -> some View {
        modifier(
            JailRa1nCardModifier(
                backgroundColor: background,
                accentColor: accent
            )
        )
    }
}
