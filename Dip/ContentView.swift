import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject private var blocker = Blocker()
    @State private var showPicker = false
    @Environment(\.scenePhase) private var phase

    var body: some View {
        VStack(spacing: 28) {
            Button {
                blocker.locked ? blocker.unlock() : blocker.lock()
            } label: {
                Image(systemName: blocker.locked ? "lock.fill" : "lock.open")
                    .font(.system(size: 72, weight: .semibold))
                    .foregroundStyle(blocker.locked ? Color(.systemBackground) : .primary)
                    .frame(width: 220, height: 220)
                    .background(Circle().fill(blocker.locked ? Color.primary : .clear))
                    .overlay(Circle().strokeBorder(Color.primary, lineWidth: 3))
            }
            .disabled(!blocker.locked && !blocker.hasApps)
            .opacity(!blocker.locked && !blocker.hasApps ? 0.3 : 1)
            .animation(.snappy, value: blocker.locked)

            Button { showPicker = true } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 56, height: 44)
                    .overlay(Capsule().strokeBorder(Color.primary, lineWidth: 1.5))
            }
        }
        .buttonStyle(.plain)
        .familyActivityPicker(isPresented: $showPicker, selection: $blocker.selection)
        .onChange(of: phase) { if phase == .active { blocker.refresh() } }
    }
}
