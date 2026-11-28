import Foundation
import UIKit
import Darwin

/// JailRa1n 1.8: diagnostics and a safe boundary for a future native provider.
/// This file does not contain or execute a jailbreak exploit.
struct JRDeviceReport {
    let modelIdentifier: String
    let systemVersion: String
    let isTargetHardware: Bool
    let isTargetOSFamily: Bool
    let providerAvailable: Bool

    var summary: String {
        "Device: \(modelIdentifier) | iOS \(systemVersion) | Native provider: \(providerAvailable ? "available" : "not integrated")"
    }
}

enum JRNativeEngineError: LocalizedError {
    case providerNotIntegrated

    var errorDescription: String? {
        switch self {
        case .providerNotIntegrated:
            return "Keine geprüfte native Jailbreak-Engine integriert. Es wurden keine Systemänderungen vorgenommen."
        }
    }
}

protocol JRNativeJailbreakProvider {
    var identifier: String { get }
    func start(completion: @escaping (Result<Void, Error>) -> Void)
}

final class JRNativeEngineBridge {
    static let shared = JRNativeEngineBridge()

    // Keep nil until a reviewed, compatible native implementation exists.
    private var provider: JRNativeJailbreakProvider?

    private init() {}

    func report() -> JRDeviceReport {
        let model = Self.hardwareIdentifier()
        let os = UIDevice.current.systemVersion
        return JRDeviceReport(
            modelIdentifier: model,
            systemVersion: os,
            isTargetHardware: model == "iPhone10,3" || model == "iPhone10,6",
            isTargetOSFamily: os == "16.7.15",
            providerAvailable: provider != nil
        )
    }

    func startJailbreak(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let provider = provider else {
            completion(.failure(JRNativeEngineError.providerNotIntegrated))
            return
        }
        provider.start(completion: completion)
    }

    private static func hardwareIdentifier() -> String {
        var info = utsname()
        uname(&info)
        var machine = info.machine
        return withUnsafeBytes(of: &machine) { bytes in
            String(decoding: bytes.prefix(while: { $0 != 0 }), as: UTF8.self)
        }
    }
}
