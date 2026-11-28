import SwiftUI
import UIKit
import Darwin

// JailRa1n 2.0: UI and read-only diagnostics. No jailbreak exploit is included.
struct ContentView: View {
    @State private var deviceID = "Lade..."
    @State private var osVersion = UIDevice.current.systemVersion
    @State private var terminalLines: [String] = []
    @State private var shownLines = 0
    @State private var showDiagnostics = false
    @State private var showBootstrap = false
    @State private var showSettings = false
    @State private var showDevice = false

    private let neon = Color(red: 0.50, green: 1.0, blue: 0.0)
    private let panel = Color(red: 0.055, green: 0.085, blue: 0.065)

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 6) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(neon)
                    Text("JailRa1n")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(neon)
                    Text("VERSION 2.0 · JAILBREAK CONTROL CENTER")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(neon.opacity(0.75))
                }
                .padding(.top, 24)

                VStack(spacing: 14) {
                    infoRow("Gerät", deviceID)
                    infoRow("iOS-Version", osVersion)
                    infoRow("App-Status", "Bereit", highlight: neon)
                    infoRow("Jailbreak-Engine", "Nicht verbunden", highlight: .orange)
                }
                .padding(20)
                .background(panel, in: RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(neon.opacity(0.28)))

                VStack(alignment: .leading, spacing: 13) {
                    HStack {
                        Label("LIVE TERMINAL", systemImage: "terminal")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                        Spacer()
                        Image(systemName: "waveform.path.ecg")
                    }
                    Rectangle().fill(neon.opacity(0.25)).frame(height: 1)
                    VStack(alignment: .leading, spacing: 7) {
                        ForEach(0..<shownLines, id: \.self) { index in
                            Text(terminalLines[index])
                                .font(.system(size: 11, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("> _")
                            .font(.system(size: 11, design: .monospaced))
                    }
                    .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
                }
                .foregroundStyle(neon)
                .padding(18)
                .background(Color(red: 0.01, green: 0.025, blue: 0.01), in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(neon.opacity(0.28)))

                VStack(spacing: 5) {
                    Label("JAILBREAK STARTEN", systemImage: "lock.fill")
                        .font(.system(size: 17, weight: .bold))
                    Text("Deaktiviert – keine Engine integriert")
                        .font(.system(size: 11))
                }
                .foregroundStyle(Color(red: 0.7, green: 0.85, blue: 0.65))
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(Color(red: 0.13, green: 0.24, blue: 0.08), in: RoundedRectangle(cornerRadius: 18))
                .accessibilityLabel("Jailbreak starten, deaktiviert, keine Engine integriert")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    actionButton("Gerät prüfen", icon: "checkmark.shield") { showDevice = true }
                    actionButton("Diagnose", icon: "terminal") { showDiagnostics = true }
                    actionButton("Bootstrap", icon: "shippingbox") { showBootstrap = true }
                    actionButton("Einstellungen", icon: "gearshape") { showSettings = true }
                }
                Text("JailRa1n 2.0 · Engine Diagnostics")
                    .font(.caption2)
                    .foregroundStyle(neon.opacity(0.7))
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear(perform: refresh)
        .sheet(isPresented: $showDiagnostics) {
            diagnosticSheet
        }
        .sheet(isPresented: $showDevice) {
            detailSheet(title: "Gerät prüfen", message: "Gerät: \(deviceID)\niOS: \(osVersion)\n\nDie App kann Geräteinformationen lesen. Eine Jailbreak-Kompatibilität wird nicht bestätigt.")
        }
        .sheet(isPresented: $showBootstrap) {
            detailSheet(title: "Bootstrap-Manager", message: "Kein Bootstrap-Installer eingebunden. Diese Ansicht führt keine Systemänderungen durch.")
        }
        .sheet(isPresented: $showSettings) {
            detailSheet(title: "Einstellungen", message: "JailRa1n 2.0\nDiagnosemodus: Nur Lesen\nNative Engine: Nicht verbunden")
        }
    }

    private func infoRow(_ label: String, _ value: String, highlight: Color = .white) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(label).foregroundStyle(.gray)
            Spacer(minLength: 4)
            Text(value)
                .foregroundStyle(highlight)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .font(.system(size: 14))
    }

    private func actionButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                Image(systemName: icon).font(.title3)
                Text(title).font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, minHeight: 75)
            .background(neon, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var diagnosticSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(terminalLines, id: \.self) { line in
                        Text(line).font(.system(size: 13, design: .monospaced))
                    }
                    Button("DIAGNOSE ERNEUT STARTEN") { refresh() }
                        .buttonStyle(.borderedProminent)
                        .tint(neon)
                        .foregroundStyle(.black)
                        .padding(.top)
                }
                .foregroundStyle(neon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(.black)
            .navigationTitle("Live-Diagnose 2.0")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Fertig") { showDiagnostics = false } } }
        }
        .preferredColorScheme(.dark)
    }

    private func detailSheet(title: String, message: String) -> some View {
        NavigationStack {
            ScrollView {
                Text(message)
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundStyle(neon)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(.black)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
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
            "> BOOTING JAILRA1N 2.0...",
            "[OK] DEVICE: \(deviceID)",
            "[OK] IOS: \(osVersion)",
            "[OK] DIAGNOSTICS ACTIVE",
            "[INFO] DOPAMINE NOT VERIFIED",
            "[WARN] JAILBREAK ENGINE MISSING",
            "[SAFE] NO SYSTEM CHANGES"
        ]
        shownLines = 0
        animateNextLine()
    }

    private func animateNextLine() {
        guard shownLines < terminalLines.count else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            guard shownLines < terminalLines.count else { return }
            shownLines += 1
            animateNextLine()
        }
    }
}
