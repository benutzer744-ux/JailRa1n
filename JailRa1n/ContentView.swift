
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

// MARK: - Main View

struct ContentView: View {

    @AppStorage("selectedTheme")
    private var selectedTheme = "green"

    @AppStorage("animationsEnabled")
    private var animationsEnabled = true

    @State private var pulsing = false
    @State private var showSettings = false
    @State private var checking = false
    @State private var checkCompleted = false

    private var theme: JailRa1nTheme {
        JailRa1nTheme(rawValue: selectedTheme) ?? .green
    }

    private var accent: Color {
        theme.color
    }

    private let background = Color.black
    private let cardBackground = Color(
        red: 0.065,
        green: 0.085,
        blue: 0.075
    )

    var body: some View {
        ZStack {
            background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header
                    logo
                    titleSection
                    deviceCard
                    engineCard
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
        .onAppear {
            pulsing = true
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JailRa1n")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Version 0.2")
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

    // MARK: - Animated Logo

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

    // MARK: - Title

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("JailRa1n")
                .font(.system(
                    size: 42,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(accent)

            Text("Custom Themes Edition")
                .font(.subheadline)
                .foregroundStyle(.gray)

            HStack(spacing: 7) {
                Circle()
                    .fill(accent)
                    .frame(width: 7, height: 7)

                Text("INTERFACE PREVIEW 0.2")
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

    // MARK: - Device Information

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

            infoRow(
                "Device Name",
                UIDevice.current.name
            )

            infoRow(
                "iPhone Model",
                deviceIdentifier
            )

            infoRow(
                "iOS Version",
                UIDevice.current.systemVersion
            )

            infoRow(
                "Target iOS",
                UIDevice.current.systemVersion
            )

            infoRow(
                "Jailbreak",
                "Not Checked"
            )
        }
        .padding(20)
        .background(
            cardBackground,
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(accent.opacity(0.16))
        )
    }

    private func infoRow(
        _ label: String,
        _ value: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .foregroundStyle(.gray)

            Spacer(minLength: 0)

            Text(value)
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private var deviceIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let bytes = Mirror(
            reflecting: systemInfo.machine
        ).children.compactMap { $0.value as? Int8 }

        let identifier = bytes
            .prefix(while: { $0 != 0 })
            .map { UInt8(bitPattern: $0) }

        return String(
            bytes: identifier,
            encoding: .utf8
        ) ?? UIDevice.current.model
    }

    // MARK: - Jailbreak Engine

    private var engineCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label(
                    "Jailbreak Engine",
                    systemImage: "cpu"
                )
                .font(.headline)
                .foregroundStyle(accent)

                Spacer()
            }

            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.orange)

                Text("Unavailable")
                    .font(.subheadline.bold())
                    .foregroundStyle(.orange)
            }

            Text(
                "No jailbreak engine is included in this preview."
            )
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            cardBackground,
            in: RoundedRectangle(cornerRadius: 24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(accent.opacity(0.16))
        )
    }

    // MARK: - Device Check

    private var checkButton: some View {
        VStack(spacing: 12) {
            Button {
                runDeviceCheck()
            } label: {
                HStack(spacing: 10) {
                    if checking {
                        ProgressView()
                            .tint(.black)
                    } else {
                        Image(systemName: "checkmark.shield.fill")
                    }

                    Text(
                        checking
                        ? "Checking Device..."
                        : "Check Device"
                    )
                }
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    accent,
                    in: RoundedRectangle(cornerRadius: 20)
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

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 6) {
            Text("JailRa1n • Version 0.2")
                .foregroundStyle(accent)

            Text("Interface Concept • No Jailbreak Engine")
                .foregroundStyle(.gray)
        }
        .font(.caption2)
    }

    // MARK: - Settings

    private var settingsView: some View {
        NavigationStack {
            ZStack {
                background.ignoresSafeArea()

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
                            isOn: $animationsEnabled
                        ) {
                            Label(
                                "Neon Animations",
                                systemImage: "sparkles"
                            )
                            .foregroundStyle(.white)
                        }
                        .tint(accent)
                        .padding(18)
                        .background(
                            cardBackground,
                            in: RoundedRectangle(cornerRadius: 18)
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Text("ABOUT")
                                .font(.caption.bold())
                                .tracking(2)
                                .foregroundStyle(.gray)

                            Text("JailRa1n 0.2")
                                .foregroundStyle(.white)

                            Text(
                                "Interface preview only. No jailbreak functionality is included."
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
                            cardBackground,
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showSettings = false
                    }
                    .foregroundStyle(accent)
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
                cardBackground,
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
}
