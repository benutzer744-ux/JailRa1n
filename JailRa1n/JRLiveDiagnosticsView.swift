
import SwiftUI
import UIKit
import Darwin

struct JRLiveDiagnosticsView: View {
    @State private var lines: [String] = []

    private let green = Color(
        red: 0.50,
        green: 1.0,
        blue: 0.0
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("JAILRA1N 1.9")
                        .font(.title2.bold())

                    Text("LIVE DIAGNOSTICS")
                        .font(.caption.monospaced())

                    Divider()
                        .overlay(green)

                    ForEach(lines, id: \.self) { line in
                        Text(line)
                            .font(.system(
                                size: 13,
                                design: .monospaced
                            ))
                    }

                    Button("DIAGNOSE ERNEUT STARTEN") {
                        runDiagnostics()
                    }
                    .buttonStyle(.bordered)
                    .tint(green)
                    .padding(.top, 20)
                }
                .foregroundStyle(green)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Engine-Diagnose")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                runDiagnostics()
            }
        }
    }

    private func runDiagnostics() {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(
                to: CChar.self,
                capacity: MemoryLayout.size(
                    ofValue: systemInfo.machine
                )
            ) {
                String(cString: $0)
            }
        }

        let version = UIDevice.current.systemVersion

        lines = [
            "> INITIALIZING JAILRA1N...",
            "> DEVICE: \(machine)",
            "> IOS: \(version)",
            "[OK] DEVICE INFORMATION READ",
            "[WARN] NATIVE ENGINE NOT CONNECTED",
            "[INFO] DOPAMINE NOT VERIFIED",
            "[INFO] SILEO NOT VERIFIED",
            "[SAFE] NO SYSTEM CHANGES",
            "> READY"
        ]
    }
}
