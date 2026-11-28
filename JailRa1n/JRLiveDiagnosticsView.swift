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
            "Supported iOS Versions": ["de":"Unterstützte iOS-Versionen","fr":"Versions iOS prises en charge","es":"Versiones de iOS compatibles","it":"Versioni iOS supportate"],
            "Supported Versions Note": ["de":"Angezeigter Zielbereich der App-Oberfläche. Ein Jailbreak ist derzeit nicht integriert; die tatsächliche Kompatibilität hängt vom Gerät und der iOS-Version ab.","fr":"Plage de versions prévue pour l’interface. Aucun jailbreak n’est intégré actuellement.","es":"Rango previsto para la interfaz. Actualmente no incluye un jailbreak.","it":"Intervallo previsto per l’interfaccia. Nessun jailbreak è attualmente integrato."],
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
            "Package Managers": ["de":"Paketmanager","fr":"Gestionnaires de paquets","es":"Gestores de paquetes","it":"Gestori di pacchetti"],
            "Detect Cydia": ["de":"Cydia erkennen","fr":"Détecter Cydia","es":"Detectar Cydia","it":"Rileva Cydia"],
            "Open Cydia": ["de":"Cydia öffnen","fr":"Ouvrir Cydia","es":"Abrir Cydia","it":"Apri Cydia"],
            "Check Package Managers": ["de":"Paketmanager prüfen","fr":"Vérifier les gestionnaires","es":"Comprobar gestores","it":"Verifica gestori"],
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
    @State private var showJailbreakDashboard = false
    @State private var showLiveDiagnostics = false
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
                    supportedVersionsCard
                    engineCard
                    JRActionButton(
                        title: "Live-Diagnose 1.9",
                        symbol: "waveform.path.ecg",
                        accent: accent
                    ) {
                        showLiveDiagnostics = true
                    }
                    JRActionButton(
                        title: "Jailbreak-Zentrale öffnen",
                        symbol: "lock.shield",
                        accent: accent
                    ) {
                        showJailbreakDashboard = true
                    }
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
        .sheet(isPresented: $showLiveDiagnostics) {
            JRLiveDiagnosticsView()
        }
        .sheet(isPresented: $showJailbreakDashboard) {
            NavigationStack {
                JailRa1nJailbreakDashboard(accent: accent)
            }
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
                        Text("[INFO] JailRa1n 1.1 started")
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
                Text("Version 1.9").font(.caption).foregroundColor(.gray)
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
            Text("Sileo & Cydia Edition")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("INTERFACE PREVIEW 1.1")
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

    private var supportedVersionsCard: some View {
        JRCard(accent: accent) {
            Label(JRLanguage.text("Supported iOS Versions", appLanguage),
                  systemImage: "checkmark.shield.fill")
                .font(.headline)
                .foregroundColor(accent)

            Divider()

            Text("iOS 16.0 – iOS 27.0.1")
                .font(.system(size: 23, weight: .bold, design: .rounded))
                .foregroundColor(accent)
                .frame(maxWidth: .infinity)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(JRLanguage.text("Supported Versions Note", appLanguage))
                .font(.caption)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
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
            Text("JailRa1n • Version 1.2").foregroundColor(accent)
            Text("Sileo & Cydia Preview • No Exploit")
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

                    NavigationLink {
                        JailRa1nCreditsView(accent: accent)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "heart.text.square.fill")
                                .foregroundColor(accent)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Open Source & Credits")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(appLanguage == "de" ? "Dopamine, Entwickler & Lizenzen" : "Dopamine, developers & licenses")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

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
    @State private var cydiaChecked = false
    @State private var cydiaDetected = false
    @State private var compatibilityChecked = false
    @State private var installerChecked = false
    @State private var logs: [String] = [
        "[INFO] JailRa1n 1.1 initialized",
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
                Text("JailRa1n 1.1 • Sileo & Cydia Manager")
                    .font(.caption)
                    .foregroundColor(.gray)
                statusCard
                compatibilityCard
                packageManagersCard
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

    private var packageManagersCard: some View {
        JRCard(accent: accent) {
            Label(JRLanguage.text("Package Managers", appLanguage), systemImage: "shippingbox.fill")
                .font(.headline).foregroundColor(accent)
            Divider()
            packageManagerRow(name: "Sileo", symbol: "square.stack.3d.up.fill",
                              checked: sileoChecked, detected: sileoDetected,
                              scheme: "sileo://")
            Divider()
            packageManagerRow(name: "Cydia", symbol: "archivebox.fill",
                              checked: cydiaChecked, detected: cydiaDetected,
                              scheme: "cydia://")
            JRActionButton(title: JRLanguage.text("Check Package Managers", appLanguage),
                           symbol: "magnifyingglass", accent: accent) {
                detectPackageManagers()
            }
            Text(appLanguage == "de"
                 ? "Die Prüfung erkennt nur registrierte URL-Schemes. Sie bestätigt weder eine funktionierende Installation noch einen Jailbreak."
                 : "This checks registered URL schemes only. It does not confirm a working installation or jailbreak.")
                .font(.caption).foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private func packageManagerRow(name: String, symbol: String, checked: Bool,
                                   detected: Bool, scheme: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(name, systemImage: symbol)
                .font(.headline).foregroundColor(.white)
            HStack {
                Text(appLanguage == "de" ? "Status" : "Status")
                    .foregroundColor(.gray)
                Spacer()
                Text(!checked ? (appLanguage == "de" ? "Nicht geprüft" : "Not checked")
                     : detected ? (appLanguage == "de" ? "URL-Scheme erkannt" : "URL scheme detected")
                     : (appLanguage == "de" ? "Nicht erkannt" : "Not detected"))
                    .foregroundColor(detected ? accent : .orange)
            }
            .font(.subheadline)
            if detected {
                Button {
                    guard let url = URL(string: scheme) else { return }
                    UIApplication.shared.open(url, options: [:]) { success in
                        logs.append(success ? "[INFO] \(name) opened" : "[WARN] Could not open \(name)")
                    }
                } label: {
                    Label(name == "Sileo" ? JRLanguage.text("Open Sileo", appLanguage)
                          : JRLanguage.text("Open Cydia", appLanguage),
                          systemImage: "arrow.up.right.square")
                        .foregroundColor(accent)
                }
            }
        }
    }

    private var installerCard: some View {
        JRCard(accent: accent) {
            Label(appLanguage == "de" ? "Installationsstatus" : "Installation Status", systemImage: "square.and.arrow.down.fill")
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
            Label(appLanguage == "de" ? "Sileo / Cydia installieren – gesperrt" : "Install Sileo / Cydia – disabled", systemImage: "lock.fill")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding(15)
                .background(
                    Color.white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 15)
                )
            Text(appLanguage == "de" ? "Installation deaktiviert: keine kompatible Bootstrap-Engine integriert." : "Installation is disabled: no compatible bootstrap is integrated.")
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

    private func detectPackageManagers() {
        sileoChecked = true
        cydiaChecked = true
        sileoDetected = URL(string: "sileo://").map { UIApplication.shared.canOpenURL($0) } ?? false
        cydiaDetected = URL(string: "cydia://").map { UIApplication.shared.canOpenURL($0) } ?? false
        logs.append(sileoDetected ? "[INFO] Sileo URL scheme detected" : "[WARN] Sileo URL scheme not detected")
        logs.append(cydiaDetected ? "[INFO] Cydia URL scheme detected" : "[WARN] Cydia URL scheme not detected")
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

                    // Impact-driven splashes: each drop hits the liquid surface,
                    // creates a crown of tiny droplets, then expanding ripples.
                    ZStack {
                        Ellipse()
                            .fill(accent.opacity(0.07))
                            .frame(width: 220, height: 25)
                            .offset(y: 53)
                        ForEach(0..<3, id: \.self) { impact in
                            // Each cycle has its own impact time.
                            let cycle = (elapsed * 0.68 + Double(impact) / 3.0)
                                .truncatingRemainder(dividingBy: 1.0)
                            // Impact happens once the falling droplet reaches the pool.
                            let splash = max(0.0, min(1.0, (cycle - 0.54) / 0.40))
                            let active = cycle >= 0.54 && cycle < 0.94
                            let hitX = CGFloat(impact - 1) * 38.0

                            if active {
                                // Liquid crown expands and fades after impact.
                                Ellipse()
                                    .stroke(accent.opacity((1 - splash) * 0.95), lineWidth: 2.5)
                                    .frame(width: 16 + CGFloat(splash) * 125,
                                           height: 5 + CGFloat(splash) * 23)
                                    .shadow(color: accent, radius: 8)
                                    .offset(x: hitX, y: 53)

                                ForEach(0..<11, id: \.self) { particle in
                                    let angle = Double(particle) * .pi / 10.0
                                    let speed = CGFloat(25 + (particle % 4) * 12)
                                    let t = CGFloat(splash)
                                    // Ballistic motion: rise first, then fall.
                                    let dx = cos(angle) * speed * t
                                    let dy = -sin(angle) * speed * (2 * t - t * t)
                                        + 27 * t * t
                                    LiquidSplashSpeck(accent: accent,
                                                      size: CGFloat(3 + particle % 4))
                                        .opacity(1 - splash)
                                        .offset(x: hitX + dx, y: 53 + dy)
                                }
                                // A liquid crown grows from the impact point, opens,
                                // and collapses while beads fly away from its rim.
                                LiquidSplashCrown(opening: CGFloat(splash))
                                    .fill(
                                        LinearGradient(
                                            colors: [accent.opacity(0.96 * (1 - splash)),
                                                     accent.opacity(0.42 * (1 - splash))],
                                            startPoint: .top, endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 25 + CGFloat(splash) * 75,
                                           height: 19 + CGFloat(splash) * 28)
                                    .shadow(color: accent, radius: 12)
                                    .offset(x: hitX, y: 53 - CGFloat(splash) * 13)

                                // A bright center flash emphasizes the instant of impact.
                                Ellipse()
                                    .fill(accent.opacity(max(0, 1 - splash * 3)))
                                    .frame(width: 20 + CGFloat(splash) * 28, height: 7)
                                    .shadow(color: accent, radius: 13)
                                    .offset(x: hitX, y: 53)
                            }
                        }
                        // Ambient concentric rings keep the pool alive.
                        ForEach(0..<3, id: \.self) { ring in
                            let phase = (elapsed * 0.36 + Double(ring) / 3.0)
                                .truncatingRemainder(dividingBy: 1.0)
                            Ellipse()
                                .stroke(accent.opacity((1 - phase) * 0.55), lineWidth: 1.5)
                                .frame(width: 35 + CGFloat(phase) * 210,
                                       height: 8 + CGFloat(phase) * 33)
                                .offset(y: 53)
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

// Tiny glowing liquid beads thrown outward by a droplet impact.
private struct LiquidSplashSpeck: View {
    let accent: Color
    let size: CGFloat

    var body: some View {
        Ellipse()
            .fill(accent)
            .frame(width: size, height: size * 1.5)
            .shadow(color: accent, radius: 5)
    }
}


// A curved, open liquid crown with five raised tips. The shape grows wider
// and shallower as the splash progresses; the bottom remains in the pool.
private struct LiquidSplashCrown: Shape {
    var opening: CGFloat

    var animatableData: CGFloat {
        get { opening }
        set { opening = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let t = min(max(opening, 0), 1)
        let bottom = rect.maxY
        let top = rect.minY + rect.height * (0.04 + 0.48 * t)
        let mid = rect.midY + rect.height * 0.20
        let left = rect.minX
        let right = rect.maxX
        let w = rect.width
        var p = Path()
        p.move(to: CGPoint(x: left, y: bottom))
        p.addQuadCurve(to: CGPoint(x: left + w * 0.06, y: top + rect.height * 0.16),
                       control: CGPoint(x: left - w * 0.05, y: mid))
        // Alternating raised peaks and rounded valleys form the splash rim.
        let rim: [(CGFloat, CGFloat)] = [
            (0.06, 0.16), (0.16, 0.02), (0.25, 0.28),
            (0.36, 0.08), (0.50, 0.31), (0.64, 0.08),
            (0.75, 0.28), (0.84, 0.02), (0.94, 0.16)
        ]
        for (x, y) in rim {
            p.addLine(to: CGPoint(x: left + w * x,
                                  y: top + rect.height * y * (1 - 0.35 * t)))
        }
        p.addQuadCurve(to: CGPoint(x: right, y: bottom),
                       control: CGPoint(x: right + w * 0.05, y: mid))
        p.addQuadCurve(to: CGPoint(x: left, y: bottom),
                       control: CGPoint(x: rect.midX, y: bottom - rect.height * 0.22))
        p.closeSubpath()
        return p
    }
}

// MARK: - Open source credits

struct JailRa1nCreditsView: View {
    let accent: Color
    @AppStorage("appLanguage") private var appLanguage = "de"

    private var german: Bool { appLanguage == "de" }

    var body: some View {
        List {
            Section("Dopamine") {
                Text(german
                     ? "Dopamine wurde von Lars Fröder (opa334) und Mitwirkenden entwickelt."
                     : "Dopamine was developed by Lars Fröder (opa334) and contributors.")
                Link(destination: URL(string: "https://github.com/opa334/Dopamine")!) {
                    Label(german ? "Offizielles Dopamine-Projekt" : "Official Dopamine project",
                          systemImage: "arrow.up.right.square")
                }
                .foregroundColor(accent)
            }

            Section("JailRa1n") {
                Text(german
                     ? "JailRa1n ist ein unabhängiges Projekt und nicht offiziell mit Dopamine oder dessen Entwicklern verbunden."
                     : "JailRa1n is an independent project and is not officially affiliated with Dopamine or its developers.")
                Text(german
                     ? "Aktuell enthält JailRa1n keine Dopamine-Jailbreak-Engine und kann keinen Jailbreak durchführen."
                     : "JailRa1n currently does not include the Dopamine jailbreak engine and cannot perform a jailbreak.")
                    .foregroundColor(.secondary)
            }

            Section(german ? "Lizenzen und Hinweise" : "Licenses and notices") {
                Text(german
                     ? "Vor einer Übernahme von fremdem Quellcode müssen die Lizenzbedingungen aller verwendeten Komponenten geprüft werden. Erforderliche Copyright- und Lizenztexte müssen vollständig erhalten bleiben."
                     : "Before incorporating third-party code, the licenses of all included components must be reviewed. Required copyright and license notices must be preserved in full.")
                Link(destination: URL(string: "https://github.com/opa334/Dopamine/blob/master/LICENSE")!) {
                    Label(german ? "Lizenz im Originalprojekt ansehen" : "View license in original repository",
                          systemImage: "doc.text")
                }
                .foregroundColor(accent)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .navigationTitle("Open Source & Credits")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}


// MARK: - Jailbreak Dashboard (diagnostics only, no exploit)

private struct JailRa1nJailbreakDashboard: View {
    let accent: Color

    @Environment(\.dismiss) private var dismiss
    @State private var checked = false

    private var engineReport: JRJailbreakEngine.Report {
        JRJailbreakEngine.diagnose(
            deviceIdentifier: JailRa1nDevice.identifier,
            iosVersion: JailRa1nDevice.iosVersion
        )
    }

    private var isTargetDevice: Bool { engineReport.targetDevice }
    private var isTargetOS: Bool { engineReport.targetOS }

    private var compatibilityText: String {
        if isTargetDevice && isTargetOS {
            return "Zielgerät erkannt – Engine fehlt"
        }
        if isTargetDevice {
            return "iPhone X erkannt – iOS außerhalb des Zielbereichs"
        }
        return "Kein unterstütztes Jailbreak-Zielgerät"
    }

    private var compatibilityColor: Color {
        isTargetDevice && isTargetOS ? .green : .orange
    }

    private var diagnosticProgress: Double {
        checked ? 1.0 : 0.0
    }

    private var diagnosticLog: [String] {
        guard checked else {
            return ["[INFO] Diagnose noch nicht gestartet.",
                    "[INFO] Keine Jailbreak-Engine eingebunden."]
        }
        return [
            "[INFO] Geräteprüfung gestartet",
            "[INFO] Engine-Readiness: \(engineReport.readiness.rawValue)",
            "[INFO] Modell: \(JailRa1nDevice.identifier)",
            "[INFO] iOS: \(JailRa1nDevice.iosVersion)",
            isTargetDevice
                ? "[OK] iPhone X als Forschungsziel erkannt"
                : "[INFO] Gerät ist nicht das iPhone-X-Zielgerät",
            isTargetOS
                ? "[OK] iOS 16.7.x erkannt"
                : "[INFO] Andere iOS-Version erkannt",
            "[INFO] Ergebnis: \(compatibilityText)",
            "[INFO] Dopamine-Kompatibilität muss offiziell geprüft werden",
            "[INFO] Alternative: palera1n (Computer erforderlich)",
            "[INFO] Recherche ist kein Geräte- oder Exploit-Test",
            "[INFO] Engine-Schnittstelle: vorbereitet (1.6)",
            "[INFO] Provider: \(JRJailbreakEngine.providerName)",
            "[INFO] Checkliste: \(engineReport.passedChecks)/\(engineReport.checks.count)",
            "[WARN] Exploit-Engine: nicht integriert",
            "[WARN] Bootstrap: nicht integriert",
            "[WARN] Sileo-Installation: nicht verfügbar",
            "[INFO] Diagnose abgeschlossen; kein Jailbreak ausgeführt"
        ]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 54))
                            .foregroundColor(accent)
                            .shadow(color: accent.opacity(0.5), radius: 18)

                        Text("JailRa1n Jailbreak")
                            .font(.title.bold())
                            .foregroundColor(.white)

                        Text("PROVIDER & DIAGNOSTICS • 1.6")
                            .font(.caption.monospaced())
                            .tracking(2)
                            .foregroundColor(accent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)

                    JRCard(accent: accent) {
                        Label("Gerätekompatibilität", systemImage: "iphone")
                            .font(.headline)
                            .foregroundColor(accent)
                        Divider()
                        JRInfoRow(title: "Gerät", value: JailRa1nDevice.identifier)
                        JRInfoRow(title: "iOS", value: JailRa1nDevice.iosVersion)
                        JRInfoRow(title: "Forschungsziel", value: "iPhone X · iOS 16.7.x")
                        JRInfoRow(title: "Engine", value: "Nicht integriert")
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: isTargetDevice && isTargetOS
                                  ? "checkmark.circle.fill"
                                  : "exclamationmark.triangle.fill")
                            Text(compatibilityText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(.caption)
                        .foregroundColor(compatibilityColor)
                    }

                    JRCard(accent: accent) {
                        Label("Dopamine-Anbindung", systemImage: "link")
                            .font(.headline)
                            .foregroundColor(accent)
                        Divider()
                        JRInfoRow(title: "Projektstatus", value: "Vorbereitung")
                        JRInfoRow(title: "Native Engine", value: "Nicht eingebunden")
                        JRInfoRow(title: "Exploit-Ausführung", value: "Deaktiviert")
                        Text("JailRa1n ist ein unabhängiges Projekt. Die technische "
                             + "Verwendung externer Komponenten erfordert eine "
                             + "separate Lizenz- und Integrationsprüfung.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    JRCard(accent: accent) {
                        Label("Jailbreak-Wege · Recherche", systemImage: "checkmark.shield")
                            .font(.headline)
                            .foregroundColor(accent)
                        Divider()
                        JRInfoRow(title: "Ziel", value: "iPhone X · iOS 16.7.15")
                        JRInfoRow(title: "Dopamine", value: "Kompatibilität prüfen")
                        JRInfoRow(title: "palera1n", value: "Alternative mit Computer")
                        JRInfoRow(title: "Lokale Integration", value: "Nicht vorhanden")
                        Text("Die genaue Geräte- und Versionsunterstützung muss anhand "
                             + "offizieller Projektangaben geprüft werden. "
                             + "Dopamine ist ein eigenständiges Jailbreak-Projekt. "
                             + "Bei palera1n ist für das iPhone X ein Computer nötig; "
                             + "auf iOS 16 gelten zusätzliche Passcode-Einschränkungen.")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Link(destination: URL(string: "https://ios.cfw.guide/installing-dopamine/")!) {
                            Label("Dopamine-Anleitung", systemImage: "arrow.up.right.square")
                                .foregroundColor(accent)
                        }
                        Link(destination: URL(string: "https://docs.palera.in/installing-palera1n/")!) {
                            Label("palera1n-Anleitung", systemImage: "arrow.up.right.square")
                                .foregroundColor(accent)
                        }
                        Text("Bitte vor einem echten Jailbreak ein Backup erstellen "
                             + "und die Anleitung für die installierte Version prüfen.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    JRCard(accent: accent) {
                        Label("Engine-Schnittstelle", systemImage: "cpu")
                            .font(.headline)
                            .foregroundColor(accent)
                        Divider()
                        JRInfoRow(title: "Provider", value: JRJailbreakEngine.providerName)
                        JRInfoRow(title: "Schnittstelle", value: "v\(JRJailbreakEngine.interfaceVersion)")
                        JRInfoRow(title: "Geräte-Readiness", value: engineReport.readiness.rawValue)
                        JRInfoRow(title: "Adapter", value: engineReport.adapterStatus)
                        JRInfoRow(title: "Prüfungen erfüllt", value: "\(engineReport.passedChecks)/\(engineReport.checks.count)")
                        JRInfoRow(title: "Native Implementierung", value: "Fehlt")
                        JRInfoRow(title: "Jailbreak-Start", value: "Gesperrt")
                        JRInfoRow(title: "Sileo-Setup", value: "Gesperrt")
                        JRNeonTerminal(
                            title: "ENGINE-DIAGNOSE 1.7",
                            lines: engineReport.lines,
                            accent: Color(red: 0.45, green: 1.0, blue: 0.0)
                        )
                        Text("Die Schnittstelle führt keine Exploits aus. "
                             + "Dopamine ist nicht in dieser App enthalten. "
                             + "Eine echte Integration benötigt native "
                             + "Komponenten, Lizenzprüfung und Gerätetests.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    JRCard(accent: accent) {
                        Label("Provider-Checkliste", systemImage: "checklist")
                            .font(.headline)
                            .foregroundColor(accent)
                        Divider()
                        Text("\(engineReport.passedChecks) von \(engineReport.checks.count) Prüfungen erfüllt")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        ProgressView(value: Double(engineReport.passedChecks),
                                     total: Double(engineReport.checks.count))
                            .tint(accent)
                        ForEach(engineReport.checks) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: item.status == .passed
                                      ? "checkmark.circle.fill"
                                      : item.status == .pending
                                      ? "clock.fill" : "xmark.circle.fill")
                                    .foregroundColor(item.status == .passed ? accent : .orange)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.title)
                                        .foregroundColor(.white)
                                        .font(.subheadline.bold())
                                    Text(item.detail)
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                Spacer(minLength: 6)
                                Text(item.status.rawValue)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        Text("Die Checkliste prüft nur bekannte Informationen und vorhandene App-Komponenten. Sie beweist keine Jailbreak-Kompatibilität.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    JRCard(accent: accent) {
                        Label("Fortschritt der Geräteprüfung",
                              systemImage: "waveform.path.ecg")
                            .font(.headline)
                            .foregroundColor(accent)

                        ProgressView(value: diagnosticProgress)
                            .tint(accent)

                        Text(checked
                             ? "Geräteprüfung abgeschlossen (kein Jailbreak)."
                             : "Geräteprüfung noch nicht ausgeführt.")
                            .font(.caption)
                            .foregroundColor(.gray)

                        JRActionButton(
                            title: checked ? "Erneut prüfen" : "Gerät jetzt prüfen",
                            symbol: "checkmark.shield",
                            accent: accent
                        ) {
                            checked = true
                        }
                    }

                    JRCard(accent: accent) {
                        Label("Jailbreak starten",
                              systemImage: "lock.open.fill")
                            .font(.headline)
                            .foregroundColor(accent)

                        Button(action: {}) {
                            Label("Jailbreak starten – nicht verfügbar",
                                  systemImage: "lock.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(15)
                        }
                        .disabled(true)
                        .background(Color.gray.opacity(0.2),
                                    in: RoundedRectangle(cornerRadius: 14))

                        Text("Der Button bleibt gesperrt, bis eine geeignete "
                             + "Jailbreak-Engine rechtmäßig integriert und "
                             + "auf dem Zielgerät getestet wurde.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    JRCard(accent: accent) {
                        Label("Sileo-Installation", systemImage: "shippingbox.fill")
                            .font(.headline)
                            .foregroundColor(accent)
                        JRInfoRow(title: "Bootstrap", value: "Nicht eingerichtet")
                        JRInfoRow(title: "Sileo", value: "Installation gesperrt")
                        Text("Eine Sileo-Installation ist erst nach einem "
                             + "funktionierenden Jailbreak und Bootstrap möglich.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    JRCard(accent: accent) {
                        HStack {
                            Label("Diagnoseprotokoll", systemImage: "terminal")
                                .font(.headline)
                                .foregroundColor(accent)
                            Spacer()
                            Button("Kopieren") {
                                UIPasteboard.general.string =
                                    diagnosticLog.joined(separator: "\n")
                            }
                            .font(.caption)
                            .foregroundColor(accent)
                        }

                        JRNeonTerminal(
                            title: "SYSTEM LOG",
                            lines: diagnosticLog,
                            accent: Color(red: 0.45, green: 1.0, blue: 0.0)
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Jailbreak-Zentrale")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Fertig") { dismiss() }
                    .tint(accent)
            }
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Stable neon terminal (display-only)
private struct JRNeonTerminal: View {
    let title: String
    let lines: [String]
    let accent: Color

    @State private var visibleText = ""
    @State private var replayID = 0
    @State private var scrollTick = 0

    private var fullText: String { lines.joined(separator: "\n") }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(accent).frame(width: 7, height: 7)
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                Spacer()
                Button { replayID += 1 } label: {
                    Label("Replay", systemImage: "arrow.clockwise")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                }
                .accessibilityLabel("Terminal-Animation erneut starten")
            }
            .foregroundColor(accent)

            Rectangle().fill(accent.opacity(0.35)).frame(height: 1)

            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(visibleText)
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .textSelection(.enabled)
                        Color.clear.frame(height: 1).id("terminalBottom")
                    }
                }
                .frame(height: 230)
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onChange(of: scrollTick) { _ in
                    proxy.scrollTo("terminalBottom", anchor: .bottom)
                }
            }

            Text("● READ ONLY  /  KEIN SYSTEMZUGRIFF")
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(accent.opacity(0.65))
        }
        .padding(14)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accent.opacity(0.65), lineWidth: 1)
        )
        .cornerRadius(12)
        .task(id: replayID) {
            visibleText = ""
            scrollTick = 0
            let characters = Array(fullText)
            var position = 0
            var steps = 0
            while position < characters.count {
                if Task.isCancelled { return }
                position = min(position + 12, characters.count)
                visibleText = String(characters.prefix(position))
                steps += 1
                // Scroll less often to avoid continuous layout jumps.
                if steps % 5 == 0 || position == characters.count {
                    scrollTick += 1
                }
                do {
                    try await Task.sleep(nanoseconds: 65_000_000)
                } catch {
                    return
                }
            }
        }
    }
}
