import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextMatch: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextMatch: "-")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), nextMatch: "Team A vs Team B"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), nextMatch: "Team A vs Team B")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct MixzerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.nextMatch)
            .padding()
    }
}

@main
struct MixzerWidget: Widget {
    let kind: String = "mixzer_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MixzerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mixzer")
        .description("Shows the next match")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
