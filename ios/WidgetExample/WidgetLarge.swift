import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    var entry: SimpleEntry
    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack(alignment: .leading) {
                Text("Next Match").font(.caption)
                Text(entry.nextMatch).font(.largeTitle).lineLimit(2)
                Spacer()
                Text(entry.date, style: .time).font(.footnote)
            }.padding()
        }
    }
}
