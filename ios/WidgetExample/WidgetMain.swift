import WidgetKit
import SwiftUI

// This file composes the widget views for small/medium/large and uses the Provider
struct EntryView : View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            MediumWidgetView(entry: entry)
        }
    }
}

@main
struct MixzerWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MixzerWidget()
    }
}
