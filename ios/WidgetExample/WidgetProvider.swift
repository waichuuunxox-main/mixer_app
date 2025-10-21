// This is an example Swift file intended to be copied into a Widget Extension
// target in Xcode. It demonstrates reading a shared JSON file from the App
// Group container and providing a Timeline entry.

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextMatch: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextMatch: "Team A vs Team B")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), nextMatch: readSharedJSON() ?? "—")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), nextMatch: readSharedJSON() ?? "—")
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*15)))
        completion(timeline)
    }

    private func readSharedJSON() -> String? {
        // Replace with your App Group identifier
        let appGroup = "group.com.waichuuun.mixzer"
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else { return nil }
        let fileURL = container.appendingPathComponent("mixzer_widget_summary.json")
        if let data = try? Data(contentsOf: fileURL) {
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                return json["nextMatch"] as? String
            }
        }
        return nil
    }
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.nextMatch)
            .padding()
    }
}

@main
struct MixzerWidget: Widget {
    let kind: String = "MixzerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mixzer Next Match")
        .description("Shows the next match from Mixzer app")
    }
}
