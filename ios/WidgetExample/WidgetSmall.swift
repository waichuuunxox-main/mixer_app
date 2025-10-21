import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    var entry: SimpleEntry
    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack(alignment: .leading) {
                Text("Next").font(.caption)
                Text(entry.nextMatch).font(.headline).lineLimit(1)
            }.padding()
        }
    }
}
