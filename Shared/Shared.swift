import Foundation
import FamilyControls
import ManagedSettings
import WidgetKit

/// 앱·위젯·단축어가 함께 쓰는 상태와 동작.
enum Shared {
    static let defaults = UserDefaults(suiteName: "group.com.tntlabs.dip")!
    static let store = ManagedSettingsStore()

    static var selection: FamilyActivitySelection {
        get {
            guard let data = defaults.data(forKey: "selection"),
                  let s = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            else { return FamilyActivitySelection() }
            return s
        }
        set {
            defaults.set(try? JSONEncoder().encode(newValue), forKey: "selection")
            if locked { applyShield() }
        }
    }

    static var locked: Bool {
        get { defaults.bool(forKey: "locked") }
        set { defaults.set(newValue, forKey: "locked") }
    }

    static var hasApps: Bool {
        let s = selection
        return !s.applicationTokens.isEmpty || !s.categoryTokens.isEmpty || !s.webDomainTokens.isEmpty
    }

    static func lock() {
        applyShield()
        locked = true
        reloadWidgets()
    }

    static func unlock() {
        store.clearAllSettings()
        locked = false
        reloadWidgets()
    }

    private static func applyShield() {
        let s = selection
        store.shield.applications = s.applicationTokens.isEmpty ? nil : s.applicationTokens
        store.shield.applicationCategories = s.categoryTokens.isEmpty ? nil : .specific(s.categoryTokens)
        store.shield.webDomains = s.webDomainTokens.isEmpty ? nil : s.webDomainTokens
        store.shield.webDomainCategories = s.categoryTokens.isEmpty ? nil : .specific(s.categoryTokens)
    }

    private static func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
        if #available(iOS 18.0, *) {
            ControlCenter.shared.reloadAllControls()
        }
    }
}
