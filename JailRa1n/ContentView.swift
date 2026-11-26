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


// MARK: - Localized interface strings
private enum JRLanguage {
    static func text(_ key: String, _ lang: String) -> String {
        let translations: [String: [String: String]] = [
            "Settings": ["de":"Einstellungen","fr":"Réglages","es":"Ajustes","it":"Impostazioni"],
            "Done": ["de":"Fertig","fr":"Terminé","es":"Listo","it":"Fine"],
            "Bootstrap Manager": ["de":"Bootstrap-Manager","fr":"Gestionnaire Bootstrap","es":"Gestor Bootstrap","it":"Gestore Bootstrap"],
            "Device Information": ["de":"Geräteinformationen","fr":"Informations appareil","es":"Información del dispositivo","it":"Informazioni dispositivo"],
            "Device Name": ["de":"Gerätename","fr":"Nom de l’appareil","es":"Nombre del dispositivo","it":"Nome dispositivo"],
            "iPhone Model": ["de":"iPhone-Modell","fr":"Modèle iPhone","es":"Modelo de iPhone","it":"Modello iPhone"],
            "iOS Version": ["de":"iOS-Version","fr":"Version iOS","es":"Versión de iOS","it":"Versione iOS"],
            "Jailbreak Engine": ["de":"Jailbreak-Engine","fr":"Moteur Jailbreak","es":"Motor Jailbreak","it":"Motore Jailbreak"],
            "Unavailable": ["de":"Nicht verfügbar","fr":"Indisponible","es":"No disponible","it":"Non disponibile"],
            "Not Verified": ["de":"Nicht überprüft","fr":"Non vérifié","es":"Sin verificar","it":"Non verificato"],
            "Check Device": ["de":"Gerät prüfen","fr":"Vérifier l’appareil","es":"Comprobar dispositivo","it":"Verifica dispositivo"],
            "Customize JailRa1n": ["de":"JailRa1n anpassen","fr":"Personnaliser JailRa1n","es":"Personalizar JailRa1n","it":"Personalizza JailRa1n"],
            "Language / Sprache": ["de":"Sprache","fr":"Langue","es":"Idioma","it":"Lingua"],
            "Power & Animation": ["de":"System & Animation","fr":"Système et animation","es":"Sistema y animación","it":"Sistema e animazione"],
            "Respring – Ultimate Drip Preview": ["de":"Respring – Ultimate-Drip-Vorschau","fr":"Respring – aperçu Ultimate Drip","es":"Respring – vista previa Ultimate Drip","it":"Respring – anteprima Ultimate Drip"],
            "Reboot – Unavailable": ["de":"Neustart – nicht verfügbar","fr":"Redémarrage indisponible","es":"Reinicio no disponible","it":"Riavvio non disponibile"],
            "Restart JailRa1n UI": ["de":"JailRa1n-Oberfläche neu laden","fr":"Relancer l’interface JailRa1n","es":"Reiniciar interfaz JailRa1n","it":"Riavvia interfaccia JailRa1n"],
            "System Logs": ["de":"Systemprotokoll","fr":"Journal système","es":"Registros del sistema","it":"Log di sistema"],
            "Neon Animations": ["de":"Neon-Animationen","fr":"Animations néon","es":"Animaciones neón","it":"Animazioni neon"],
            "Close Preview": ["de":"Vorschau schließen","fr":"Fermer l’aperçu","es":"Cerrar vista previa","it":"Chiudi anteprima"],
            "Reboot unavailable": ["de":"Neustart nicht verfügbar","fr":"Redémarrage indisponible","es":"Reinicio no disponible","it":"Riavvio non disponibile"],
            "Bootstrap Status": ["de":"Bootstrap-Status","fr":"État Bootstrap","es":"Estado Bootstrap","it":"Stato Bootstrap"],
            "Compatibility Check": ["de":"Kompatibilitätsprüfung","fr":"Vérification compatibilité","es":"Comprobación compatibilidad","it":"Verifica compatibilità"],
            "Check Compatibility": ["de":"Kompatibilität prüfen","fr":"Vérifier compatibilité","es":"Comprobar compatibilidad","it":"Verifica compatibilità"],
            "Sileo Detection": ["de":"Sileo-Erkennung","fr":"Détection Sileo","es":"Detección Sileo","it":"Rilevamento Sileo"],
            "Detect Sileo": ["de":"Sileo erkennen","fr":"Détecter Sileo","es":"Detectar Sileo","it":"Rileva Sileo"],
            "Open Sileo": ["de":"Sileo öffnen","fr":"Ouvrir Sileo","es":"Abrir Sileo","it":"Apri Sileo"],
            "Sileo Installer Manager": ["de":"Sileo-Installationsmanager","fr":"Gestionnaire installation Sileo","es":"Gestor instalación Sileo","it":"Gestore installazione Sileo"],
            "Check Installation Requirements": ["de":"Installationsvoraussetzungen prüfen","fr":"Vérifier les prérequis","es":"Comprobar requisitos","it":"Verifica requisiti"],
            "Install Sileo": ["de":"Sileo installieren","fr":"Installer Sileo","es":"Instalar Sileo","it":"Installa Sileo"],
            "Installation Logs": ["de":"Installationsprotokoll","fr":"Journal installation","es":"Registro instalación","it":"Log installazione"],
            "Clear Logs": ["de":"Protokoll löschen","fr":"Effacer le journal","es":"Borrar registro","it":"Cancella log"]
        ]
        return translations[key]?[lang] ?? key
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
    @AppStorage("appLanguage") private var appLanguage = "de"

    @State private var pulsing = false
    @State private var showSettings = false
    @State private var showBootstrap = false
    @State private var deviceChecked = false
    @State private var showDrip = false
    @State private var pendingDrip = false
    @State private var showRebootNotice = false
    @State private var showSystemLogs = false
    @State private var interfaceReloadCount = 0

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
                        title: JRLanguage.text("Bootstrap Manager", appLanguage),
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
        .sheet(isPresented: $showSettings, onDismiss: {
            if pendingDrip {
                pendingDrip = false
                showDrip = true
            }
        }) {
            settingsView
        }
        .sheet(isPresented: $showBootstrap) {
            NavigationStack {
                BootstrapView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(JRLanguage.text("Done", appLanguage)) { showBootstrap = false }
                                .tint(accent)
                        }
                    }
            }
        }
        .fullScreenCover(isPresented: $showDrip) {
            UltimateDripView(accent: accent) { showDrip = false }
        }
        .alert(JRLanguage.text("Reboot unavailable", appLanguage), isPresented: $showRebootNotice) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("A sandboxed iOS app cannot reboot the device. No reboot was performed.")
        }
        .sheet(isPresented: $showSystemLogs) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("[INFO] JailRa1n 0.6 started")
                        Text("[INFO] iOS: \(JailRa1nDevice.iosVersion)")
                        Text("[INFO] Device: \(JailRa1nDevice.identifier)")
                        Text("[WARN] No bootstrap engine configured")
                        Text("[INFO] UI reloads: \(interfaceReloadCount)")
                    }
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                .background(Color.black)
                .navigationTitle(JRLanguage.text("System Logs", appLanguage))
                .toolbar { Button(JRLanguage.text("Done", appLanguage)) { showSystemLogs = false } }
            }
        }
        .onAppear { pulsing = true }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JailRa1n").font(.headline).foregroundColor(.white)
                Text("Version 0.6").font(.caption).foregroundColor(.gray)
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
            Text("INTERFACE PREVIEW 0.6")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundColor(accent)
        }
    }

    private var deviceCard: some View {
        JRCard(accent: accent) {
            Label(JRLanguage.text("Device Information", appLanguage), systemImage: "iphone")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: JRLanguage.text("Device Name", appLanguage), value: JailRa1nDevice.name)
            JRInfoRow(title: JRLanguage.text("iPhone Model", appLanguage), value: JailRa1nDevice.identifier)
            JRInfoRow(title: JRLanguage.text("iOS Version", appLanguage), value: JailRa1nDevice.iosVersion)
            JRInfoRow(title: "Jailbreak", value: JRLanguage.text("Not Verified", appLanguage))
        }
    }

    private var engineCard: some View {
        JRCard(accent: accent) {
            Label(JRLanguage.text("Jailbreak Engine", appLanguage), systemImage: "cpu")
                .font(.headline).foregroundColor(accent)
            Divider()
            Label(JRLanguage.text("Unavailable", appLanguage), systemImage: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
            Text("No jailbreak or bootstrap engine is included.")
                .font(.subheadline).foregroundColor(.gray)
        }
    }

    private var deviceCheckCard: some View {
        VStack(spacing: 10) {
            JRActionButton(
                title: JRLanguage.text("Check Device", appLanguage),
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
            Text("JailRa1n • Version 0.6").foregroundColor(accent)
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
                    Text(JRLanguage.text("Customize JailRa1n", appLanguage))
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
                    VStack(alignment: .leading, spacing: 12) {
                        Label(JRLanguage.text("Language / Sprache", appLanguage), systemImage: "globe")
                            .foregroundColor(accent)
                            .font(.headline)
                        Picker("Language", selection: $appLanguage) {
                            Text("Deutsch").tag("de")
                            Text("English").tag("en")
                            Text("Français").tag("fr")
                            Text("Español").tag("es")
                            Text("Italiano").tag("it")
                        }
                        .tint(accent)
                        Text(appLanguage == "de" ? "Sprache gespeichert. Die wichtigsten Menüs sind übersetzt." : "Language saved. Main menus are translated.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))

                    VStack(spacing: 12) {
                        Label(JRLanguage.text("Power & Animation", appLanguage), systemImage: "bolt.fill")
                            .font(.headline)
                            .foregroundColor(accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button {
                            pendingDrip = true
                            showSettings = false
                        } label: {
                            Label(JRLanguage.text("Respring – Ultimate Drip Preview", appLanguage), systemImage: "drop.fill")
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(accent, in: RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(.black)
                        }
                        Button {
                            showRebootNotice = true
                        } label: {
                            Label(JRLanguage.text("Reboot – Unavailable", appLanguage), systemImage: "power")
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(.white)
                        }
                        Button {
                            interfaceReloadCount += 1
                            deviceChecked = false
                            pulsing = false
                            showSettings = false
                            DispatchQueue.main.async { pulsing = true }
                        } label: {
                            Label(JRLanguage.text("Restart JailRa1n UI", appLanguage), systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity).padding(14)
                                .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(.white)
                        }
                        Button { showSystemLogs = true } label: {
                            Label(JRLanguage.text("System Logs", appLanguage), systemImage: "terminal")
                                .frame(maxWidth: .infinity).padding(14)
                                .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                                .foregroundColor(.white)
                        }
                        Text(appLanguage == "de" ? "Diese Funktionen verändern weder SpringBoard noch starten sie iOS neu." : "These controls do not modify SpringBoard or reboot iOS.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))

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
            .navigationTitle(JRLanguage.text("Settings", appLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(JRLanguage.text("Done", appLanguage)) { showSettings = false }
                        .tint(accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Bootstrap and Sileo manager

struct BootstrapView: View {
    @AppStorage("appLanguage") private var appLanguage = "de"
    @AppStorage("selectedTheme") private var selectedTheme = "green"

    @State private var sileoChecked = false
    @State private var sileoDetected = false
    @State private var compatibilityChecked = false
    @State private var installerChecked = false
    @State private var logs: [String] = [
        "[INFO] JailRa1n 0.6 initialized",
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
                Text(JRLanguage.text("Bootstrap Manager", appLanguage))
                    .font(.title.bold())
                    .foregroundColor(accent)
                Text("JailRa1n 0.6 • Sileo Installer")
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
            Label(JRLanguage.text("Bootstrap Status", appLanguage), systemImage: "cube.box.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Bootstrap", value: "Not Installed")
            JRInfoRow(title: "Engine", value: JRLanguage.text("Unavailable", appLanguage))
            JRInfoRow(title: "Environment", value: "App Sandbox")
            JRInfoRow(title: "System Access", value: "Not Available")
        }
    }

    private var compatibilityCard: some View {
        JRCard(accent: accent) {
            Label(JRLanguage.text("Compatibility Check", appLanguage), systemImage: "checkmark.shield.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Device", value: JailRa1nDevice.identifier)
            JRInfoRow(title: JRLanguage.text("iOS Version", appLanguage), value: JailRa1nDevice.iosVersion)
            if compatibilityChecked {
                Text("No supported bootstrap engine is configured.")
                    .font(.caption).foregroundColor(.orange)
            }
            JRActionButton(
                title: JRLanguage.text("Check Compatibility", appLanguage),
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
            Label(JRLanguage.text("Sileo Detection", appLanguage), systemImage: "magnifyingglass")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(
                title: "Sileo Status",
                value: sileoChecked
                    ? (sileoDetected ? "Detected" : "Not Detected")
                    : "Not Checked"
            )
            JRActionButton(
                title: JRLanguage.text("Detect Sileo", appLanguage),
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
                    Label(JRLanguage.text("Open Sileo", appLanguage), systemImage: "arrow.up.right.square")
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
            Label(JRLanguage.text("Sileo Installer Manager", appLanguage), systemImage: "square.and.arrow.down.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            JRInfoRow(title: "Installer Status", value: JRLanguage.text("Unavailable", appLanguage))
            JRInfoRow(title: "Bootstrap Engine", value: "Not Configured")
            JRInfoRow(title: "System Permissions", value: JRLanguage.text("Unavailable", appLanguage))
            if installerChecked {
                Label(
                    "Installation blocked: no compatible bootstrap engine.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.caption)
                .foregroundColor(.orange)
            }
            JRActionButton(
                title: JRLanguage.text("Check Installation Requirements", appLanguage),
                symbol: "shield.lefthalf.filled",
                accent: accent
            ) {
                runInstallerCheck()
            }
            Label(JRLanguage.text("Install Sileo", appLanguage), systemImage: "lock.fill")
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
            Label(JRLanguage.text("Installation Logs", appLanguage), systemImage: "terminal")
                .font(.headline).foregroundColor(accent)
            Divider()
            ForEach(logs.indices, id: \.self) { index in
                Text(logs[index])
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(
                        logs[index].contains("[WARN]") ? .orange : accent
                    )
            }
            Button(JRLanguage.text("Clear Logs", appLanguage)) { logs.removeAll() }
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


// MARK: - Ultimate Drip: animated liquid, droplets, splash and ripples

private struct LiquidDrop: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let x = rect.midX
        p.move(to: CGPoint(x: x, y: rect.minY))
        p.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.69),
                   control1: CGPoint(x: rect.maxX * 0.72, y: rect.minY + rect.height * 0.32),
                   control2: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.49))
        p.addArc(center: CGPoint(x: x, y: rect.minY + rect.height * 0.69),
                 radius: rect.width / 2, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
        p.addCurve(to: CGPoint(x: x, y: rect.minY),
                   control1: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.49),
                   control2: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.32))
        p.closeSubpath()
        return p
    }
}

struct UltimateDripView: View {
    let accent: Color
    let dismiss: () -> Void
    @AppStorage("appLanguage") private var appLanguage = "de"
    @State private var startDate = Date()
    @State private var isClosing = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            GeometryReader { geometry in
                let width = min(geometry.size.width - 32, 370.0)
                VStack(spacing: 0) {
                    Spacer(minLength: 12)
                    ZStack {
                        LiquidDrop()
                            .fill(LinearGradient(colors: [.white.opacity(0.85), accent, accent.opacity(0.55)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 168, height: 194)
                            .shadow(color: accent, radius: 23)
                            .scaleEffect(1 + 0.025 * sin(elapsed * 3))
                            .offset(y: -26)
                        ForEach(0..<7, id: \.self) { index in
                            LiquidDripParticle(
                                phase: (elapsed * 0.52 + Double(index) * 0.17).truncatingRemainder(dividingBy: 1),
                                accent: accent, strandLength: 38, fallDistance: 115,
                                width: CGFloat(5 + index % 3)
                            )
                            .offset(x: CGFloat(index - 3) * 19, y: 66)
                        }
                    }
                    .frame(height: 245)

                    // Drips originate at the lower edge of the letters, not in a separate row.
                    ZStack(alignment: .top) {
                        Text("JailRa1n")
                            .font(.system(size: 43, weight: .black, design: .rounded))
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                            .foregroundColor(accent)
                            .shadow(color: accent, radius: 14)
                            .offset(x: elapsed.truncatingRemainder(dividingBy: 2.8) > 2.68 ? 3 : 0)
                        ForEach(0..<8, id: \.self) { index in
                            LiquidDripParticle(
                                phase: (elapsed * 0.43 + Double(index) * 0.137).truncatingRemainder(dividingBy: 1),
                                accent: accent, strandLength: CGFloat(19 + index % 3 * 9),
                                fallDistance: 125, width: CGFloat(4 + index % 3)
                            )
                            .offset(x: CGFloat(index - 3) * (width / 9.6), y: 38)
                        }
                    }
                    .frame(width: width, height: 53, alignment: .top)
                    .zIndex(2)

                    // Keep the splash and ripples within their own animation area.
                    ZStack {
                        ForEach(0..<3, id: \.self) { index in
                            let phase = (elapsed * 0.68 + Double(index) / 3).truncatingRemainder(dividingBy: 1)
                            Ellipse()
                                .stroke(accent.opacity(1 - phase), lineWidth: 2)
                                .frame(width: 25 + 180 * phase, height: 7 + 28 * phase)
                                .offset(y: 49)
                        }
                        ForEach(0..<12, id: \.self) { index in
                            let phase = (elapsed * 0.68 + Double(index % 3) / 3).truncatingRemainder(dividingBy: 1)
                            Circle()
                                .fill(accent.opacity(1 - phase))
                                .frame(width: CGFloat(3 + index % 3), height: CGFloat(3 + index % 3))
                                .offset(x: CGFloat(index - 6) * 9 * phase,
                                        y: 49 - CGFloat(32 + index % 4 * 9) * sin(phase * .pi))
                        }
                    }
                    .frame(height: 178)

                    Text("RESPRING • ANIMATION PREVIEW")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(.gray)
                        .padding(.top, 12)

                    Spacer(minLength: 24)

                    Button(action: close) {
                        Text(JRLanguage.text("Close Preview", appLanguage))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(accent.opacity(0.45)))
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .background(
                    RadialGradient(colors: [accent.opacity(0.14), .black], center: .center,
                                   startRadius: 10, endRadius: 310)
                )
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear {
            startDate = Date()
            isClosing = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) { close() }
        }
    }

    private func close() {
        guard !isClosing else { return }
        isClosing = true
        dismiss()
    }
}

// The strand first stretches from its anchor, then a rounded drop detaches and falls.
private struct LiquidDripParticle: View {
    let phase: Double
    let accent: Color
    let strandLength: CGFloat
    let fallDistance: CGFloat
    let width: CGFloat

    var body: some View {
        let grow = min(1.0, phase / 0.34)
        let attached = phase < 0.48
        let falling = max(0.0, (phase - 0.48) / 0.52)
        ZStack(alignment: .top) {
            if attached {
                Capsule()
                    .fill(accent)
                    .frame(width: width, height: 5 + strandLength * CGFloat(grow))
                    .shadow(color: accent, radius: 7)
                    .offset(y: 0)
                Circle()
                    .fill(accent)
                    .frame(width: width + 3, height: width + 3)
                    .shadow(color: accent, radius: 7)
                    .offset(y: strandLength * CGFloat(grow))
            } else {
                Ellipse()
                    .fill(accent)
                    .frame(width: width + 3, height: width * 1.8 + 5)
                    .shadow(color: accent, radius: 9)
                    .offset(y: strandLength + fallDistance * CGFloat(falling * falling))
            }
        }
        .frame(width: width + 6, height: 6, alignment: .top)
    }
}
