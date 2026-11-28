import SwiftUI
import UIKit
import Darwin

// JailRa1n 2.1: read-only UI. No jailbreak exploit or bootstrap installer included.
struct ContentView: View {
    @AppStorage("jrAccentColor") private var accentName = "green"
    @AppStorage("jrLanguage") private var language = "de"

    @State private var deviceID = "..."
    @State private var osVersion = UIDevice.current.systemVersion
    @State private var terminalLines: [String] = []
    @State private var shownLines = 0
    @State private var animationToken = UUID()
    @State private var showDiagnostics = false
    @State private var showBootstrap = false
    @State private var showSettings = false
    @State private var showDevice = false

    private let panel = Color(red: 0.055, green: 0.085, blue: 0.065)

    private var neon: Color {
        switch accentName {
        case "blue": return Color(red: 0, green: 0.75, blue: 1)
        case "purple": return Color(red: 0.72, green: 0.42, blue: 1)
        case "red": return Color(red: 1, green: 0.28, blue: 0.28)
        case "pink": return Color(red: 1, green: 0.36, blue: 0.68)
        default: return Color(red: 0.50, green: 1, blue: 0)
        }
    }

    // German is the fallback language.
    private func tr(_ de: String, _ en: String, _ es: String) -> String {
        switch language {
        case "en": return en
        case "es": return es
        default: return de
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 7) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 43, weight: .bold))
                    Text("JailRa1n")
                        .font(.system(size: 37, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    Text("VERSION 2.1 · JAILBREAK CONTROL CENTER")
                        .font(.system(size: 10, design: .monospaced))
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(neon)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)

                VStack(spacing: 14) {
                    infoRow(tr("Gerät", "Device", "Dispositivo"), deviceID)
                    infoRow(tr("iOS-Version", "iOS version", "Versión de iOS"), osVersion)
                    infoRow(tr("App-Status", "App status", "Estado de app"), tr("Bereit", "Ready", "Lista"), highlight: neon)
                    infoRow(tr("Jailbreak-Engine", "Jailbreak engine", "Motor de jailbreak"), tr("Nicht verbunden", "Not connected", "Sin conexión"), highlight: .orange)
                }
                .padding(18)
                .background(panel, in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(neon.opacity(0.30)))

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(tr("LIVE-TERMINAL", "LIVE TERMINAL", "TERMINAL EN VIVO"), systemImage: "terminal")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                        Spacer()
                        Image(systemName: "waveform.path.ecg")
                    }
                    Rectangle().fill(neon.opacity(0.3)).frame(height: 1)
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(0..<min(shownLines, terminalLines.count), id: \.self) { index in
                            Text(terminalLines[index])
                                .font(.system(size: 11, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("> _").font(.system(size: 11, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, minHeight: 174, alignment: .topLeading)
                }
                .foregroundStyle(neon)
                .padding(16)
                .background(Color(red: 0.01, green: 0.025, blue: 0.01), in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(neon.opacity(0.3)))

                VStack(spacing: 5) {
                    Label(tr("JAILBREAK STARTEN", "START JAILBREAK", "INICIAR JAILBREAK"), systemImage: "lock.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text(tr("Deaktiviert – keine Engine integriert", "Disabled – no engine integrated", "Desactivado – sin motor integrado"))
                        .font(.system(size: 11))
                }
                .foregroundStyle(.white.opacity(0.75))
                .frame(maxWidth: .infinity)
                .padding(17)
                .background(Color(white: 0.16), in: RoundedRectangle(cornerRadius: 16))
                .accessibilityLabel(tr("Jailbreak deaktiviert", "Jailbreak disabled", "Jailbreak desactivado"))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    actionButton(tr("Gerät prüfen", "Check device", "Verificar"), icon: "checkmark.shield") { showDevice = true }
                    actionButton(tr("Diagnose", "Diagnostics", "Diagnóstico"), icon: "terminal") { showDiagnostics = true }
                    actionButton(tr("Bootstrap", "Bootstrap", "Bootstrap"), icon: "shippingbox") { showBootstrap = true }
                    actionButton(tr("Einstellungen", "Settings", "Ajustes"), icon: "gearshape") { showSettings = true }
                }
                Text("JailRa1n 2.1 · Engine Diagnostics")
                    .font(.caption2)
                    .foregroundStyle(neon.opacity(0.7))
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 8) }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear(perform: refresh)
        .sheet(isPresented: $showSettings) { settingsSheet }
        .sheet(isPresented: $showDiagnostics) { diagnosticSheet }
        .sheet(isPresented: $showDevice) {
            detailSheet(
                title: tr("Gerät prüfen", "Check device", "Verificar dispositivo"),
                message: "\(tr("Gerät", "Device", "Dispositivo")): \(deviceID)\niOS: \(osVersion)\n\n" + tr("Die App liest Geräteinformationen. Jailbreak-Kompatibilität ist nicht bestätigt.", "The app reads device information. Jailbreak compatibility is not confirmed.", "La app lee datos del dispositivo. La compatibilidad con jailbreak no está confirmada."),
                isPresented: $showDevice
            )
        }
        .sheet(isPresented: $showBootstrap) {
            detailSheet(
                title: "Bootstrap",
                message: tr("Kein Bootstrap-Installer integriert. Keine Systemänderungen.", "No bootstrap installer integrated. No system changes.", "No hay instalador de bootstrap integrado. Sin cambios del sistema."),
                isPresented: $showBootstrap
            )
        }
    }

    private func infoRow(_ label: String, _ value: String, highlight: Color = .white) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(label).foregroundStyle(.gray)
            Spacer(minLength: 5)
            Text(value).foregroundStyle(highlight).fontWeight(.medium).multilineTextAlignment(.trailing)
        }
        .font(.system(size: 14))
    }

    private func actionButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.title3)
                Text(title).font(.system(size: 13, weight: .semibold)).multilineTextAlignment(.center)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, minHeight: 74)
            .background(neon, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var settingsSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label(tr("Akzentfarbe", "Accent color", "Color de acento"), systemImage: "paintpalette.fill")
                            .font(.headline).foregroundStyle(neon)
                        HStack(spacing: 12) {
                            colorChoice("green", color: Color(red: 0.50, green: 1, blue: 0))
                            colorChoice("blue", color: Color(red: 0, green: 0.75, blue: 1))
                            colorChoice("purple", color: Color(red: 0.72, green: 0.42, blue: 1))
                            colorChoice("red", color: Color(red: 1, green: 0.28, blue: 0.28))
                            colorChoice("pink", color: Color(red: 1, green: 0.36, blue: 0.68))
                        }
                        .frame(maxWidth: .infinity)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Label(tr("Sprache", "Language", "Idioma"), systemImage: "globe")
                            .font(.headline).foregroundStyle(neon)
                        languageChoice("de", title: "🇩🇪 Deutsch")
                        languageChoice("en", title: "🇬🇧 English")
                        languageChoice("es", title: "🇪🇸 Español")
                    }

                    Divider().overlay(neon.opacity(0.35))
                    Text(tr("Diagnosemodus: Nur Lesen", "Diagnostics mode: Read only", "Modo diagnóstico: Solo lectura"))
                    Text(tr("Native Engine: Nicht verbunden", "Native engine: Not connected", "Motor nativo: Sin conexión"))
                    Text("JailRa1n 2.1")
                }
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.gray)
                .padding(20)
            }
            .background(Color.black)
            .navigationTitle(tr("Einstellungen", "Settings", "Ajustes"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(tr("Fertig", "Done", "Listo")) { showSettings = false }
                        .foregroundStyle(neon)
                }
            }
        }
        .tint(neon)
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private func colorChoice(_ name: String, color: Color) -> some View {
        Button { accentName = name } label: {
            ZStack {
                Circle().fill(color).frame(width: 43, height: 43)
                if accentName == name {
                    Image(systemName: "checkmark").font(.system(size: 17, weight: .bold)).foregroundStyle(.black)
                }
            }
            .padding(3)
            .overlay(Circle().stroke(accentName == name ? Color.white : Color.gray.opacity(0.4), lineWidth: accentName == name ? 2.5 : 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(name)
    }

    private func languageChoice(_ code: String, title: String) -> some View {
        Button { language = code } label: {
            HStack {
                Text(title).foregroundStyle(.white)
                Spacer()
                if language == code { Image(systemName: "checkmark.circle.fill").foregroundStyle(neon) }
            }
            .padding(13)
            .background(panel, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var diagnosticSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(terminalLines.enumerated()), id: \.offset) { _, line in
                        Text(line).font(.system(size: 12, design: .monospaced))
                    }
                    Button(tr("DIAGNOSE NEU STARTEN", "RESTART DIAGNOSTICS", "REINICIAR DIAGNÓSTICO")) { refresh() }
                        .buttonStyle(.borderedProminent)
                        .tint(neon)
                        .foregroundStyle(.black)
                        .padding(.top)
                }
                .foregroundStyle(neon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color.black)
            .navigationTitle(tr("Live-Diagnose 2.1", "Live diagnostics 2.1", "Diagnóstico 2.1"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(tr("Fertig", "Done", "Listo")) { showDiagnostics = false }.foregroundStyle(neon)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func detailSheet(title: String, message: String, isPresented: Binding<Bool>) -> some View {
        NavigationStack {
            ScrollView {
                Text(message)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundStyle(neon)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color.black)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(tr("Fertig", "Done", "Listo")) { isPresented.wrappedValue = false }.foregroundStyle(neon)
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
    }

    private func refresh() {
        var info = utsname()
        uname(&info)
        var machineCopy = info.machine
        deviceID = withUnsafeBytes(of: &machineCopy) { bytes in
            String(decoding: bytes.prefix(while: { $0 != 0 }), as: UTF8.self)
        }
        osVersion = UIDevice.current.systemVersion
        terminalLines = [
            "> BOOTING JAILRA1N 2.1...",
            "[OK] DEVICE: \(deviceID)",
            "[OK] IOS: \(osVersion)",
            "[OK] DIAGNOSTICS ACTIVE",
            "[INFO] DOPAMINE NOT VERIFIED",
            "[WARN] JAILBREAK ENGINE MISSING",
            "[SAFE] NO SYSTEM CHANGES"
        ]
        shownLines = 0
        let token = UUID()
        animationToken = token
        animateNextLine(token: token)
    }

    private func animateNextLine(token: UUID) {
        guard token == animationToken, shownLines < terminalLines.count else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            guard token == animationToken, shownLines < terminalLines.count else { return }
            shownLines += 1
            animateNextLine(token: token)
        }
    }
}
