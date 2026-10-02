import Foundation
import FamilyControls

@MainActor
final class Blocker: ObservableObject {
    @Published var selection = Shared.selection {
        didSet { Shared.selection = selection }
    }
    @Published private(set) var locked = Shared.locked

    var hasApps: Bool { Shared.hasApps }

    func lock() {
        Shared.lock()
        locked = true
    }

    func unlock() {
        Shared.unlock()
        locked = false
    }

    /// 위젯·단축어가 바꾼 상태 반영.
    func refresh() {
        locked = Shared.locked
    }
}
