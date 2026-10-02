import AppIntents

struct NoAppsError: Error, CustomLocalizedStringResourceConvertible {
    var localizedStringResource: LocalizedStringResource { "앱을 먼저 선택하세요." }
}

struct LockIntent: AppIntent {
    static let title: LocalizedStringResource = "잠그기"
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        guard Shared.hasApps else { throw NoAppsError() }
        Shared.lock()
        return .result()
    }
}

struct UnlockIntent: AppIntent {
    static let title: LocalizedStringResource = "풀기"
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        Shared.unlock()
        return .result()
    }
}

struct ToggleLockIntent: AppIntent {
    static let title: LocalizedStringResource = "Dip 전환"
    static let openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        if Shared.locked {
            Shared.unlock()
        } else {
            guard Shared.hasApps else { throw NoAppsError() }
            Shared.lock()
        }
        return .result()
    }
}

struct SetLockIntent: SetValueIntent {
    static let title: LocalizedStringResource = "잠금 설정"
    static let openAppWhenRun = false

    @Parameter(title: "잠금")
    var value: Bool

    func perform() async throws -> some IntentResult {
        if value {
            guard Shared.hasApps else { throw NoAppsError() }
            Shared.lock()
        } else {
            Shared.unlock()
        }
        return .result()
    }
}
