import AppIntents

struct DipShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LockIntent(),
            phrases: ["\(.applicationName) 잠가", "\(.applicationName) 잠그기", "Lock \(.applicationName)"],
            shortTitle: "잠그기",
            systemImageName: "lock.fill"
        )
        AppShortcut(
            intent: UnlockIntent(),
            phrases: ["\(.applicationName) 풀어", "\(.applicationName) 풀기", "Unlock \(.applicationName)"],
            shortTitle: "풀기",
            systemImageName: "lock.open.fill"
        )
    }
}
