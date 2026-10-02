import SwiftUI
import FamilyControls

@main
struct DipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                }
        }
    }
}
