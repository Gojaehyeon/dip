import AppIntents

struct DipShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ToggleLockIntent(),
            phrases: ["\(.applicationName) 전환", "\(.applicationName) 토글", "Toggle \(.applicationName)"],
            shortTitle: "잠금 전환",
            systemImageName: "lock.rotation"
        )
    }
}
