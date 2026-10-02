import WidgetKit
import SwiftUI
import AppIntents

struct Entry: TimelineEntry {
    let date: Date
    let locked: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry { Entry(date: .now, locked: false) }
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: .now, locked: Shared.locked))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        completion(Timeline(entries: [Entry(date: .now, locked: Shared.locked)], policy: .never))
    }
}

struct DipWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: Entry

    var body: some View {
        Button(intent: ToggleLockIntent()) {
            if family == .accessoryCircular {
                Image(systemName: entry.locked ? "lock.fill" : "lock.open")
                    .font(.system(size: 26, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Circle().fill(entry.locked ? Color.primary : .clear))
                    .foregroundStyle(entry.locked ? Color(.systemBackground) : .primary)
                    .overlay(Circle().strokeBorder(Color.primary, lineWidth: 2))
            } else {
                Image(systemName: entry.locked ? "lock.fill" : "lock.open")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(entry.locked ? Color(.systemBackground) : .primary)
                    .frame(width: 110, height: 110)
                    .background(Circle().fill(entry.locked ? Color.primary : .clear))
                    .overlay(Circle().strokeBorder(Color.primary, lineWidth: 2.5))
            }
        }
        .buttonStyle(.plain)
    }
}

struct DipWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "DipWidget", provider: Provider()) { entry in
            DipWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color(.systemBackground) }
        }
        .configurationDisplayName("Dip")
        .description("잠그기 / 풀기")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

@available(iOS 18.0, *)
struct DipControlProvider: ControlValueProvider {
    var previewValue: Bool { false }
    func currentValue() async throws -> Bool { Shared.locked }
}

@available(iOS 18.0, *)
struct DipControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "DipControl", provider: DipControlProvider()) { locked in
            ControlWidgetToggle("Dip", isOn: locked, action: SetLockIntent()) { on in
                Image(systemName: on ? "lock.fill" : "lock.open")
            }
        }
        .displayName("Dip")
    }
}

@main
struct DipWidgets: WidgetBundle {
    var body: some Widget {
        DipWidget()
        if #available(iOS 18.0, *) {
            DipControl()
        }
    }
}
